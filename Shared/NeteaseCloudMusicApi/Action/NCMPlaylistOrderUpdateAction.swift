//
//  NCMPlaylistOrderUpdateAction.swift
//  Qin
//
//  Created by 林少龙 on 2021/6/8.
//  Copyright © 2022 com.teenloong. All rights reserved.
//

import Foundation
//调整歌单顺序
//说明 : 登录后调用此接口,可以根据歌单id顺序调整歌单顺序
//
//必选参数 :
//
//ids: 歌单id列表
public struct NCMPlaylistOrderUpdateAction: NCMAction {
    public struct PlaylistOrderUpdateParameters: Encodable {
        public var ids: [Int]
    }
    public typealias Parameters = PlaylistOrderUpdateParameters
    public typealias Response = NCMPlaylistOrderUpdateResponse

    public var uri: String { "/weapi/playlist/order/update" }
    public var parameters: Parameters?
    public var responseType = Response.self
    
    public init(ids: [Int]) {
        self.parameters = Parameters(ids: ids)
    }
}

public struct NCMPlaylistOrderUpdateResponse: NCMResponse {
    public var code: Int
    public var message: String?
}
