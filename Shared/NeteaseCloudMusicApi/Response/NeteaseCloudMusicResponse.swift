//
//  NeteaseCloudMusicResponse.swift
//  Qin
//
//  Created by 林少龙 on 2021/5/26.
//

import Foundation

protocol NeteaseCloudMusicResponse: Codable {
}

public struct CommonArtist: NeteaseCloudMusicResponse {
    public let accountId: Int?
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
