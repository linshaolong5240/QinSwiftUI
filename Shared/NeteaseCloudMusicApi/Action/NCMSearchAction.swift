//
//  SearchAction.swift
//  Qin
//
//  Created by 林少龙 on 2021/6/9.
//  Copyright © 2022 com.teenloong. All rights reserved.
//

import Foundation

fileprivate var searchURI = "/weapi/search/get"

// 1: 单曲, 10: 专辑, 100: 歌手, 1000: 歌单, 1002: 用户, 1004: MV, 1006: 歌词, 1009: 电台, 1014: 视频
public enum NCMSearchType: Int, Encodable {
    case song = 1
    case album = 10
    case artist = 100
    case playlist = 1000
    case user = 1002
    case mv = 1004
    case lyric = 1006
    case fm = 1009
    case vedio = 1014
}

public struct NCMSearchInfo: Encodable {
    public var s: String
    public var type: NCMSearchType
    public var limit: Int
    public var offset: Int
}

public struct NCMSearchSongAction: NCMAction {
    public typealias Parameters = NCMSearchInfo
    public typealias Response = NCMSearchSongResponse

    public var uri: String { searchURI }
    public var parameters: Parameters?
    public var responseType = Response.self
    
    public init(Info: NCMSearchInfo) {
        self.parameters = Info
    }
}

public struct NCMSearchSongResponse: NCMResponse {
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

public struct NCMSearchPlaylistAction: NCMAction {
    public typealias Parameters = NCMSearchInfo
    public typealias Response = NCMSearchPlaylistResponse

    public var uri: String { searchURI }
    public var parameters: Parameters?
    public var responseType = Response.self
}

public struct NCMSearchPlaylistResponse: NCMResponse {
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
