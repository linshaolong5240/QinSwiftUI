//
//  MVDetailAction.swift
//  Qin
//
//  Created by 林少龙 on 2021/6/7.
//

import Foundation
//MV详情
public struct MVDetailAction: NeteaseCloudMusicAction {
    public struct MVDetailParameters: Encodable {
        public var id: Int
    }
    public typealias Parameters = MVDetailParameters
    public typealias Response = MVDetailResponse

    public var uri: String { "/weapi/v1/mv/detail" }
    public let parameters: Parameters
    public let responseType = Response.self
}
