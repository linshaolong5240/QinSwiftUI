//
//  RecommendPlaylistAction.swift
//  Qin
//
//  Created by 林少龙 on 2021/6/9.
//

import Foundation
//推荐歌单( 需要登录 )
public struct RecommendPlaylistAction: NeteaseCloudMusicAction {
    public typealias Parameters = EmptyParameters
    public typealias Response = RecommendPlaylistResponse

    public var uri: String { "/weapi/v1/discovery/recommend/resource" }
    public let parameters = Parameters()
    public let responseType = Response.self
}
