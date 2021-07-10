//
//  CloudUploadCheckResponse.swift
//  Qin
//
//  Created by 林少龙 on 2021/7/11.
//

import Foundation

public struct CloudUploadCheckResponse: NeteaseCloudMusicResponse {
    public let code: Int
    public let needUpload: Bool
    public let songId: String
}
