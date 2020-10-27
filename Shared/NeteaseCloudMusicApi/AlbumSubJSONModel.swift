//
//  AlbumSublist.swift
//  Qin
//
//  Created by 林少龙 on 2020/10/9.
//

import Foundation

struct AlbumSubJSONModel: Codable, Identifiable {
    var alias: [String]
    var artists: [ArtistJSONModel]
    var id: Int
//    var msg: [any]
    var name: String
    var picId: Int
    var picUrl: String
    var size: Int
    var subTime: Int
//    var transNames:[Any]
}
