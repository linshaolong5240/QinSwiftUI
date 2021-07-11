//
//  CloudUploadInfoResponse.swift
//  Qin
//
//  Created by 林少龙 on 2021/7/12.
//

import Foundation

public struct CloudUploadInfoResponse: NeteaseCloudMusicResponse {
    public let code: Int
    public var songId: String
}
