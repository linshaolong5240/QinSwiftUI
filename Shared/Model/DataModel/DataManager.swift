//
//  DataManager.swift
//  Qin
//
//  Created by 林少龙 on 2020/6/15.
//  Copyright © 2020 teenloong. All rights reserved.
//

import Foundation
import CoreData

class DataManager {
    static let shared = DataManager()
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return container
    }()
    
    public func batchDelete(entityName: String) {
        do {
            let context = persistentContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            let batchDelete = NSBatchDeleteRequest(fetchRequest: request)
            let deleteResult = try context.execute(batchDelete)
            print("\(#function)", deleteResult)
        }catch let error {
            print("\(#function):\(error)")
        }
    }
    public func batchInsert(entityName: String, objects: [[String: Any]]) {
        do {
            let context = persistentContainer.viewContext
            let batchInsert = NSBatchInsertRequest(entityName: entityName, objects: objects)
            var insertResult : NSBatchInsertResult
            insertResult = try context.execute(batchInsert) as! NSBatchInsertResult
            print("insertResult",insertResult)
        }catch let error {
            print("\(#function):\(error)")
        }
    }
    public func batchUpdate(entityName: String, propertiesToUpdate: [AnyHashable : Any], predicate: NSPredicate? = nil) {
        do {
            let context = persistentContainer.viewContext
            let updateRequest = NSBatchUpdateRequest(entityName: entityName)
            updateRequest.propertiesToUpdate = propertiesToUpdate
            updateRequest.predicate = predicate
            
            let updateResult = try context.execute(updateRequest) as! NSBatchUpdateResult
            print("\(#function)",updateResult)
        }catch let error {
            print("\(#function):\(error)")
        }
    }
    public func batchUpdateLike(ids: [Int]) {
        self.batchUpdate(entityName: "Song", propertiesToUpdate: ["like" : true], predicate: NSPredicate(format: "id IN %@", ids))
    }
    public func userLogin(_ user: User) {
        userLogout()
        let accountData = NSEntityDescription.insertNewObject(forEntityName: "AccountData", into: persistentContainer.viewContext) as! AccountData
        do {
            accountData.userData = try JSONEncoder().encode(user)
        }catch let error {
            print(error)
        }
        save()
    }
    public func userLogout() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "AccountData")
        do {
            let accountDatas = try persistentContainer.viewContext.fetch(request)
            for accountData in accountDatas {
                persistentContainer.viewContext.delete(accountData as! NSManagedObject)
            }
            save()
        }catch let error {
            print("DataManager userLogout \(error)")
        }
    }
    public func getUser() -> User? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "AccountData")
        do {
            let accountDatas = try persistentContainer.viewContext.fetch(request)
            if accountDatas.count > 0 {
                return User(accountDatas[0] as! AccountData)
            }
        }catch let error {
            print("DataManager getUser \(error)")
        }
        return nil
    }
    public func save() {
        do {
            try persistentContainer.viewContext.save()
        }catch let error {
            print("DataManager save \(error)")
        }
    }
}
