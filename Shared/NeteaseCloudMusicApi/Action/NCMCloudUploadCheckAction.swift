//
//  NCMCloudUploadCheckAction.swift
//  Qin
//
//  Created by 林少龙 on 2021/7/11.
//  Copyright © 2022 com.teenloong. All rights reserved.
//

import Foundation

public struct NCMCloudUploadCheckAction: NCMAction {
    public struct CloudUploadCheckParameters: Encodable {
        var bitrate: String = "999000"
        var ext: String = ""
        var length: Int
        var md5: String
        var songId: Int = 0
        var version: Int = 1
    }
    public typealias Parameters = CloudUploadCheckParameters
    public typealias Response = NCMCloudUploadCheckResponse
    public var host: String { cloudHost }
    public var uri: String { "/weapi/cloud/upload/check"}
    public var parameters: Parameters?
    public var responseType = Response.self
    
    public init(fileLength: Int, md5: String) {
        self.parameters = Parameters(length: fileLength, md5: md5)
    }
}

public struct NCMCloudUploadCheckResponse: NCMResponse {
    public var code: Int
    public var needUpload: Bool
    public var songId: String
    public var message: String?
}
