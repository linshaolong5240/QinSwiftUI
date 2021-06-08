//
//  RecommendPlaylistResponse.swift
//  Qin
//
//  Created by 林少龙 on 2021/6/9.
//

import Foundation

public struct RecommendPlaylistResponse: NeteaseCloudMusicResponse {
    public struct RecommendPlaylist: Codable {
        public let alg, copywriter: String
        public let createTime: Int
        public let creator: CrteatorResponse?
        public let id: Int
        public let name: String
        public let picUrl: String
        public let playcount, trackCount, type, userId: Int
    }
    public let code: Int
    public let featureFirst: Bool
    public let haveRcmdSongs: Bool
    public let recommend: [RecommendPlaylist]
}
