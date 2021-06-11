//
//  AlbumSublistResponse.swift
//  Qin
//
//  Created by 林少龙 on 2021/5/28.
//

import Foundation

public struct AlbumSublistResponse: NeteaseCloudMusicResponse {
    public struct Album: Codable {
        public let alias: [String]
        public let artists: [ArtistResponse]
        public let id: Int
        public let msg: [String]
        public let name: String
        public let picId: Int
        public let picUrl: String
        public let size: Int
        public let subTime: Int
        public let transNames: [String]
    }
    public let code: Int
    public let count: Int
    public let data: [Album]
    public let hasMore: Bool
    public let paidCount: Int
}

extension AlbumSublistResponse.Album: Identifiable {
    
}
