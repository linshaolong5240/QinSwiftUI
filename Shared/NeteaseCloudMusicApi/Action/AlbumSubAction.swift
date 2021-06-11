//
//  AlbumSubAction.swift
//  Qin
//
//  Created by qfdev on 2021/6/11.
//

import Foundation
//收藏与取消收藏专辑
public struct AlbumSubAction: NeteaseCloudMusicAction {
    public struct AlbumSubParameters: Encodable {
        var id: Int
    }
    public typealias Parameters = AlbumSubParameters
    public typealias ResponseType = AlbumSubResponse
    
    public var uri: String { "/weapi/album/\(sub ? "sub" : "unsub")"}
    public let parameters: Parameters
    public let responseType = ResponseType.self
    
    public let sub: Bool
}
