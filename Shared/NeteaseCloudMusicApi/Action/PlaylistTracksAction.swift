//
//  PlaylistTracksAction.swift
//  Qin
//
//  Created by qfdev on 2021/6/8.
//

import Foundation
//对歌单添加或删除歌曲
public struct PlaylistTracksAction: NeteaseCloudMusicAction {
    public struct PlaylistTracksParameters: Encodable {
        public enum Option: String, Codable {
            case add
            case del
        }
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
    public typealias ResponseType = PlaylistTracksResponse
    
    public var uri: String { "/weapi/playlist/manipulate/tracks" }
    public let parameters: Parameters
    public let responseType = ResponseType.self
}
