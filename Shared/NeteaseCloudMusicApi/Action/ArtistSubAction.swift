//
//  ArtistSubAction.swift
//  Qin
//
//  Created by 林少龙 on 2021/6/6.
//

import Foundation
//歌手收藏
public struct ArtistSubAction: NeteaseCloudMusicAction {
    public struct ArtistSubParameters: Encodable {
        public var artistId: Int
        public var artistIds: [Int]
    }
    public typealias Parameters = ArtistSubParameters
    public typealias Response = ArtistSubResponse

    public var sub: Bool
    public var uri: String { "/weapi/artist/\(sub ? "sub" : "unsub")" }
    public let parameters: Parameters
    public let responseType = Response.self
}
