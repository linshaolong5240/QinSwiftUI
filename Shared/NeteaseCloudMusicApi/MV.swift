//
//  MV.swift
//  Qin
//
//  Created by 林少龙 on 2020/10/7.
//

import Foundation

struct MV: Codable, Identifiable {
    var artist: ArtistJSONModel
    var artistName: String
    var duration: Int
    var id: Int64
    var imgurl: String
    var imgurl16v9: String
    var name: String
    var playCount: Int
    var publishTime: String
    var status: Int
    var subed: Bool
}
