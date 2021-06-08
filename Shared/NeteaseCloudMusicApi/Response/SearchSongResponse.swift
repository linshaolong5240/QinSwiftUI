//
//  SearchSongResponse.swift
//  Qin
//
//  Created by 林少龙 on 2021/6/9.
//

import Foundation

public struct SearchSongResponse: NeteaseCloudMusicResponse {
    public struct Result: Codable {
        public struct Song: Codable {
            public struct Album: Codable {
                public let alia: [String]?
                public let artist: Artist
                public let copyrightId, id, mark: Int
                public let name: String
                public let picId: Double
                public let publishTime, size, status: Int
            }
            public struct Artist: Codable {
                public let albumSize: Int
                public let alias: [String]
                public let id, img1v1: Int
                public let img1v1Url: String
                public let name: String
                public let picId: Int
                public let picUrl: String?
    //            public let trans: Any?
            }
            public let album: Album
            public let alias: [String]
            public let artists: [Artist]
            public let copyrightId, duration, fee, ftype: Int
            public let id, mark, mvid: Int
            public let name: String
            public let rtype: Int
            public let rUrl: String?
            public let status: Int
        }
        public let hasMore: Bool
        public let songCount: Int
        public let songs: [Song]
    }
    public let code: Int
    public let result: Result
}
