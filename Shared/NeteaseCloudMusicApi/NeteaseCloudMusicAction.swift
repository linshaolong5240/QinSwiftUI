//
//  NeteaseCloudMusicAction.swift
//  Qin
//
//  Created by qfdev on 2021/5/26.
//

import Foundation

public protocol NeteaseCloudMusicAction {
    associatedtype Parameters: Encodable
    associatedtype ResponseType: Decodable
    
    var uri: String { get }
    var parameters: Parameters { get }
    var responseType: ResponseType.Type { get }
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
