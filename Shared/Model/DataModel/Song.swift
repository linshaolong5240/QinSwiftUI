//
//  Song.swift
//  Qin
//
//  Created by 林少龙 on 2020/10/26.
//

import Foundation
import CoreData

final class Song: NSManagedObject {
@NSManaged fileprivate(set) var id: Int64
@NSManaged var like: Bool
@NSManaged fileprivate(set) var name: String
}
