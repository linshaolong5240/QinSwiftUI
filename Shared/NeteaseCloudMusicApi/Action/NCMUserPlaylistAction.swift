//
//  NCMUserPlaylistAction.swift
//  Qin
//
//  Created by 林少龙 on 2021/6/6.
//  Copyright © 2022 com.teenloong. All rights reserved.
//

import Foundation
//用户歌单
public struct NCMUserPlaylistAction: NCMAction {
    public struct UserPlaylistParameters: Encodable {
        public var uid: Int
        public var limit: Int
        public var offset: Int
    }
    public typealias Parameters = UserPlaylistParameters
    public typealias Response = NCMUserPlaylistResponse

    public var uri: String { "/weapi/user/playlist" }
    public var parameters: Parameters
    public var responseType = Response.self
    
    public init(uid: Int, limit: Int, offset: Int) {
        self.parameters = Parameters(uid: uid, limit: limit, offset: offset)
    }
}

public struct NCMUserPlaylistResponse: NCMResponse {
    public var code: Int
    public var more: Bool
    public var playlist: [NCMPlaylistResponse]
    public var version: String
    public var message: String?
}
