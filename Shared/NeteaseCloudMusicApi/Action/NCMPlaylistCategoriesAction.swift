//
//  NCMPlaylistCategoriesAction.swift
//  Qin
//
//  Created by 林少龙 on 2021/6/7.
//  Copyright © 2022 com.teenloong. All rights reserved.
//

import Foundation

//歌单分类
public struct NCMPlaylistCategoriesAction: NCMAction {
    public typealias Parameters = NCMEmptyParameters
    public typealias Response = NCMPlaylistCatalogueResponse

    public var uri: String { "/weapi/playlist/catalogue" }
    public var parameters = Parameters()
    public var responseType = Response.self
    
    public init() {
        
    }
}

public struct NCMPlaylistCatalogueResponse: NCMResponse {
    public struct PlaylistCatalogue: Codable {
        public var activity: Bool
        public var category: Int
        public var hot: Bool
        public var imgId: Int
        public var imgUrl: String?
        public var name: String
        public var resourceCount: Int
        public var resourceType: Int
        public var type: Int
    }
//    public struct Category: Codable {
//        var _0: String
//        var _1: String
//        var _2: String
//        var _3: String
//        var _4: String
//        enum CodingKeys: String, CodingKey {
//            case _0 = "0"
//            case _1 = "1"
//            case _2 = "2"
//            case _3 = "3"
//            case _4 = "4"
//        }
//    }
    public var all: PlaylistCatalogue
    public var categories: [String: String]
    public var code: Int
    public var sub: [PlaylistCatalogue]
    public var message: String?
}
