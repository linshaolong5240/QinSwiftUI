//
//  NeteaseCloudMusicApiResponse.swift
//  Qin
//
//  Created by 林少龙 on 2021/5/26.
//

import Foundation
//Album
public struct AlbumArtist: Codable {
    public let albumSize: Int
    public let alias: [String]
    public let briefDesc: String
    public let followed: Bool
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

public struct AlbumSublistResponse: Codable {
    public struct Album: Codable {
        public let alias: [String]
        public let artists: [AlbumArtist]
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

public struct ArtistSublistResponse: Codable {
    public struct Artist: Codable {
        public let albumSize: Int
        public let alias: [String]
        public let id: Int
        public let img1v1Url: String
        public let info: String
        public let mvSize: Int
        public let name: String
        public let picId: Int
        public let picUrl: String
        public let trans: String?
    }
    public let code: Int
    public let count: Int
    public let data: [Artist]
    public let hasMore: Bool
}
