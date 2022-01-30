//
//  SongLyricAction.swift
//  Qin
//
//  Created by 林少龙 on 2021/6/6.
//

import Foundation
import UIKit
//歌曲歌词
public struct SongLyricAction: NeteaseCloudMusicAction {
    public struct SongLyricParameters: Encodable {
        public var id: Int
        public var lv: Int = -1
        public var kv: Int = -1
        public var tv: Int = -1
    }
    public typealias Parameters = SongLyricParameters
    public typealias Response = SongLyricResponse

    public var uri: String { "/weapi/song/lyric" }
    public let parameters: Parameters
    public let responseType = Response.self
    
    public init(id: Int) {
        self.parameters = .init(id: id)
    }
}
