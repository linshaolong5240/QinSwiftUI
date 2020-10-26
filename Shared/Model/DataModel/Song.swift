//
//  Song.swift
//  Qin
//
//  Created by 林少龙 on 2020/10/26.
//

import Foundation
import CoreData

final class Song: NSManagedObject {
//@NSManaged fileprivate(set) var al: SongAlbum
@NSManaged fileprivate(set) var alia: [String]
@NSManaged fileprivate(set) var id: Int64
@NSManaged var name: String
//    enum CodingKeys: String, CodingKey {
//        case alia = "alia"
//        case id = "id"
//        case name = "name"
//    }
}

struct SongAlbum {
    var id: Int = 0
    var name: String? = nil
    var picUrl: String? = nil
}
