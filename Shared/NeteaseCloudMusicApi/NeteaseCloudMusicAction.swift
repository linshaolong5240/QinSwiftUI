//
//  NeteaseCloudMusicAction.swift
//  Qin
//
//  Created by qfdev on 2021/5/26.
//

import Foundation

public struct AlbumAction: NeteaseCloudMusicAction {
    public struct AlbumParameters: Encodable {
        var id: Int
    }
    public typealias Parameters = AlbumParameters
    public typealias ResponseType = AlbumResponse

    public var uri: String { "/weapi/v1/album/\(parameters.id)"}
    public let parameters: Parameters
    public let responseType = ResponseType.self
}

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
