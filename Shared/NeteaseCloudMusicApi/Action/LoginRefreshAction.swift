//
//  LoginRefreshAction.swift
//  Qin
//
//  Created by 林少龙 on 2021/6/6.
//

import Foundation

//登陆状态
public struct LoginRefreshAction: NeteaseCloudMusicAction {
    public typealias Parameters = EmptyParameters
    public typealias ResponseType = LoginRefreshResponse

    public var uri: String { "/weapi/login/token/refresh" }
    public let parameters = Parameters()
    public let responseType = ResponseType.self
}
