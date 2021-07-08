//
//  AlbumSubAction.swift
//  Qin
//
//  Created by 林少龙 on 2021/6/11.
//

import Foundation
//收藏与取消收藏专辑
public struct AlbumSubAction: NeteaseCloudMusicAction {
    public struct AlbumSubParameters: Encodable {
        var id: Int
    }
    public typealias Parameters = AlbumSubParameters
    public typealias Response = AlbumSubResponse
    
    public var uri: String { "/weapi/album/\(sub ? "sub" : "unsub")"}
    public let parameters: Parameters
    public let responseType = Response.self
    
    public let sub: Bool
}
