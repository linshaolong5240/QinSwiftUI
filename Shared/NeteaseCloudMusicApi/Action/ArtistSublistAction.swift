//
//  ArtistSublistAction.swift
//  Qin
//
//  Created by qfdev on 2021/6/11.
//

import Foundation
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
