//
//  SongOrderUpdateAction.swift
//  Qin
//
//  Created by 林少龙 on 2021/6/8.
//

import Foundation

//歌单歌曲顺序
public struct SongOrderUpdateAction: NeteaseCloudMusicAction {
    public struct SongOrderUpdateParameters: Encodable {
        public var pid: Int
        public var trackIds: [Int]
        public var op: String = "update"
    }
    public typealias Parameters = SongOrderUpdateParameters
    public typealias ResponseType = SongOrderUpdateResponse

    public var uri: String { "/weapi/playlist/manipulate/tracks" }
    public let parameters: Parameters
    public let responseType = ResponseType.self
}
