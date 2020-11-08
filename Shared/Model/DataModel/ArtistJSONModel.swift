//
//  Artist.swift
//  Qin
//
//  Created by 林少龙 on 2020/10/1.
//

import Foundation
import CoreData

struct ArtistJSONModel: Codable, Identifiable {
    var accountId: Int?
    var albumSize: Int
    var alias: [String]
    var briefDesc: String
    var followed: Bool?// optional for MV
    var id: Int64
    var img1v1Id: Int
    var img1v1Id_str: String?
    var img1v1Url: String
    var musicSize: Int
    var mvSize: Int?// optional for Album
    var name: String?
    var picId: Int
    var picId_str: String?// optional for Album
    var picUrl: String
    var publishTime: Int?// optional for Album
    var topicPerson: Int
    var trans: String
}

extension ArtistJSONModel {
    func toDictionary() -> Dictionary<String, Any> {
        return ["id": self.id, "name": self.name ?? ""]
    }
    public func toArtistEntity(context: NSManagedObjectContext) -> Artist {
        let entity = Artist(context: context)
        entity.followed = self.followed ?? false
        entity.id = self.id
        entity.img1v1Url = self.img1v1Url
        entity.name = self.name
        return entity
    }
}
