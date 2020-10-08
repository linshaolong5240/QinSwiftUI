//
//  Creator.swift
//  Qin
//
//  Created by 林少龙 on 2020/10/8.
//

import Foundation

struct Creator: Codable {
    var accountStatus: Int
    var authStatus: Int
    var authority: Int
    var avatarImgId: Int
    var avatarImgIdStr: String
    var avatarUrl: String
    var backgroundImgId: Int
    var backgroundImgIdStr: String
    var backgroundUrl: String
    var birthday: Int
    var city: Int
    var defaultAvatar: Bool
    var description: String
    var detailDescription: String
    var djStatus: Int
    var expertTags: [String]?
//    var experts: Any?
    var followed: Bool
    var gender: Int
    var mutual: Bool
    var nickname: String
    var province: Int
//    var remarkName: Any?
    var signature: String
    var userId: Int
    var userType: Int
    var vipType: Int
}
