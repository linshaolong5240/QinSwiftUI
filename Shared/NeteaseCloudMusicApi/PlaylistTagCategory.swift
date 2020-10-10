//
//  PlaylistCategory.swift
//  Qin
//
//  Created by 林少龙 on 2020/10/10.
//

import Foundation
//enum PlaylistCategory: String, CaseIterable {
//    case _0 = "语种"
//    case _1 = "风格"
//    case _2 = "场景"
//    case _3 = "情感"
//    case _4 = "主题"
//    var name: String {
//        switch self {
//        case ._0:
//            return "语种"
//        case ._1:
//            return "风格"
//        case ._2:
//            return "场景"
//        case ._3:
//            return "情感"
//        case ._4:
//            return"主题"
//        }
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

struct PlaylistTag: Codable {
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
