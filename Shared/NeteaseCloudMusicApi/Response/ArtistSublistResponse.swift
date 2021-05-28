//
//  ArtistSublistResponse.swift
//  Qin
//
//  Created by 林少龙 on 2021/5/28.
//

import Foundation

public struct ArtistSublistResponse: NeteaseCloudMusicResponse {
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
