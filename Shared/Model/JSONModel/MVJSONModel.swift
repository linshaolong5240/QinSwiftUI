//
//  MVJSONModel.swift
//  Qin
//
//  Created by 林少龙 on 2020/12/7.
//

import Foundation
import CoreData

struct MVJSONModel: Codable, Identifiable {
    struct Artist: Codable {
        var followed: Bool
        var id: Int64
        var img1v1Url: String
        var name: String
    }
    struct BitRate: Codable {
        var br: Int
        var point: Int
        var size: Int
    }
    var artistId: Int64
    var artistName: String
    var artists: [Artist]
    var briefDesc: String
    var brs: [BitRate]
    var commentCount: Int
    var commentThreadId: String
    var cover: String
    var coverId: Int64
    var coverId_str: String
    var desc: String
    var duration: Int
    var id: Int64
    var nType: Int
    var name: String
    var playCount: Int
//    var price: Any?
    var publishTime: String
    var shareCount: Int
    var subCount: Int
//    var videoGroup = [Any]
}

extension MVJSONModel {
    func toEntity(context: NSManagedObjectContext) -> MV {
        let mv = MV(context: context)
        mv.id = self.id
        return mv
    }
}
