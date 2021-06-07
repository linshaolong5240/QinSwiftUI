//
//  PlaylistCatalogueResponse.swift
//  Qin
//
//  Created by 林少龙 on 2021/6/7.
//

import Foundation

public struct PlaylistCatalogueResponse: NeteaseCloudMusicResponse {
    public struct PlaylistCatalogue: Codable {
        public let activity: Bool
        public let category: Int
        public let hot: Bool
        public let imgId: Int
        public let imgUrl: String?
        public let name: String
        public let resourceCount: Int
        public let resourceType: Int
        public let type: Int
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
    public let all: PlaylistCatalogue
    public let categories: [String: String]
    public let code: Int
    public let sub: [PlaylistCatalogue]
}
