//
//  AlbumSublistResponse.swift
//  Qin
//
//  Created by 林少龙 on 2021/5/28.
//

import Foundation

public struct AlbumSublistResponse: NeteaseCloudMusicResponse {
    public struct Album: Codable {
        public var alias: [String]
        public var artists: [ArtistResponse]
        public var id: Int
        public var msg: [String]
        public var name: String
        public var picId: Int
        public var picUrl: String
        public var size: Int
        public var subTime: Int
        public var transNames: [String]
    }
    public var code: Int
    public var count: Int
    public var data: [Album]
    public var hasMore: Bool
    public var paidCount: Int
    public var message: String?
}

extension AlbumSublistResponse.Album: Identifiable {
    
}
