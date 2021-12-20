//
//  SearchAction.swift
//  Qin
//
//  Created by 林少龙 on 2021/6/9.
//

import Foundation

fileprivate let searchURI = "/weapi/search/get"

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

public struct SearchActionParameters: Encodable {
    public var s: String
    public var type: NCMSearchType
    public var limit: Int
    public var offset: Int
}


public struct SearchSongAction: NeteaseCloudMusicAction {
    public typealias Parameters = SearchActionParameters
    public typealias Response = NCMSearchSongResponse

    public var uri: String { searchURI }
    public let parameters: Parameters
    public let responseType = Response.self
    
    public init(_ parameters: Parameters) {
        self.parameters = parameters
    }
}

public struct SearchPlaylistAction: NeteaseCloudMusicAction {
    public typealias Parameters = SearchActionParameters
    public typealias Response = SearchPlaylistResponse

    public var uri: String { searchURI }
    public let parameters: Parameters
    public let responseType = Response.self
}
