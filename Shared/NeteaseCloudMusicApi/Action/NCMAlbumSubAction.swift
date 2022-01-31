//
//  NCMAlbumSubAction.swift
//  Qin
//
//  Created by 林少龙 on 2021/6/11.
//  Copyright © 2022 com.teenloong. All rights reserved.
//

import Foundation
//收藏与取消收藏专辑
public struct NCMAlbumSubAction: NCMAction {
    public struct AlbumSubParameters: Encodable {
        var id: Int
    }
    public typealias Parameters = AlbumSubParameters
    public typealias Response = NCMAlbumSubResponse
    
    public var uri: String { "/weapi/album/\(sub ? "sub" : "unsub")"}
    public var parameters: Parameters?
    public var responseType = Response.self
    
    public var sub: Bool
    
    public init(id: Int,sub: Bool) {
        self.parameters = .init(id: id)
        self.sub = sub
    }
}

public struct NCMAlbumSubResponse: NCMResponse {
    public var code: Int
    public var time: Int
    public var message: String?
}
