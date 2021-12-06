//
//  RecommendPlaylistResponse.swift
//  Qin
//
//  Created by 林少龙 on 2021/6/9.
//

import Foundation

public struct RecommendPlaylistResponse: NeteaseCloudMusicResponse {
    public struct RecommendPlaylist: Codable {
        public var alg, copywriter: String
        public var createTime: Int
        public var creator: CrteatorResponse?
        public var id: Int
        public var name: String
        public var picUrl: String
        public var playcount, trackCount, type, userId: Int
    }
    public var code: Int
    public var featureFirst: Bool
    public var haveRcmdSongs: Bool
    public var recommend: [RecommendPlaylist]
    public var message: String?
}
