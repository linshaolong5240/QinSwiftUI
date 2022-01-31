//
//  NCMCommentSongAction.swift
//  Qin
//
//  Created by 林少龙 on 2021/6/9.
//  Copyright © 2022 com.teenloong. All rights reserved.
//

import Foundation
//歌曲评论
//说明 : 调用此接口 , 传入音乐 id 和 limit 参数 , 可获得该音乐的所有评论 ( 不需要 登录 )
//必选参数 : id: 音乐 id
//可选参数 : limit: 取出评论数量 , 默认为 20
//offset: 偏移数量 , 用于分页 , 如 :( 评论页数 -1)*20, 其中 20 为 limit 的值
//before: 分页参数,取上一页最后一项的 time 获取下一页数据(获取超过5000条评论的时候需要用到)
public struct NCMCommentSongAction: NCMAction {
    public struct CommentSongParameters: Encodable {
        public var rid: Int
        public var limit: Int
        public var offset: Int
        public var beforeTime: Int//deftaut 0
    }
    public typealias Parameters = CommentSongParameters
    public typealias Response = NCMCommentSongResponse
    
    public var rid: Int
    public var uri: String { "/weapi/v1/resource/comments/R_SO_4_\(rid)" }
    public var parameters: Parameters
    public var responseType = Response.self
    
    public init(rid: Int, limit: Int, offset: Int, beforeTime: Int) {
        self.parameters = Parameters(rid: rid, limit: limit, offset: offset, beforeTime: beforeTime)
        self.rid = rid
    }
}

public struct NCMCommentSongResponse: NCMResponse {
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
