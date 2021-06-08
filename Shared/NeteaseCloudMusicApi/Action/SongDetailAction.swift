//
//  SongDetailAction.swift
//  Qin
//
//  Created by qfdev on 2021/6/8.
//

import Foundation
//歌曲详情
public struct SongDetailAction: NeteaseCloudMusicAction {
    public struct SongDetailParameters: Encodable {
        public var c: String
        public var ids: String
        init(ids: [Int]) {
            let kv: String = ids.map{"{" + "id:" + String($0) + "}"}.joined(separator: ",")
            self.c = "[" + kv + "]"
            self.ids = "[" + ids.map(String.init).joined(separator: ",") + "]"
        }
    }
    public typealias Parameters = SongDetailParameters
    public typealias ResponseType = SongDetailResponse

    public var uri: String { "/weapi/v3/song/detail" }
    public let parameters: Parameters
    public let responseType = ResponseType.self
}
