//
//  SongURLAction.swift
//  Qin
//
//  Created by 林少龙 on 2021/6/6.
//

import Foundation
//歌曲链接
public struct SongURLAction: NeteaseCloudMusicAction {
    public struct SongURLParameters: Encodable {
        public var ids: String
        public var br: Int
        init(ids: [Int], br: Int = 999000) {
            self.ids = "[" + ids.map(String.init).joined(separator: ",") + "]"
            self.br = br
        }
    }
    public typealias Parameters = SongURLParameters
    public typealias ResponseType = SongURLResponse

    public var uri: String { "/weapi/song/enhance/player/url" }
    public let parameters: Parameters
    public let responseType = ResponseType.self
}
