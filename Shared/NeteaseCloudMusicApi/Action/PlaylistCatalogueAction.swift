//
//  PlaylistCatalogueAction.swift
//  Qin
//
//  Created by 林少龙 on 2021/6/7.
//

import Foundation

//歌单分类
public struct PlaylistCatalogueAction: NeteaseCloudMusicAction {
    public typealias Parameters = EmptyParameters
    public typealias ResponseType = PlaylistCatalogueResponse

    public var uri: String { "/weapi/playlist/catalogue" }
    public let parameters = Parameters()
    public let responseType = ResponseType.self
}
