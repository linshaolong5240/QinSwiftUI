//
//  Account.swift
//  Qin
//
//  Created by 林少龙 on 2020/6/15.
//  Copyright © 2020 teenloong. All rights reserved.
//

import Foundation

struct User: Codable {
    var account: Account = Account()
    var csrf: String = ""
    var uid: Int64 = 0
    var loginType: Int = 0
    var profile: Profile = Profile()
    init() {
        
    }
    init(_ accountData: AccountData) {
        do {
            self = try JSONDecoder().decode(User.self, from: accountData.userData!)
        }catch let error{
            print("User.init(_ accountData: AccountData) \(error)")
        }
    }
}
struct Account: Codable {
    var anonimousUser : Bool = false
    var ban : Int = 0
    var baoyueVersion : Int = 0
    var createTime : Int = 0
    var donateVersion : Int = 0
    var id : Int = 0
    var salt : String = ""
    var status : Int = 0
    var tokenVersion: Int = 0
    var type : Int = 0
    var userName : String = ""
    var vipType : Int = 0
    var viptypeVersion : Int = 0
    var whitelistAuthority : Int = 0
}

struct Profile: Codable {
    var accountStatus: Int = 0
    var authority: Int = 0
    var authStatus: Int = 0
    var avatarImgId: Int = 0
    var avatarImgIdStr: String = ""
    var avatarUrl: String = ""
    var backgroundImgId: Int = 0
    var backgroundImgIdStr: String = ""
    var backgroundUrl: String = ""
    var birthday: Int = 0
    var city: Int = 0
    var defaultAvatar: Bool = false
    var description: String = ""
    var detailDescription: String = ""
    var djStatus: Int = 0
    var eventCount: Int = 0
//    var experts: Dictionary<String,Any>
//    var expertTags: Any
    var followed: Bool = false
    var followeds: Int = 0
    var follows: Int = 0
    var gender: Int = 0
    var mutual: Bool = false
    var nickname: String = ""
    var playlistBeSubscribedCount: Int = 0
    var playlistCount: Int = 0
    var province: Int = 0
//    var remarkName: String = ""
    var signature: String = ""
    var userId: Int = 0
    var userType: Int = 0
    var vipType: Int = 0
}
