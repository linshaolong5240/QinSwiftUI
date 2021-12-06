//
//  LoginRefreshResponse.swift
//  Qin
//
//  Created by 林少龙 on 2021/6/6.
//

import Foundation

public struct LoginRefreshResponse: NeteaseCloudMusicResponse {
    public var code: Int
    public var message: String?
}
