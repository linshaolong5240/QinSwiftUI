//
//  RecommendSongsResponse.swift
//  Qin
//
//  Created by 林少龙 on 2021/6/8.
//

import Foundation

public struct RecommendSongsResponse: NeteaseCloudMusicResponse {
    public struct RecommendReason: Codable {
        public var reason: String
        public var songId: Int
    }
    public struct DataResponse: Codable {
        public var dailySongs: [SongResponse]
//        public var orderSongs: [Any]
        public var recommendReasons: [RecommendReason]
    }
    public var code: Int
    public var data: DataResponse
    public var message: String?
}
