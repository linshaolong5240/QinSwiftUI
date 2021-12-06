//
//  PlaylistCreateResponse.swift
//  Qin
//
//  Created by 林少龙 on 2021/6/7.
//

import Foundation

public struct PlaylistCreateResponse: NeteaseCloudMusicResponse {
    public var code: Int
    public var id: Int
    public var playlist: PlaylistResponse
    public var message: String?
}
