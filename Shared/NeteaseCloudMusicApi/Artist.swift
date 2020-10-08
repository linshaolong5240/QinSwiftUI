//
//  Artist.swift
//  Qin
//
//  Created by 林少龙 on 2020/10/1.
//

import Foundation

struct Artist: Codable, Identifiable {
    var accountId: Int?
    var albumSize: Int
    var alias: [String]
    var briefDesc: String
    var followed: Bool?// optional for MV
    var id: Int
    var img1v1Id: Int
    var img1v1Id_str: String?
    var img1v1Url: String
    var musicSize: Int
    var mvSize: Int?// optional for Album
    var name: String
    var picId: Int
    var picId_str: String?// optional for Album
    var picUrl: String
    var publishTime: Int?// optional for Album
    var topicPerson: Int
    var trans: String
}
