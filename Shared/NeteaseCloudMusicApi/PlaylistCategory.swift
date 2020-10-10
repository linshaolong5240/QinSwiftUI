//
//  PlaylistCategory.swift
//  Qin
//
//  Created by 林少龙 on 2020/10/10.
//

import Foundation
//enum PlaylistCategory {
//    var _0: String
//    var _1: String
//    var _2: String
//    var _3: String
//    var _4: String
//    enum CodingKeys: String, CodingKey {
//        case _0 = "0"
//        case _1 = "1"
//        case _2 = "2"
//        case _3 = "3"
//        case _4 = "4"
//    }
//}

struct PlaylistTagCategory: Codable {
    var _0: String
    var _1: String
    var _2: String
    var _3: String
    var _4: String
    enum CodingKeys: String, CodingKey {
        case _0 = "0"
        case _1 = "1"
        case _2 = "2"
        case _3 = "3"
        case _4 = "4"
    }
}

struct PlaylistSubcategory: Codable {
    var activity: Bool
    var category: Int
    var hot: Bool
    var imgId: Int
    var imgUrl: String?
    var name: String
    var resourceCount: Int
    var resourceType: Int
    var type: Int
}
