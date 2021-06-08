//
//  RecommendSongsResponse.swift
//  Qin
//
//  Created by 林少龙 on 2021/6/8.
//

import Foundation

public struct RecommendSongsResponse: NeteaseCloudMusicResponse {
    public struct RecommendReason: Codable {
        public let reason: String
        public let songId: Int
    }
    public struct DataResponse: Codable {
        public let dailySongs: [SongResponse]
//        public let orderSongs: [Any]
        public let recommendReasons: [RecommendReason]
    }
    public let code: Int
    public let data: DataResponse
}
