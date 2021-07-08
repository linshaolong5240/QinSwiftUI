//
//  LogoutAction.swift
//  Qin
//
//  Created by 林少龙 on 2021/5/28.
//

import Foundation

//退出登录
public struct LogoutAction: NeteaseCloudMusicAction {
    public typealias Parameters = EmptyParameters
    public typealias Response = LogoutResponse

    public var uri: String { "/weapi/logout" }
    public let parameters = Parameters()
    public let responseType = Response.self
}
