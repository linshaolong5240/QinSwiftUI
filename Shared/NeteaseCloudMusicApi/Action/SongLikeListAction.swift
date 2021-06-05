//
//  SongLikeListAction.swift
//  Qin
//
//  Created by 林少龙 on 2021/6/6.
//

import Foundation
//喜欢歌曲列表
public struct SongLikeListAction: NeteaseCloudMusicAction {
    public struct SongLikeListParameters: Encodable {
        public var uid: Int
    }
    public typealias Parameters = SongLikeListParameters
    public typealias ResponseType = SongLikeListResponse

    public var uri: String { "/weapi/song/like/get" }
    public let parameters: Parameters
    public let responseType = ResponseType.self
}
