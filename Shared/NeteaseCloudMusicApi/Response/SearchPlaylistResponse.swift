//
//  SearchPlaylistResponse.swift
//  Qin
//
//  Created by 林少龙 on 2021/6/9.
//

import Foundation

public struct SearchPlaylistResponse: NeteaseCloudMusicResponse {
    public struct Result: Codable {
        public struct Playlist: Codable {
            public struct Creator: Codable {
                public var authStatus: Int
//                public var experts, expertTags: Any?
                public var nickname: String
                public var userId, userType: Int
            }
            public var alg: String
            public var bookCount: Int
            public var coverImgUrl: String
            public var creator: Creator
            public var playlistDescription: String?
            public var highQuality: Bool
            public var id: Int
            public var name: String
//            public var officialTags: Any?
            public var playCount, specialType: Int
            public var subscribed: Bool
//            public var track: Track
            public var trackCount, userId: Int
        }
        public var hasMore: Bool
        public var playlistCount: Int
        public var playlists: [Playlist]
    }
    public var code: Int
    public var result: Result
    public var message: String?
}
