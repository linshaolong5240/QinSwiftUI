//
//  RecommendSongsModel.swift
//  Qin
//
//  Created by 林少龙 on 2020/10/29.
//

import Foundation

struct RecommendSongsJSONModel: Codable {
    struct RecommendReasons: Codable {
        var reason: String
        var songId: Int
    }
    var dailySongs = [SongDetailJSONModel]()
//    var orderSongs: [Any]
    var recommendReasons = [RecommendReasons]()
}
