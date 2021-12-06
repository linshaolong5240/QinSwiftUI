//
//  MVURLResponse.swift
//  Qin
//
//  Created by 林少龙 on 2021/6/7.
//

import Foundation

public struct MVURLResponse: NeteaseCloudMusicResponse {
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
