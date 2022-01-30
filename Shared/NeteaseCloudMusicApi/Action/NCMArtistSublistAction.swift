//
//  NCMArtistSublistAction.swift
//  Qin
//
//  Created by 林少龙 on 2021/6/11.
//  Copyright © 2022 com.teenloong. All rights reserved.
//

import Foundation
//歌手收藏列表
public struct NCMArtistSublistAction: NCMAction {
    public struct ArtistSublistParameters: Encodable {
        public var limit: Int
        public var offset: Int
        public var total: Bool = true
    }
    public typealias Parameters = ArtistSublistParameters
    public typealias Response = NCMArtistSublistResponse

    public var uri: String = "/weapi/artist/sublist"
    public var parameters: Parameters
    public var responseType = Response.self
}

public struct NCMArtistSublistResponse: NCMResponse {
    public struct Artist: Codable {
        public var albumSize: Int
        public var alias: [String]
        public var id: Int
        public var img1v1Url: String
        public var info: String
        public var mvSize: Int
        public var name: String
        public var picId: Int
        public var picUrl: String
        public var trans: String?
    }
    public var code: Int
    public var count: Int
    public var data: [Artist]
    public var hasMore: Bool
    public var message: String?
}

extension NCMArtistSublistResponse.Artist: Identifiable { }
