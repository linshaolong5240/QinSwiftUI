//
//  NCMSongLikeAction.swift
//  Qin
//
//  Created by 林少龙 on 2021/6/6.
//  Copyright © 2022 com.teenloong. All rights reserved.
//

import Foundation
//喜欢歌曲
public struct NCMSongLikeAction: NCMAction {
    public struct SongLikeParameters: Encodable {
        public var alg: String = "itembased"
        public var trackId: Int
        public var like: Bool
        public var time: Int = 3
    }
    public typealias Parameters = SongLikeParameters
    public typealias Response = NCMSongLikeResponse

    public var uri: String { "/weapi/radio/like" }
    public var parameters: Parameters?
    public var responseType = Response.self
    
    public init(id: Int, like: Bool) {
        self.parameters = Parameters(trackId: id, like: like)
    }
}

public struct NCMSongLikeResponse: NCMResponse {
    public var code: Int
    public var playlistId: Int
//    public var songs: [Any]
    public var message: String?
}
