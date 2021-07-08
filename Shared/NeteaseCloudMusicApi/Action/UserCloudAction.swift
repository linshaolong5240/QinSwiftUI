//
//  UserCloudAction.swift
//  Qin (macOS)
//
//  Created by 林少龙 on 2021/7/8.
//

import Foundation

public struct UserCloudAction: NeteaseCloudMusicAction {
    
    public struct UserCloudActionParameters: Encodable {
        public var limit: Int
        public var offset: Int
    }
    public typealias Parameters = UserCloudActionParameters
    public typealias Response = UserCloudResponse

    public var uri: String { "/weapi/v1/cloud/get" }
    public let parameters: Parameters
    public let responseType = Response.self
}
