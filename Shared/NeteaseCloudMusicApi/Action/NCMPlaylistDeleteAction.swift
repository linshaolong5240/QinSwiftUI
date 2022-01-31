//
//  NCMPlaylistDeleteAction.swift
//  Qin
//
//  Created by 林少龙 on 2021/6/7.
//  Copyright © 2022 com.teenloong. All rights reserved.
//

import Foundation
//删除歌单
public struct NCMPlaylistDeleteAction: NCMAction {
    public struct PlaylistDeleteParameters: Encodable {
        public var pid: Int
    }
    public typealias Parameters = PlaylistDeleteParameters
    public typealias Response = NCMPlaylistDeleteResponse

    public var uri: String { "/weapi/playlist/delete" }
    public var parameters: Parameters?
    public var responseType = Response.self
    
    public init(id: Int) {
        self.parameters = Parameters(pid: id)
    }
}

public struct NCMPlaylistDeleteResponse: NCMResponse {
    public var code: Int
    public var id: Int
    public var message: String?
}
