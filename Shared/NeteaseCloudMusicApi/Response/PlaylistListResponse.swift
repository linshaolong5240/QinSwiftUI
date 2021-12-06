//
//  PlaylistListResponse.swift
//  Qin
//
//  Created by 林少龙 on 2021/6/7.
//

import Foundation

public struct PlaylistListResponse: NeteaseCloudMusicResponse {
    public var cat: String
    public var code: Int
    public var more: Bool
    public var playlists: [PlaylistResponse]
    public var total: Int
    public var message: String?
}
