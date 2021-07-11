//
//  CloudUploadInfoAction.swift
//  Qin
//
//  Created by 林少龙 on 2021/7/12.
//

import Foundation

public struct CloudUploadInfoAction: NeteaseCloudMusicAction {
    public struct CloudUploadInfoParameters: Encodable {
        var album: String = "Unknown"
        var artist: String = "Unknown"
        var bitrate: String = "999000"
        var filename: String
        var md5: String
        var resourceId: Int
        var song: String
        var songid: String
    }
    public typealias Parameters = CloudUploadInfoParameters
    public typealias Response = CloudUploadInfoResponse
    
    public var uri: String { "/weapi/upload/cloud/info/v2"}
    public let parameters: Parameters
    public let responseType = Response.self
}
