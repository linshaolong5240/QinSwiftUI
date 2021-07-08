//
//  UserPlaylistAction.swift
//  Qin
//
//  Created by 林少龙 on 2021/6/6.
//

import Foundation
//用户歌单
public struct UserPlaylistAction: NeteaseCloudMusicAction {
    public struct UserPlaylistParameters: Encodable {
        public var uid: Int
        public var limit: Int
        public var offset: Int
    }
    public typealias Parameters = UserPlaylistParameters
    public typealias Response = UserPlaylistResponse

    public var uri: String { "/weapi/user/playlist" }
    public let parameters: Parameters
    public let responseType = Response.self
}
