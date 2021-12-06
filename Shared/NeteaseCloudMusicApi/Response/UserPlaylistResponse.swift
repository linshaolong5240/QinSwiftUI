//
//  UserPlaylistResponse.swift
//  Qin
//
//  Created by 林少龙 on 2021/6/6.
//

import Foundation
//用户歌单
public struct UserPlaylistResponse: NeteaseCloudMusicResponse {
    public var code: Int
    public var more: Bool
    public var playlist: [PlaylistResponse]
    public var version: String
    public var message: String?
}
