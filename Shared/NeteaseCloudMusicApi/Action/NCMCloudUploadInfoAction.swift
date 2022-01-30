//
//  NCMCloudUploadInfoAction.swift
//  Qin
//
//  Created by 林少龙 on 2021/7/12.
//  Copyright © 2022 com.teenloong. All rights reserved.
//

import Foundation

public struct NCMCloudUploadInfoAction: NCMAction {
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
    public typealias Response = NCMCloudUploadInfoResponse
    
    public var uri: String { "/weapi/upload/cloud/info/v2"}
    public var parameters: Parameters
    public var responseType = Response.self
}

public struct NCMCloudUploadInfoResponse: NCMResponse {
    public var code: Int
    public var songId: String
    public var message: String?
}
