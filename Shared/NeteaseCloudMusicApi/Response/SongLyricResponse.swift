//
//  SongLyricResponse.swift
//  Qin
//
//  Created by 林少龙 on 2021/6/6.
//

import Foundation

public struct SongLyricResponse: NeteaseCloudMusicResponse {
    public struct Lyric: Codable {
        public let lyric: String
        public let version: Int
    }
    public let code: Int
    public let klyric: Lyric
    public let lrc: Lyric
    public let qfy: Bool
    public let sfy: Bool
    public let sgc: Bool
    public let tlyric: Lyric
}
