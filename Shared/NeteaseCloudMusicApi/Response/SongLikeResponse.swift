//
//  SongLikeResponse.swift
//  Qin
//
//  Created by 林少龙 on 2021/6/6.
//

import Foundation

public struct SongLikeResponse: NeteaseCloudMusicResponse {
    public var code: Int
    public var playlistId: Int
//    public var songs: [Any]
    public var message: String?
}
