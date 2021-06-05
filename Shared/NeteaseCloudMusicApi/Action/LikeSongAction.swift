//
//  LikeSongAction.swift
//  Qin
//
//  Created by 林少龙 on 2021/6/6.
//

import Foundation

//喜欢歌曲
public struct LikeSongAction: NeteaseCloudMusicAction {
    public struct LikeSongParameters: Encodable {
        public var alg: String = "itembased"
        public var trackId: Int
        public var like: Bool
        public var time: Int = 3
    }
    public typealias Parameters = LikeSongParameters
    public typealias ResponseType = LikeSongResponse

    public var uri: String { "/weapi/radio/like" }
    public let parameters: Parameters
    public let responseType = ResponseType.self
}
