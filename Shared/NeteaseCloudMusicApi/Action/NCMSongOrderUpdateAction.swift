//
//  NCMSongOrderUpdateAction.swift
//  Qin
//
//  Created by 林少龙 on 2021/6/8.
//  Copyright © 2022 com.teenloong. All rights reserved.
//

import Foundation

//歌单歌曲顺序
public struct NCMSongOrderUpdateAction: NCMAction {
    public struct SongOrderUpdateParameters: Encodable {
        public var pid: Int
        public var trackIds: [Int]
        public var op: String = "update"
    }
    public typealias Parameters = SongOrderUpdateParameters
    public typealias Response = NCMSongOrderUpdateResponse

    public var uri: String { "/weapi/playlist/manipulate/tracks" }
    public var parameters: Parameters?
    public var responseType = Response.self
    
    public init(pid: Int, songIds: [Int]) {
        self.parameters = Parameters(pid: pid, trackIds: songIds)
    }
}

public struct NCMSongOrderUpdateResponse: NCMResponse {
    public var code: Int
    public var message: String?
}
