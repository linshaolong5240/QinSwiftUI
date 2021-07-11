//
//  CloudUploadAction.swift
//  Qin
//
//  Created by 林少龙 on 2021/7/11.
//

import Foundation

public struct CloudUploadAction: NeteaseCloudMusicAction {
    public typealias Parameters = EmptyParameters
    public typealias Response = CloudUploadResponse
    
    public let objectKey: String
    public let token: String
    public let md5: String
    public let size: Int
    
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
    public let parameters = Parameters()
    public let responseType = Response.self
}
