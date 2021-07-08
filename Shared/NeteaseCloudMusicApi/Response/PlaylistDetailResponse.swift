//
//  PlaylistDetailResponse.swift
//  Qin
//
//  Created by 林少龙 on 2021/6/8.
//

import Foundation

public struct PlaylistDetailResponse: NeteaseCloudMusicResponse {
    public let code: Int
    public let playlist: PlaylistResponse
    public let privileges: [PrivilegeResponse]
//    public let relatedVideos: Any?
//    public let sharedPrivilege: Any?
//    public let urls: Any?
}
