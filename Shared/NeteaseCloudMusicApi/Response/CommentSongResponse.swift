//
//  CommentSongResponse.swift
//  Qin
//
//  Created by 林少龙 on 2021/6/9.
//

import Foundation

public struct CommentSongResponse: NeteaseCloudMusicResponse {
    public struct User: Codable {
        public struct AvatarDetail: Codable {
            public let identityIconUrl: String
            public let identityLevel, userType: Int
        }
        public struct CommonIdentity: Codable {
            public let bizCode: String
            public let iconUrl: String
            public let link: String
            public let target, title: String
        }
        public struct VipRights: Codable {
            public struct Associator: Codable {
                public let rights: Bool
                public let vipCode: Int
            }
            public let associator: Associator?
//            public let musicPackage: Any?
            public let redVipAnnualCount, redVipLevel: Int
        }
        public let anonym, authStatus: Int
        public let avatarDetail: AvatarDetail?
        public let avatarUrl: String
        public let commonIdentity: CommonIdentity?
//        public let experts, expertTags: Any?
        public let followed: Bool
//        public let liveInfo: Any?
        public let locationInfo: String?
        public let mutual: Bool
        public let nickname: String
        public let remarkName: String?
        public let userId, userType: Int
        public let vipRights: VipRights?
        public let vipType: Int
    }
    public struct Comment: Codable {
        public struct BeReplied: Codable {
            public let beRepliedCommentId: Int
            public let content: String?
//            public let expressionUrl: String?
            public let status: Int
            public let user: User
        }
        public struct PendantData: Codable {
            public let id: Int
            public let imageUrl: String
        }
        public let beReplied: [BeReplied]
        public let commentId, commentLocationType: Int
        public let content: String
//        public let decoration: Any
//        public let expressionUrl: Any?
        public let liked: Bool
        public let likedCount, parentCommentId: Int
        public let pendantData: PendantData?
//        public let repliedMark, showFloorComment: Any?
        public let status, time: Int
        public let user: User
    }
    public let cnum: Int?
    public let code: Int
//    public let commentBanner: Any?
    public let comments: [Comment]
    public let hotComments: [Comment]?
    public let isMusician: Bool
    public let more: Bool
    public let moreHot: Bool?
    public let topComments: [Comment]
    public let total, userId: Int
}
