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
    struct SongModel: Codable {
        var al: AlbumModel
        var ar: [ArtistModel]
        var id: Int64
        var name: String
    }
    var dailySongs = [SongDetailJSONModel]()
//    var orderSongs: [Any]
    var recommendReasons = [RecommendReasons]()
}
