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
        return container
    }()
    typealias ResponseData = Dictionary<String, Any>
    func userLogin(_ user: User) {
        userLogout()
        let accountData = NSEntityDescription.insertNewObject(forEntityName: "AccountData", into: persistentContainer.viewContext) as! AccountData
        do {
            accountData.userData = try JSONEncoder().encode(user)
        }catch let error {
            print(error)
        }
        save()
    }
    func userLogout() {
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
    func getUser() -> User? {
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
    func save() {
        do {
            try persistentContainer.viewContext.save()
        }catch let error {
            print("DataManager save \(error)")
        }
    }
}
