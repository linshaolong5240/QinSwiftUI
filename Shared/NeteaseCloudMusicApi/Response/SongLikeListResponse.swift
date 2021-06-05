//
//  SongLikeListResponse.swift
//  Qin
//
//  Created by 林少龙 on 2021/6/6.
//

import Foundation

public struct SongLikeListResponse: NeteaseCloudMusicResponse {
    public let checkPoint: Int
    public let code: Int
    public let ids: [Int]
}
