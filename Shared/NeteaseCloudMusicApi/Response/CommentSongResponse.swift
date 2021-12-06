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
            public var identityIconUrl: String
            public var identityLevel, userType: Int
        }
        public struct CommonIdentity: Codable {
            public var bizCode: String
            public var iconUrl: String
            public var link: String
            public var target, title: String
        }
        public struct VipRights: Codable {
            public struct Associator: Codable {
                public var rights: Bool
                public var vipCode: Int
            }
            public var associator: Associator?
//            public var musicPackage: Any?
            public var redVipAnnualCount, redVipLevel: Int
        }
        public var anonym, authStatus: Int
        public var avatarDetail: AvatarDetail?
        public var avatarUrl: String
        public var commonIdentity: CommonIdentity?
//        public var experts, expertTags: Any?
        public var followed: Bool
//        public var liveInfo: Any?
        public var locationInfo: String?
        public var mutual: Bool
        public var nickname: String
        public var remarkName: String?
        public var userId, userType: Int
        public var vipRights: VipRights?
        public var vipType: Int
    }
    public struct Comment: Codable {
        public struct BeReplied: Codable {
            public var beRepliedCommentId: Int
            public var content: String?
//            public var expressionUrl: String?
            public var status: Int
            public var user: User
        }
        public struct PendantData: Codable {
            public var id: Int
            public var imageUrl: String
        }
        public var beReplied: [BeReplied]
        public var commentId, commentLocationType: Int
        public var content: String
//        public var decoration: Any
//        public var expressionUrl: Any?
        public var liked: Bool
        public var likedCount, parentCommentId: Int
        public var pendantData: PendantData?
//        public var repliedMark, showFloorComment: Any?
        public var status, time: Int
        public var user: User
    }
    public var cnum: Int?
    public var code: Int
//    public var commentBanner: Any?
    public var comments: [Comment]
    public var hotComments: [Comment]?
    public var isMusician: Bool
    public var more: Bool
    public var moreHot: Bool?
    public var topComments: [Comment]
    public var total, userId: Int
    public var message: String?
}
