//
//  NeteaseCloudMusicApiResponse.swift
//  Qin
//
//  Created by 林少龙 on 2021/5/26.
//

import Foundation

public struct AlbumSublistResponse: Codable {
    public struct Album: Codable {
        public let alias: [String]
        public let artists: [Artist]
        public let id: Int
        public let msg: [String]
        public let name: String
        public let picId: Int
        public let picUrl: String
        public let size: Int
        public let subTime: Int
        public let transNames: [String]
    }
    public struct Artist: Codable {
        public let albumSize: Int
        public let alias: [String]
        public let briefDesc: String
        public let followed: Bool
        public let id: Int
        public let img1v1Id: Int
        public let img1v1Id_str: String
        public let img1v1Url: String
        public let musicSize: Int
        public let name: String
        public let picId: Int
        public let picUrl: String
        public let topicPerson: Int
        public let trans: String
    }
    public let code: Int
    public let count: Int
    public let data: [Album]
    public let hasMore: Bool
    public let paidCount: Int
}
