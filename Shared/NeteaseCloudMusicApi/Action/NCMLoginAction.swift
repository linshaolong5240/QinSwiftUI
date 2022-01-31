//
//  NCMLoginAction.swift
//  Qin
//
//  Created by 林少龙 on 2021/5/28.
//  Copyright © 2022 com.teenloong. All rights reserved.
//

import Foundation
import CryptoSwift

//登录
public struct NCMLoginAction: NCMAction {
    public struct LoginParameters: Encodable {
        public var username: String
        public var password: String
        public var rememberLogin: Bool
        init(email username: String, password: String, rememberLogin: Bool = true) {
            self.username = username
            self.password = password.md5()
            self.rememberLogin = rememberLogin
        }
    }
    public typealias Parameters = LoginParameters
    public typealias Response = NCMLoginResponse

    public var uri: String { "/weapi/login" }
    public var parameters: Parameters
    public var responseType = Response.self
    
    public init(email: String, password: String, rememberLogin: Bool = true) {
        self.parameters = Parameters(email: email, password: password, rememberLogin: rememberLogin)
    }
}

public struct NCMLoginResponse: NCMResponse {
    public struct Account: Codable {
        public var anonimousUser: Bool
        public var ban: Int
        public var baoyueVersion: Int
        public var createTime: Int
        public var donateVersion: Int
        public var id: Int
        public var salt: String
        public var status: Int
        public var tokenVersion: Int
        public var type: Int
        public var userName: String
        public var vipType: Int
        public var viptypeVersion: Int
        public var whitelistAuthority: Int
    }
    public struct Binding: Codable {
        public var bindingTime: Int
        public var expired: Bool
        public var expiresIn: Int
        public var id: Int
        public var refreshTime: Int
        public var tokenJsonStr: String
        public var type: Int
        public var url: String
        public var userId: Int
    }
    public struct Profile: Codable {
        public var accountStatus: Int
        public var authority: Int
        public var authStatus: Int
//        public var avatarDetail: Any?
        public var avatarImgId: Int
        public var avatarImgIdStr: String
        public var avatarUrl: String
        public var backgroundImgId: Int
        public var backgroundImgIdStr: String
        public var backgroundUrl: String
        public var birthday: Int
        public var city: Int
        public var defaultAvatar: Bool
        public var detailDescription: String
        public var djStatus: Int
        public var eventCount: Int
//        public var experts: Any?
//        public var expertTags: Any?
        public var followed: Bool
        public var followeds: Int
        public var follows: Int
        public var gender: Int
        public var mutual: Bool
        public var nickname: String
        public var playlistBeSubscribedCount: Int
        public var playlistCount: Int
        public var province: Int
//        public var remarkName: Any?
        public var signature: String
        public var userId: Int
        public var userType: Int
        public var vipType: Int
    }

    public var account: Account
    public var bindings: [Binding]
    public var code: Int
    public var loginType: Int
    public var profile: Profile
    public var token: String
    public var message: String?
}

extension NCMLoginResponse {
    var userId: Int { profile.userId }
}
