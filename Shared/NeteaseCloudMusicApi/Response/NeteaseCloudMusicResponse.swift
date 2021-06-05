//
//  NeteaseCloudMusicResponse.swift
//  Qin
//
//  Created by 林少龙 on 2021/5/26.
//

import Foundation

protocol NeteaseCloudMusicResponse: Codable {
    var code: Int { get }
}

public struct CommonAlbum: Codable {
    public struct Info: Codable {
        public struct CommentThread: Codable {
            public struct ResourceInfo: Codable {
//                    public let creator: Any?
//                    public let encodedId: Any?
                public let id: Int
                public let imgUrl: String
                public let name: String
                public let subTitle: String?
                public let userId: Int
                public let webUrl: String?
            }
            public let commentCount: Int
            public let hotCount: Int
            public let id: String
//                public let latestLikedUsers: Any?
            public let likedCount: Int
            public let resourceId: Int
            public let resourceInfo: ResourceInfo
            public let resourceOwnerId: Int
            public let resourceTitle: String
            public let resourceType: Int
            public let shareCount: Int
        }
        public let commentCount: Int
//        public let comments: Any?
        public let commentThread: CommentThread
//            public let latestLikedUsers: Any?
        public let liked: Bool
        public let likedCount: Int
        public let resourceId: Int
        public let resourceType: Int
        public let shareCount: Int
        public let threadId: String
    }
    public let alias: [String]
    public let artist: CommonArtistResponse
    public let artists: [CommonArtistResponse]
    public let blurPicUrl: String?
    public let briefDesc: String?
    public let commentThreadId: String
    public let company: String?
    public let companyId: Int
    public let copyrightId: Int?
    public let description: String?
    public let id: Int
    public let info: Info?
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
    public let subType: String?
    public let tags: String
    public let type: String?
}

public struct CommonArtistResponse: Codable {
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
