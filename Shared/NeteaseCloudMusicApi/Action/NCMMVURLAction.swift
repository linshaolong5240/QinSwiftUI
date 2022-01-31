//
//  NCMMVURLAction.swift
//  Qin
//
//  Created by 林少龙 on 2021/6/7.
//  Copyright © 2022 com.teenloong. All rights reserved.
//

import Foundation
//MV链接
public struct NCMMVURLAction: NCMAction {
    public struct MVURLParameters: Encodable {
        public var id: Int
        public var r: Int = 1080
    }
    public typealias Parameters = MVURLParameters
    public typealias Response = NCMMVURLResponse
    
    public var uri: String { "/weapi/song/enhance/play/mv/url" }
    public var parameters: Parameters?
    public var responseType = Response.self
    
    public init(id: Int, resolution: Int = 1080) {
        self.parameters = Parameters(id: id, r: resolution)
    }
}

public struct NCMMVURLResponse: NCMResponse {
    public struct MVURLData: Codable {
        public var code: Int
        public var expi: Int
        public var fee: Int
        public var id: Int
        public var md5: String
        public var msg: String
        public var mvFee: Int
//        public var promotionVo: Any?
        public var r: Int
        public var size: Int
        public var st: Int
        public var url: String
    }
    public var code: Int
    public var data: MVURLData
    public var message: String?
}
