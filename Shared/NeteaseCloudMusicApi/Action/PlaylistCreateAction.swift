//
//  PlaylistCreateAction.swift
//  Qin
//
//  Created by 林少龙 on 2021/6/7.
//

import Foundation
//创建歌单
public struct PlaylistCreateAction: NeteaseCloudMusicAction {
    public enum Privacy: Int, Codable {
        case common = 0
        case privacy = 10
    }
    public struct PlaylistCreateParameters: Encodable {
        public var name: String
        public var privacy: Privacy
    }
    public typealias Parameters = PlaylistCreateParameters
    public typealias Response = PlaylistCreateResponse

    public var uri: String { "/weapi/playlist/create" }
    public let parameters: Parameters
    public let responseType = Response.self
}
