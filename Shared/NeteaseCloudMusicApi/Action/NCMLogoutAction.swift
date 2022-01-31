//
//  NCMLogoutAction.swift
//  Qin
//
//  Created by 林少龙 on 2021/5/28.
//  Copyright © 2022 com.teenloong. All rights reserved.
//

import Foundation

//退出登录
public struct NCMLogoutAction: NCMAction {
    public typealias Parameters = NCMEmptyParameters
    public typealias Response = NCMLogoutResponse

    public var uri: String { "/weapi/logout" }
    public var parameters = Parameters()
    public var responseType = Response.self
    
    public init() {
        
    }
}

public struct NCMLogoutResponse: NCMResponse {
    public var code: Int
    public var message: String?
}
