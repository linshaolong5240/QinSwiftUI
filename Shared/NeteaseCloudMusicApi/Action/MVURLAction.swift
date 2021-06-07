//
//  MVURLAction.swift
//  Qin
//
//  Created by qfdev on 2021/6/7.
//

import Foundation
//MV链接
public struct MVURLAction: NeteaseCloudMusicAction {
    public struct MVURLParameters: Encodable {
        public var id: Int
        public var r: Int = 1080
    }
    public typealias Parameters = MVURLParameters
    public typealias ResponseType = MVURLResponse

    public var uri: String { "/weapi/song/enhance/play/mv/url" }
    public let parameters: Parameters
    public let responseType = ResponseType.self
}
