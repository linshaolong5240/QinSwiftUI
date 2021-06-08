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
                public let authStatus: Int
//                public let experts, expertTags: Any?
                public let nickname: String
                public let userId, userType: Int
            }
            public let alg: String
            public let bookCount: Int
            public let coverImgUrl: String
            public let creator: Creator
            public let playlistDescription: String?
            public let highQuality: Bool
            public let id: Int
            public let name: String
//            public let officialTags: Any?
            public let playCount, specialType: Int
            public let subscribed: Bool
//            public let track: Track
            public let trackCount, userId: Int
        }
        public let hasMore: Bool
        public let playlistCount: Int
        public let playlists: [Playlist]
    }
    public let code: Int
    public let result: Result
}
