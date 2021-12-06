//
//  PlaylistDeleteResponse.swift
//  Qin
//
//  Created by 林少龙 on 2021/6/7.
//

import Foundation

public struct PlaylistDeleteResponse: NeteaseCloudMusicResponse {
    public var code: Int
    public var id: Int
    public var message: String?
}
