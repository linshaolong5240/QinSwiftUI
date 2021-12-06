//
//  SongLyricResponse.swift
//  Qin
//
//  Created by 林少龙 on 2021/6/6.
//

import Foundation

public struct SongLyricResponse: NeteaseCloudMusicResponse {
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
