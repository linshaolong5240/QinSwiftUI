//
//  LogoutResponse.swift
//  Qin
//
//  Created by 林少龙 on 2021/5/28.
//

import Foundation

public struct LogoutResponse: NeteaseCloudMusicResponse {
    public var code: Int
    public var message: String?
}
