//
//  NCMSongLikeListAction.swift
//  Qin
//
//  Created by 林少龙 on 2021/6/6.
//  Copyright © 2022 com.teenloong. All rights reserved.
//

import Foundation
//喜欢歌曲列表
public struct NCMSongLikeListAction: NCMAction {
    public struct SongLikeListParameters: Encodable {
        public var uid: Int
    }
    public typealias Parameters = SongLikeListParameters
    public typealias Response = NCMSongLikeListResponse

    public var uri: String { "/weapi/song/like/get" }
    public var parameters: Parameters
    public var responseType = Response.self
    
    public init(uid: Int) {
        self.parameters = Parameters(uid: uid)
    }
}

public struct NCMSongLikeListResponse: NCMResponse {
    public var checkPoint: Int
    public var code: Int
    public var ids: [Int]
    public var message: String?
}
