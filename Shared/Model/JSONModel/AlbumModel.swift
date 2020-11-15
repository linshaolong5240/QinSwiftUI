//
//  AlbumModel.swift
//  Qin
//
//  Created by 林少龙 on 2020/10/28.
//

import Foundation

struct AlbumModel: Codable {
    var id: Int64
    var isSub: Bool?
    var name: String?
    var picUrl: String
//    enum CodingKeys: String, CodingKey {
//        case id = "id"
//        case name = "name"
//        case picUrl = "picUrl"
//    }
}
