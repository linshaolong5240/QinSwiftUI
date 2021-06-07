//
//  PlaylistDeleteAction.swift
//  Qin
//
//  Created by qfdev on 2021/6/7.
//

import Foundation
//删除歌单
public struct PlaylistDeleteAction: NeteaseCloudMusicAction {
    public struct PlaylistDeleteParameters: Encodable {
        public var pid: Int
    }
    public typealias Parameters = PlaylistDeleteParameters
    public typealias ResponseType = PlaylistDeleteResponse

    public var uri: String { "/weapi/playlist/delete" }
    public let parameters: Parameters
    public let responseType = ResponseType.self
}
