//
//  NCMSearchSongResponse.swift
//  Qin
//
//  Created by 林少龙 on 2021/6/9.
//

import Foundation

public struct NCMSearchSongResponse: NeteaseCloudMusicResponse {
    public struct Result: Codable {
        public struct Song: Codable {
            public struct Album: Codable {
                public var alia: [String]?
                public var artist: Artist
                public var copyrightId, id, mark: Int
                public var name: String
                public var picId: Double
                public var publishTime, size, status: Int
            }
            public struct Artist: Codable {
                public var albumSize: Int
                public var alias: [String]
                public var id, img1v1: Int
                public var img1v1Url: String
                public var name: String
                public var picId: Int
                public var picUrl: String?
    //            public var trans: Any?
            }
            public var album: Album
            public var alias: [String]
            public var artists: [Artist]
            public var copyrightId, duration, fee, ftype: Int
            public var id, mark, mvid: Int
            public var name: String
            public var rtype: Int
            public var rUrl: String?
            public var status: Int
        }
        public var hasMore: Bool?
        public var songCount: Int?
        public var songs: [Song]?
    }
    public var code: Int
    public var result: Result?
    public var message: String?
}
