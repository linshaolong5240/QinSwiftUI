//
//  LoginAction.swift
//  Qin
//
//  Created by 林少龙 on 2021/5/28.
//

import Foundation
import CryptoSwift

//登录
public struct LoginAction: NeteaseCloudMusicAction {
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
    public typealias Response = LoginResponse

    public var uri: String { "/weapi/login" }
    public let parameters: Parameters
    public let responseType = Response.self
}
