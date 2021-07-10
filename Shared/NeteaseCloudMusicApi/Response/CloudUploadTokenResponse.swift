//
//  CloudUploadTokenResponse.swift
//  Qin
//
//  Created by 林少龙 on 2021/7/11.
//

import Foundation

public struct CloudUploadTokenResponse: NeteaseCloudMusicResponse {
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
