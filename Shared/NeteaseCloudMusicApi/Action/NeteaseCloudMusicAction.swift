//
//  NeteaseCloudMusicAction.swift
//  Qin
//
//  Created by 林少龙 on 2021/5/26.
//

import Foundation

public struct EmptyParameters: Encodable { }

//专辑内容
public struct AlbumDetailAction: NeteaseCloudMusicAction {
    public typealias Parameters = EmptyParameters
    public typealias ResponseType = AlbumDetailResponse
    
    public let id: Int
    public var uri: String { "/weapi/v1/album/\(id)"}
    public let parameters = Parameters()
    public let responseType = ResponseType.self
}
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
//专辑收藏列表
public struct AlbumSublistAction: NeteaseCloudMusicAction {
    public struct AlbumSublistParameters: Encodable {
        public var limit: Int
        public var offset: Int
        public var total: Bool = true
    }
    public typealias Parameters = AlbumSublistParameters
    public typealias ResponseType = AlbumSublistResponse

    public let uri: String = "/weapi/album/sublist"
    public let parameters: Parameters
    public let responseType = ResponseType.self
}
//歌手收藏列表
public struct ArtistSublistAction: NeteaseCloudMusicAction {
    public struct ArtistSublistParameters: Encodable {
        public var limit: Int
        public var offset: Int
        public var total: Bool = true
    }
    public typealias Parameters = ArtistSublistParameters
    public typealias ResponseType = ArtistSublistResponse

    public let uri: String = "/weapi/artist/sublist"
    public let parameters: Parameters
    public let responseType = ResponseType.self
}
//歌手专辑
public struct ArtistAlbumsAction: NeteaseCloudMusicAction {
    public struct ArtistAlbumsParameters: Encodable {
        public var limit: Int
        public var offset: Int
        public var total: Bool = true
    }
    public typealias Parameters = ArtistAlbumsParameters
    public typealias ResponseType = ArtistAlbumsResponse

    public let id: Int
    public var uri: String { "/weapi/artist/albums/\(id)" }
    public let parameters: Parameters
    public let responseType = ResponseType.self
}
//歌手热门歌曲
public struct ArtistHotSongsAction: NeteaseCloudMusicAction {
    public typealias Parameters = EmptyParameters
    public typealias ResponseType = ArtistHotSongsResponse

    public let id: Int
    public var uri: String { "/weapi/artist/\(id)" }
    public let parameters = Parameters()
    public let responseType = ResponseType.self
}
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
