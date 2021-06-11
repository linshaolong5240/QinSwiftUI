//
//  ArtistIntroductionAction.swift
//  Qin
//
//  Created by qfdev on 2021/6/11.
//

import Foundation
//歌手介绍
public struct ArtistIntroductionAction: NeteaseCloudMusicAction {
    public struct ArtisIntroductionParameters: Encodable {
        public var id: Int
    }
    public typealias Parameters = ArtisIntroductionParameters
    public typealias ResponseType = ArtistIntroductionResponse

    public var uri: String { "/weapi/artist/introduction" }
    public let parameters: Parameters
    public let responseType = ResponseType.self
}
