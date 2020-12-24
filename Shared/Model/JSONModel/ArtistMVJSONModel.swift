//
//  MV.swift
//  Qin
//
//  Created by 林少龙 on 2020/10/7.
//

import Foundation
import CoreData

struct ArtistMVJSONModel: Codable, Identifiable {
    var artist: ArtistJSONModel
    var artistName: String
    var duration: Int64
    var id: Int64
    var imgurl: String
    var imgurl16v9: String
    var name: String
    var playCount: Int64
    var publishTime: String
    var status: Int64
    var subed: Bool
}

extension ArtistMVJSONModel {
    public func toMVEntity(context: NSManagedObjectContext) -> MV {
        let entity = MV(context: context)
        entity.artistName = self.artistName
        entity.duration = self.duration
        entity.id = self.id
        entity.imgurl = self.imgurl
        entity.imgurl16v9 = self.imgurl16v9
        entity.name = self.name
        entity.playCount = self.playCount
        entity.publishTime = self.publishTime
        entity.status = self.status
        entity.subed = self.subed
        return entity
    }
}
