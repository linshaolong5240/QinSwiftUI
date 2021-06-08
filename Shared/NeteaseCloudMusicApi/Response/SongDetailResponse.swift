//
//  SongDetailResponse.swift
//  Qin
//
//  Created by qfdev on 2021/6/8.
//

import Foundation
//歌曲详情
public struct SongDetailResponse: NeteaseCloudMusicResponse {

    public let code: Int
    public let privileges: [PrivilegeResponse]
    public let songs: [SongResponse]
}
