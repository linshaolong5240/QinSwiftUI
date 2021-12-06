//
//  SongLikeListResponse.swift
//  Qin
//
//  Created by 林少龙 on 2021/6/6.
//

import Foundation

public struct SongLikeListResponse: NeteaseCloudMusicResponse {
    public var checkPoint: Int
    public var code: Int
    public var ids: [Int]
    public var message: String?
}
