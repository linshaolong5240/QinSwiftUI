//
//  NCMCloudUploadTokenAction.swift
//  Qin
//
//  Created by 林少龙 on 2021/7/11.
//  Copyright © 2022 com.teenloong. All rights reserved.
//

import Foundation

public struct NCMCloudUploadTokenAction: NCMAction {
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
    public var parameters: Parameters
    public var responseType = Response.self
}

public struct CloudUploadTokenResponse: NCMResponse {
    public struct Result: Codable {
        public var bucket: String
        public var docId: String
        public var objectKey: String
        public var resourceId: Int
        public var token: String
    }
    public var code: Int
    public var message: String?
    public var result: Result
}
