//
//  PlaylistListAction.swift
//  Qin
//
//  Created by 林少龙 on 2021/6/7.
//

import Foundation
//获取歌单分类
public struct PlaylistListAction: NeteaseCloudMusicAction {
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
    public typealias Response = PlaylistListResponse

    public var uri: String { "/weapi/playlist/list" }
    public let parameters: Parameters
    public let responseType = Response.self
}
