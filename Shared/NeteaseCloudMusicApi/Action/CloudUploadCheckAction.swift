//
//  CloudUploadCheckAction.swift
//  Qin
//
//  Created by 林少龙 on 2021/7/11.
//

import Foundation

public struct CloudUploadCheckAction: NeteaseCloudMusicAction {
    public struct CloudUploadCheckParameters: Encodable {
        var bitrate: String = "999000"
        var ext: String = ""
        var length: Int
        var md5: String
        var songId: Int = 0
        var version: Int = 1
    }
    public typealias Parameters = CloudUploadCheckParameters
    public typealias Response = CloudUploadCheckResponse
    public var host: String { cloudHost }
    public var uri: String { "/weapi/cloud/upload/check"}
    public let parameters: Parameters
    public let responseType = Response.self
}
