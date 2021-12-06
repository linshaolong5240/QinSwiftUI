//
//  CloudUploadCheckResponse.swift
//  Qin
//
//  Created by 林少龙 on 2021/7/11.
//

import Foundation

public struct CloudUploadCheckResponse: NeteaseCloudMusicResponse {
    public var code: Int
    public var needUpload: Bool
    public var songId: String
    public var message: String?
}
