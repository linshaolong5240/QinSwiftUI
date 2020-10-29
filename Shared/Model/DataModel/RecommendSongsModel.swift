//
//  RecommendSongsModel.swift
//  Qin
//
//  Created by 林少龙 on 2020/10/29.
//

import Foundation

struct RecommendSongsModel: Codable {
    struct RecommendReasons: Codable {
        var reason: String
        var songId: Int
    }
    var dailySongs = [SongModel]()
//    var orderSongs: [Any]
    var recommendReasons = [RecommendReasons]()
}
