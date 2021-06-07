//
//  UserPlaylistResponse.swift
//  Qin
//
//  Created by 林少龙 on 2021/6/6.
//

import Foundation
//用户歌单
public struct UserPlaylistResponse: NeteaseCloudMusicResponse {
    public let code: Int
    public let more: Bool
    public let playlist: [PlaylistResponse]
    public let version: String
}
