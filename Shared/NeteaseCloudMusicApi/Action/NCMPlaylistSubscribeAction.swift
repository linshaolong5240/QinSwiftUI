//
//  NCMPlaylistSubscribeAction.swift
//  Qin
//
//  Created by 林少龙 on 2021/6/8.
//  Copyright © 2022 com.teenloong. All rights reserved.
//

import Foundation
//歌单收藏
public struct NCMPlaylistSubscribeAction: NCMAction {
    public struct PlaylistSubscribeParameters: Encodable {
        public var id: Int
    }
    public typealias Parameters = PlaylistSubscribeParameters
    public typealias Response = NCMPlaylistSubscribeResponse
    
    public var sub: Bool
    public var uri: String { "/weapi/playlist/\(sub ? "subscribe" : "unsubscribe")" }
    public var parameters: Parameters
    public var responseType = Response.self
}

public struct NCMPlaylistSubscribeResponse: NCMResponse {
    public var code: Int
    public var message: String?
}
