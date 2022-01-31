//
//  NCMPlaylistCreateAction.swift
//  Qin
//
//  Created by 林少龙 on 2021/6/7.
//  Copyright © 2022 com.teenloong. All rights reserved.
//

import Foundation
//创建歌单
public struct NCMPlaylistCreateAction: NCMAction {
    public enum Privacy: Int, Codable {
        case common = 0
        case privacy = 10
    }
    public struct PlaylistCreateParameters: Encodable {
        public var name: String
        public var privacy: Privacy
    }
    public typealias Parameters = PlaylistCreateParameters
    public typealias Response = NCMPlaylistCreateResponse

    public var uri: String { "/weapi/playlist/create" }
    public var parameters: Parameters
    public var responseType = Response.self
    
    public init(name: String, privacy: Privacy) {
        self.parameters = Parameters(name: name, privacy: privacy)
    }
}

public struct NCMPlaylistCreateResponse: NCMResponse {
    public var code: Int
    public var id: Int
    public var playlist: NCMPlaylistResponse
    public var message: String?
}
