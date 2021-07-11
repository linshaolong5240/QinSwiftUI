//
//  CloudSongAddAction.swift
//  Qin
//
//  Created by 林少龙 on 2021/7/12.
//

import Foundation

public struct CloudSongAddAction: NeteaseCloudMusicAction {
    public struct CloudSongAddParameters: Encodable {
        var songid: Int
    }
    public typealias Parameters = CloudSongAddParameters
    public typealias Response = CloudSongAddResponse
    public var host: String { cloudHost }
    public var uri: String { "/weapi/cloud/pub/v2"}
    public let parameters: Parameters
    public let responseType = Response.self
}
