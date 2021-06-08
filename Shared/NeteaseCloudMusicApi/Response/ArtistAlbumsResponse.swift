//
//  ArtistAlbumsResponse.swift
//  Qin
//
//  Created by 林少龙 on 2021/5/27.
//

import Foundation

public struct ArtistAlbumsResponse: NeteaseCloudMusicResponse {
    public struct ArtistAlbum: Codable {
        public let alias: [String]
        public let artist: ArtistResponse
        public let artists: [ArtistResponse]
        public let blurPicUrl: String
        public let briefDesc: String?
        public let commentThreadId: String
        public let company: String?
        public let companyId: Int
        public let description: String?
        public let id: Int
        public let isSub: Bool
        public let mark: Int
        public let name: String
        public let onSale: Bool
        public let paid: Bool
        public let pic: Int
        public let picId: Int
        public let picId_str: String?
        public let picUrl: String
        public let publishTime: Int
        public let size: Int
//        public let songs: [Any]
        public let status: Int
        public let subType: String
        public let tags: String
        public let type: String
    }
    public let artist: ArtistResponse
    public let code: Int
    public let hotAlbums: [ArtistAlbum]
    public let more: Bool
}
