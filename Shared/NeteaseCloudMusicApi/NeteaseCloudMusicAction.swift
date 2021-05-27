//
//  NeteaseCloudMusicAction.swift
//  Qin
//
//  Created by qfdev on 2021/5/26.
//

import Foundation

//专辑内容
public struct AlbumAction: NeteaseCloudMusicAction {
    public struct AlbumParameters: Encodable {
    }
    public typealias Parameters = AlbumParameters
    public typealias ResponseType = AlbumResponse
    
    public let id: Int
    public var uri: String { "/weapi/v1/album/\(id)"}
    public let parameters = Parameters()
    public let responseType = ResponseType.self
}

//收藏与取消收藏专辑
public struct AlbumSubAction: NeteaseCloudMusicAction {
    public struct AlbumSubParameters: Encodable {
        var id: Int
    }
    public typealias Parameters = AlbumSubParameters
    public typealias ResponseType = AlbumSubResponse
    
    public var uri: String { "/weapi/album/\(sub ? "sub" : "unsub")"}
    public let parameters: Parameters
    public let responseType = ResponseType.self
    
    public let sub: Bool
}

//专辑收藏列表
public struct AlbumSublistAction: NeteaseCloudMusicAction {
    public struct AlbumSublistParameters: Encodable {
        public var limit: Int
        public var offset: Int
        public var total: Bool = true
    }
    public typealias Parameters = AlbumSublistParameters
    public typealias ResponseType = AlbumSublistResponse

    public let uri: String = "/weapi/album/sublist"
    public let parameters: Parameters
    public let responseType = ResponseType.self
}
//歌手收藏列表
public struct ArtistSublistAction: NeteaseCloudMusicAction {
    public struct ArtistSublistParameters: Encodable {
        public var limit: Int
        public var offset: Int
        public var total: Bool = true
    }
    public typealias Parameters = ArtistSublistParameters
    public typealias ResponseType = ArtistSublistResponse

    public let uri: String = "/weapi/artist/sublist"
    public let parameters: Parameters
    public let responseType = ResponseType.self
}
