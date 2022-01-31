//
//  NCMCloudUploadAction.swift
//  Qin
//
//  Created by 林少龙 on 2021/7/11.
//  Copyright © 2022 com.teenloong. All rights reserved.
//

import Foundation

public struct NCMCloudUploadAction: NCMAction {
    public typealias Response = NCMCloudUploadResponse
    
    public var objectKey: String
    public var token: String
    public var md5: String
    public var size: Int
    
    public var data: Data
    
    public var headers: [String : String]? {
        return ["x-nos-token": token,
                "Content-MD5": md5,
                "Content-Type": "audio/mpeg",
                "Content-Length": String(size)
        ]
    }
    
    public var host: String { cloudUploadHost }
    public var uri: String { "/ymusic/\(objectKey.addingPercentEncoding(withAllowedCharacters: .urlUserAllowed) ?? "")?offset=0&complete=true&version=1.0"}
    public var responseType = Response.self
    
    public init(objectKey: String, token: String, md5: String, size: Int, data: Data) {
        self.objectKey = objectKey
        self.token = token
        self.md5 = md5
        self.size = size
        self.data = data
    }
}

public struct NCMCloudUploadResponse: NCMResponse {
    public var code: Int
    public var message: String?
}
