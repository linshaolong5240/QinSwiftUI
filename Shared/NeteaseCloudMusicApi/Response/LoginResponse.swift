//
//  LoginResponse.swift
//  Qin
//
//  Created by 林少龙 on 2021/5/28.
//

import Foundation

public struct LoginResponse: NeteaseCloudMusicResponse {
    public struct Account: Codable {
        public let anonimousUser: Bool
        public let ban: Int
        public let baoyueVersion: Int
        public let createTime: Int
        public let donateVersion: Int
        public let id: Int
        public let salt: String
        public let status: Int
        public let tokenVersion: Int
        public let type: Int
        public let userName: String
        public let vipType: Int
        public let viptypeVersion: Int
        public let whitelistAuthority: Int
    }
    public struct Binding: Codable {
        public let bindingTime: Int
        public let expired: Bool
        public let expiresIn: Int
        public let id: Int
        public let refreshTime: Int
        public let tokenJsonStr: String
        public let type: Int
        public let url: String
        public let userId: Int
    }
    public struct Profile: Codable {
        public let accountStatus: Int
        public let authority: Int
        public let authStatus: Int
//        public let avatarDetail: Any?
        public let avatarImgId: Int
        public let avatarImgIdStr: String
        public let avatarUrl: String
        public let backgroundImgId: Int
        public let backgroundImgIdStr: String
        public let backgroundUrl: String
        public let birthday: Int
        public let city: Int
        public let defaultAvatar: Bool
        public let detailDescription: String
        public let djStatus: Int
        public let eventCount: Int
//        public let experts: Any?
//        public let expertTags: Any?
        public let followed: Bool
        public let followeds: Int
        public let follows: Int
        public let gender: Int
        public let mutual: Bool
        public let nickname: String
        public let playlistBeSubscribedCount: Int
        public let playlistCount: Int
        public let province: Int
//        public let remarkName: Any?
        public let signature: String
        public let userId: Int
        public let userType: Int
        public let vipType: Int
    }

    public let account: Account
    public let bindings: [Binding]
    public let code: Int
    public let loginType: Int
    public let profile: Profile
    public let token: String
}

extension LoginResponse {
    var userId: Int { profile.userId }
}
