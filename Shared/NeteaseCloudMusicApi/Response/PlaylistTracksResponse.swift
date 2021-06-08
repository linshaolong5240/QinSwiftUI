//
//  PlaylistTracksResponse.swift
//  Qin
//
//  Created by qfdev on 2021/6/8.
//

import Foundation

public struct PlaylistTracksResponse: NeteaseCloudMusicResponse {
    public let cloudCount: Int
    public let code: Int
    public let count: Int
    public let trackIds: String?
}
