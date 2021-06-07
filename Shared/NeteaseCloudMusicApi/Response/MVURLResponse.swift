//
//  MVURLResponse.swift
//  Qin
//
//  Created by 林少龙 on 2021/6/7.
//

import Foundation

public struct MVURLResponse: NeteaseCloudMusicResponse {
    public struct MVURLData: Codable {
        public let code: Int
        public let expi: Int
        public let fee: Int
        public let id: Int
        public let md5: String
        public let msg: String
        public let mvFee: Int
//        public let promotionVo: Any?
        public let r: Int
        public let size: Int
        public let st: Int
        public let url: String
    }
    public let code: Int
    public let data: MVURLData
}
