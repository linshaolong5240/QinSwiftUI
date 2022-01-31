//
//  NCMRecommendSongAction.swift
//  Qin
//
//  Created by 林少龙 on 2021/6/8.
//  Copyright © 2022 com.teenloong. All rights reserved.
//

import Foundation
//推荐歌曲( 需要登录 )
public struct NCMRecommendSongAction: NCMAction {
    public typealias Response = NCMRecommendSongsResponse

    public var uri: String { "/weapi/v3/discovery/recommend/songs" }
    public var responseType = Response.self
    
    public init() {
        
    }
}

public struct NCMRecommendSongsResponse: NCMResponse {
    public struct RecommendReason: Codable {
        public var reason: String
        public var songId: Int
    }
    public struct DataResponse: Codable {
        public var dailySongs: [NCMSongResponse]
//        public var orderSongs: [Any]
        public var recommendReasons: [RecommendReason]
    }
    public var code: Int
    public var data: DataResponse
    public var message: String?
}
