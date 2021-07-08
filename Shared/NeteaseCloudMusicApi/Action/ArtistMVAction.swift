//
//  ArtistMVAction.swift
//  Qin
//
//  Created by 林少龙 on 2021/6/6.
//

import Foundation
//歌手MV
public struct ArtistMVAction: NeteaseCloudMusicAction {
    public struct ArtistMVParameters: Encodable {
        public var artistId: Int
        public var limit: Int
        public var offset: Int
        public var total: Bool
    }
    public typealias Parameters = ArtistMVParameters
    public typealias Response = ArtistMVResponse

    public var uri: String { "/weapi/artist/mvs" }
    public let parameters: Parameters
    public let responseType = Response.self
}
