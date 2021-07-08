//
//  PlaylistListResponse.swift
//  Qin
//
//  Created by 林少龙 on 2021/6/7.
//

import Foundation

public struct PlaylistListResponse: NeteaseCloudMusicResponse {
    public let cat: String
    public let code: Int
    public let more: Bool
    public let playlists: [PlaylistResponse]
    public let total: Int
}
