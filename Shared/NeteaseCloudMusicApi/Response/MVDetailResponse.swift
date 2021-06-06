//
//  MVDetailResponse.swift
//  Qin
//
//  Created by 林少龙 on 2021/6/7.
//

import Foundation

public struct MVDetailResponse: NeteaseCloudMusicResponse {
    public struct MVData: Codable {
        public struct Br: Codable {
            public let br, point, size: Int
        }
        public let artistId: Int
        public let artistName: String
//        public let artists: [Artist]
        public let briefDesc: String
        public let brs: [Br]
        public let commentCount: Int
        public let commentThreadId: String
        public let cover: String
        public let coverId: Double
        public let coverId_str: String
        public let desc: String
        public let duration, id: Int
        public let name: String
        public let nType, playCount: Int
//        public let price: Any?
        public let publishTime: String
        public let shareCount, subCount: Int
//        public let videoGroup: [Any]
    }
    public struct MP: Codable {
        let cp, dl, fee, id: Int
//        let msg: Any?
        let mvFee: Int
        let normal: Bool
        let payed, pl, sid, st: Int
        let unauthorized: Bool
    }
    public let bufferPic: String
    public let bufferPicFS: String
    public let code: Int
    public let data: MVData
    public let loadingPic: String
    public let loadingPicFS: String
    public let mp: MP
    public let subed: Bool
}
