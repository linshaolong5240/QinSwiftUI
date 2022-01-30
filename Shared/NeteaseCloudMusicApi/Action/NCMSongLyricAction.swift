//
//  NCMSongLyricAction.swift
//  Qin
//
//  Created by 林少龙 on 2021/6/6.
//  Copyright © 2022 com.teenloong. All rights reserved.
//

import Foundation
//歌曲歌词
public struct NCMSongLyricAction: NCMAction {
    public struct SongLyricParameters: Encodable {
        public var id: Int
        public var lv: Int = -1
        public var kv: Int = -1
        public var tv: Int = -1
    }
    public typealias Parameters = SongLyricParameters
    public typealias Response = NCMSongLyricResponse

    public var uri: String { "/weapi/song/lyric" }
    public var parameters: Parameters
    public var responseType = Response.self
    
    public init(id: Int) {
        self.parameters = .init(id: id)
    }
}

public struct NCMSongLyricResponse: NCMResponse {
    public struct Lyric: Codable {
        public var lyric: String
        public var version: Int
    }
    public var code: Int
    public var klyric: Lyric
    public var lrc: Lyric
    public var qfy: Bool
    public var sfy: Bool
    public var sgc: Bool
    public var tlyric: Lyric
    public var message: String?
}
