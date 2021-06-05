//
//  ArtistMVRespone.swift
//  Qin
//
//  Created by 林少龙 on 2021/6/5.
//

import Foundation

public struct ArtistMVResponse: NeteaseCloudMusicResponse {
    public struct MV: Codable {
        public struct Artist: Codable {
            public let albumSize: Int
            public let alias: [String]
            public let briefDesc: String
            public let id: Int
            public let img1v1Id: Int
            public let img1v1Id_str: String?
            public let img1v1Url: String
            public let musicSize: Int
            public let name: String
            public let picId: Int
            public let picUrl: String
            public let topicPerson: Int
            public let trans: String
        }
        
        public let artist: Artist
        public let artistName: String
        public let duration: Int
        public let id: Int
        public let imgurl: String
        public let imgurl16v9: String
        public let name: String
        public let playCount: Int
        public let publishTime: String
        public let status: Int
        public let subed: Bool
    }
    public let code: Int
    public let hasMore: Bool
    public let mvs: [MV]
    public let time: Int
}
