//
//  ArtistModel.swift
//  Qin
//
//  Created by 林少龙 on 2020/10/28.
//

import Foundation

struct ArtistModel: Codable {
//    var accountId: Int?
//    var albumSize: Int
//    var alias: [String]
//    var briefDesc: String
//    var followed: Bool?// optional for MV
    var id: Int64
//    var img1v1Id: Int
//    var img1v1Id_str: String?
//    var img1v1Url: String///歌手图片
//    var musicSize: Int
//    var mvSize: Int?// optional for Album
    var name: String?
//    var picId: Int
//    var picId_str: String?// optional for Album
    var picUrl: String?//歌手图片 optional for SongModel
//    var publishTime: Int?// optional for Album
//    var topicPerson: Int
//    var trans: String
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case picUrl = "picUrl"
    }
}
