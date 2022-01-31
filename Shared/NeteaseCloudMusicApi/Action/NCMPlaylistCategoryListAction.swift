//
//  NCMPlaylistCategoryListAction.swift
//  Qin
//
//  Created by 林少龙 on 2021/6/7.
//  Copyright © 2022 com.teenloong. All rights reserved.
//

import Foundation
//获取歌单分类
public struct NCMPlaylistCategoryListAction: NCMAction {
    public enum Order: String, Codable {
        case hot, new
    }
    
    public struct PlaylistCategoryListParameters: Encodable {
        public var cat: String
        public var order: Order
        public var limit: Int
        public var offset: Int
        public var total: Bool
    }
    public typealias Parameters = PlaylistCategoryListParameters
    public typealias Response = NCMPlaylistListResponse

    public var uri: String { "/weapi/playlist/list" }
    public var parameters: Parameters?
    public var responseType = Response.self
    
    public init(category: String, order: Order, limit: Int, offset: Int, total: Bool) {
        self.parameters = Parameters(cat: category, order: order, limit: limit, offset: offset, total: total)
    }
}

public struct NCMPlaylistListResponse: NCMResponse {
    public var cat: String
    public var code: Int
    public var more: Bool
    public var playlists: [NCMPlaylistResponse]
    public var total: Int
    public var message: String?
}
