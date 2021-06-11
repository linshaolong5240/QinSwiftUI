//
//  AlbumDetailAction.swift
//  Qin
//
//  Created by qfdev on 2021/6/11.
//

import Foundation
//专辑内容
public struct AlbumDetailAction: NeteaseCloudMusicAction {
    public typealias Parameters = EmptyParameters
    public typealias ResponseType = AlbumDetailResponse
    
    public let id: Int
    public var uri: String { "/weapi/v1/album/\(id)"}
    public let parameters = Parameters()
    public let responseType = ResponseType.self
}
