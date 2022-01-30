//
//  NCMPlaylistListAction.swift
//  Qin
//
//  Created by 林少龙 on 2021/6/7.
//  Copyright © 2022 com.teenloong. All rights reserved.
//

import Foundation
//获取歌单分类
public struct NCMPlaylistListAction: NCMAction {
    public struct PlaylistListParameters: Encodable {
        public enum Order: String, Codable {
            case hot, new
        }
        public var cat: String
        public var order: Order
        public var limit: Int
        public var offset: Int
        public var total: Bool
    }
    public typealias Parameters = PlaylistListParameters
    public typealias Response = NCMPlaylistListResponse

    public var uri: String { "/weapi/playlist/list" }
    public var parameters: Parameters
    public var responseType = Response.self
}

public struct NCMPlaylistListResponse: NCMResponse {
    public var cat: String
    public var code: Int
    public var more: Bool
    public var playlists: [PlaylistResponse]
    public var total: Int
    public var message: String?
}
