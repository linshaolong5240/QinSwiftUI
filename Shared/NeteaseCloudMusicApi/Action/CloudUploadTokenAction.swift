//
//  CloudUploadTokenAction.swift
//  Qin
//
//  Created by 林少龙 on 2021/7/11.
//

import Foundation

public struct CloudUploadTokenAction: NeteaseCloudMusicAction {
    public struct CloudUploadTokenParameters: Encodable {
        var bucket: String = ""
        var ext: String =  "mp3"
        var filename: String
        var local: Bool = false
        var nos_product: Int = 3
        var type: String = "audio"
        var md5: String
    }
    public typealias Parameters = CloudUploadTokenParameters
    public typealias Response = CloudUploadTokenResponse
    public var uri: String { "/weapi/nos/token/alloc"}
    public let parameters: Parameters
    public let responseType = Response.self
}
