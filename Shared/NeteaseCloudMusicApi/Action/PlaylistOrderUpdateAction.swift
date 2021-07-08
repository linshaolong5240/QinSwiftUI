//
//  PlaylistOrderUpdateAction.swift
//  Qin
//
//  Created by 林少龙 on 2021/6/8.
//

import Foundation
//调整歌单顺序
//说明 : 登录后调用此接口,可以根据歌单id顺序调整歌单顺序
//
//必选参数 :
//
//ids: 歌单id列表
public struct PlaylistOrderUpdateAction: NeteaseCloudMusicAction {
    public struct PlaylistOrderUpdateParameters: Encodable {
        public var ids: [Int]
    }
    public typealias Parameters = PlaylistOrderUpdateParameters
    public typealias Response = PlaylistOrderUpdateResponse

    public var uri: String { "/weapi/playlist/order/update" }
    public let parameters: Parameters
    public let responseType = Response.self
}
