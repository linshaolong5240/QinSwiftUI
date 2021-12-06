//
//  SongDetailResponse.swift
//  Qin
//
//  Created by 林少龙 on 2021/6/8.
//

import Foundation
//歌曲详情
public struct SongDetailResponse: NeteaseCloudMusicResponse {
    public var code: Int
    public var privileges: [PrivilegeResponse]
    public var songs: [SongResponse]
    public var message: String?
}
