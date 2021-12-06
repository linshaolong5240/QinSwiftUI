//
//  PlaylistTracksResponse.swift
//  Qin
//
//  Created by 林少龙 on 2021/6/8.
//

import Foundation

public struct PlaylistTracksResponse: NeteaseCloudMusicResponse {
    public var cloudCount: Int?
    public var code: Int
    public var count: Int?
    public var trackIds: String?
    public var message: String?
}
