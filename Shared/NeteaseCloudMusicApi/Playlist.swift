//
//  PlayList.swift
//  Qin
//
//  Created by 林少龙 on 2020/6/19.
//  Copyright © 2020 teenloong. All rights reserved.
//

import Foundation

struct Playlist: Codable, Identifiable {
    struct TrackId: Codable, Identifiable {
//        var alg: Any?
        var at: Int
        var id: Int
        var v: Int
    }
    var adType: Int
    var alg: String?
    var anonimous: Bool?// optional for user playlsit
//    var artists: Any?
    var backgroundCoverId: Int?
    var backgroundCoverUrl: String?
    var cloudTrackCount: Int
    var commentCount: Int?
    var commentThreadId: String
    var coverImgId: Int
    var coverImgId_str: String?//optional for user playlist
    var coverImgUrl: String
    var coverStatus: Int?
    var createTime: Int
    var creator: Creator
    var description: String?
//    var englishTitle: Any?
    var highQuality: Bool
    var id: Int
    var name: String
    var newImported: Bool
    var opRecommend: Bool?
    var ordered: Bool
    var playCount: Int
    var privacy: Int
//    var recommendInfo: Any?
    var shareCount: Int?//optional for playlist detail
    var specialType: Int
    var status: Int
    var subscribed: Bool
    var subscribedCount: Int
//    var subscribers: [Any]
    var tags: [String]?
    var titleImage: Int?
    var titleImageUrl: String?
    var totalDuration: Int?//optional for playlist detail
    var trackCount: Int
    var trackNumberUpdateTime: Int
    var trackUpdateTime: Int
    var trackIds: [TrackId]?
    var tracks: [SongDetail]?//optional for user playlist
//    var updateFrequency: Any?
    var updateTime: Int
    var userId: Int
}

struct RecommendPlaylist: Codable, Identifiable {
    var alg: String
    var copywriter: String
    var createTime: Int
    var creator: Creator
    var id: Int
    var name: String
    var picUrl: String
    var playcount: Int
    var trackCount: Int
    var type: Int
    var userId: Int
}

struct RecommendSongsPlaylist: Codable {
    struct RecommendReasons: Codable {
        var reason: String
        var songId: Int
    }
    var dailySongs: [SongDetail]
//    var orderSongs: [Any]
    var recommendReasons: [RecommendReasons]
}
