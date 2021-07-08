//
//  RecommendSongAction.swift
//  Qin
//
//  Created by 林少龙 on 2021/6/8.
//

import Foundation
//推荐歌曲( 需要登录 )
public struct RecommendSongAction: NeteaseCloudMusicAction {
    public typealias Parameters = EmptyParameters
    public typealias Response = RecommendSongsResponse

    public var uri: String { "/weapi/v3/discovery/recommend/songs" }
    public let parameters = Parameters()
    public let responseType = Response.self
}
