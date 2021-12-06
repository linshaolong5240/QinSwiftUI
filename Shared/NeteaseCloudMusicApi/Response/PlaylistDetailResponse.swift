//
//  PlaylistDetailResponse.swift
//  Qin
//
//  Created by 林少龙 on 2021/6/8.
//

import Foundation

public struct PlaylistDetailResponse: NeteaseCloudMusicResponse {
    public var code: Int
    public var playlist: PlaylistResponse
    public var privileges: [PrivilegeResponse]
//    public var relatedVideos: Any?
//    public var sharedPrivilege: Any?
//    public var urls: Any?
    public var message: String?
}
