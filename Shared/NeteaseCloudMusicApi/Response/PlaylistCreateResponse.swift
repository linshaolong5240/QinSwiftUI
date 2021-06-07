//
//  PlaylistCreateResponse.swift
//  Qin
//
//  Created by qfdev on 2021/6/7.
//

import Foundation

public struct PlaylistCreateResponse: NeteaseCloudMusicResponse {
    public let code: Int
    public let id: Int
    public let playlist: PlaylistResponse
}
