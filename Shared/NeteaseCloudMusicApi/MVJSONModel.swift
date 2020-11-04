//
//  MV.swift
//  Qin
//
//  Created by 林少龙 on 2020/10/7.
//

import Foundation
import CoreData

struct MVJSONModel: Codable, Identifiable {
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

extension MVJSONModel {
    public func toMVEntity(context: NSManagedObjectContext) -> MV {
        let mv = MV(context: context)
        mv.artistName = self.artistName
        mv.duration = self.duration
        mv.id = self.id
        mv.imgurl = self.imgurl
        mv.imgurl16v9 = self.imgurl16v9
        mv.name = self.name
        mv.playCount = self.playCount
        mv.publishTime = self.publishTime
        mv.status = self.status
        mv.subed = self.subed
        return mv
    }
}
