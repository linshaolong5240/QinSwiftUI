//
//  ArtistHotSongsAction.swift
//  Qin
//
//  Created by qfdev on 2021/6/11.
//

import Foundation
//歌手热门歌曲
public struct ArtistHotSongsAction: NeteaseCloudMusicAction {
    public typealias Parameters = EmptyParameters
    public typealias ResponseType = ArtistHotSongsResponse

    public let id: Int
    public var uri: String { "/weapi/artist/\(id)" }
    public let parameters = Parameters()
    public let responseType = ResponseType.self
}
