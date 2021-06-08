//
//  SearchAction.swift
//  Qin
//
//  Created by 林少龙 on 2021/6/9.
//

import Foundation

fileprivate let searchURI = "/weapi/search/get"

public enum SearchType: Int, Encodable {
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
    public var type: SearchType
    public var limit: Int
    public var offset: Int
}


public struct SearchSongAction: NeteaseCloudMusicAction {
    public typealias Parameters = SearchActionParameters
    public typealias ResponseType = SearchSongResponse

    public var uri: String { searchURI }
    public let parameters: Parameters
    public let responseType = ResponseType.self
}

public struct SearchPlaylistAction: NeteaseCloudMusicAction {
    public typealias Parameters = SearchActionParameters
    public typealias ResponseType = SearchPlaylistResponse

    public var uri: String { searchURI }
    public let parameters: Parameters
    public let responseType = ResponseType.self
}
