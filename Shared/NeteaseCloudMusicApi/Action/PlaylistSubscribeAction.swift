//
//  PlaylistSubscribeAction.swift
//  Qin
//
//  Created by qfdev on 2021/6/8.
//

import Foundation
//歌单收藏
public struct PlaylistSubscribeAction: NeteaseCloudMusicAction {
    public struct PlaylistSubscribeParameters: Encodable {
        public var id: Int
    }
    public typealias Parameters = PlaylistSubscribeParameters
    public typealias ResponseType = PlaylistSubscribeResponse
    
    public let sub: Bool
    public var uri: String { "/weapi/playlist/\(sub ? "subscribe" : "unsubscribe")" }
    public let parameters: Parameters
    public let responseType = ResponseType.self
}
