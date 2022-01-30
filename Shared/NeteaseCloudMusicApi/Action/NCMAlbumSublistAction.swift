//
//  NCMAlbumSublistAction.swift
//  Qin
//
//  Created by 林少龙 on 2021/6/11.
//  Copyright © 2022 com.teenloong. All rights reserved.
//

import Foundation
//专辑收藏列表
public struct NCMAlbumSublistAction: NCMAction {
    public struct AlbumSublistParameters: Encodable {
        public var limit: Int
        public var offset: Int
        public var total: Bool = true
    }
    public typealias Parameters = AlbumSublistParameters
    public typealias Response = NCMAlbumSublistResponse

    public var uri: String = "/weapi/album/sublist"
    public var parameters: Parameters
    public var responseType = Response.self
}

public struct NCMAlbumSublistResponse: NCMResponse {
    public struct Album: Codable {
        public var alias: [String]
        public var artists: [NCMArtistResponse]
        public var id: Int
        public var msg: [String]
        public var name: String
        public var picId: Int
        public var picUrl: String
        public var size: Int
        public var subTime: Int
        public var transNames: [String]
    }
    public var code: Int
    public var count: Int
    public var data: [Album]
    public var hasMore: Bool
    public var paidCount: Int
    public var message: String?
}

extension NCMAlbumSublistResponse.Album: Identifiable {
    
}
