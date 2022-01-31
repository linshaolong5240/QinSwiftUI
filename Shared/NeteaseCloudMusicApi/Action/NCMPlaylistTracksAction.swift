//
//  NCMPlaylistTracksAction.swift
//  Qin
//
//  Created by 林少龙 on 2021/6/8.
//  Copyright © 2022 com.teenloong. All rights reserved.
//

import Foundation
//对歌单添加或删除歌曲
public struct NCMPlaylistTracksAction: NCMAction {
    public enum Option: String, Codable {
        case add
        case del
    }
    public struct PlaylistTracksParameters: Encodable {
        public var op: Option
        public var pid: Int
        public var trackIds: String
        
        init(pid: Int, ids: [Int], op: Option) {
            self.op = op
            self.pid = pid
            self.trackIds = "[" + ids.map(String.init).joined(separator: ",") + "]"
        }
    }
    public typealias Parameters = PlaylistTracksParameters
    public typealias Response = NCMPlaylistTracksResponse
    
    public var uri: String { "/weapi/playlist/manipulate/tracks" }
    public var parameters: Parameters?
    public var responseType = Response.self
    
    public init(pid: Int, ids: [Int], op: Option) {
        self.parameters = Parameters(pid: pid, ids: ids, op: op)
    }
}

public struct NCMPlaylistTracksResponse: NCMResponse {
    public var cloudCount: Int?
    public var code: Int
    public var count: Int?
    public var trackIds: String?
    public var message: String?
}
