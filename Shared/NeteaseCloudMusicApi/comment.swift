//
//  Comment.swift
//  Qin
//
//  Created by 林少龙 on 2020/7/30.
//  Copyright © 2020 teenloong. All rights reserved.
//

import Foundation

struct Comment: Codable {
    struct CommentUser: Codable {
        var anonym: Int
        var authStatus: Int
        var avatarUrl: String
//        var expertTags: Any?
//        var experts: Any?
//        var liveInfo: Any?
//        var locationInfo: Any?
        var nickname: String
//        var remarkName: String?
        var userId: Int
        var userType: Int
//        var vipRights: Any?
        var vipType: Int
    }
    struct RepliedComment: Codable {
        var beRepliedCommentId: Int
        var content: String?
        var expressionUrl: String?
        var status: Int
        var user: CommentUser
    }
    var beReplied: [RepliedComment]
    var commentId: Int
    var commentLocationType: Int
    var content: String
//    var decoration: Any?
    var expressionUrl: String?
    var liked: Bool
    var likedCount: Int
    var parentCommentId: Int
//    var pendantData: Any?
//    var repliedMark: Any?
//    var showFloorComment: Any?
    var status: Int
    var time: Int
    var user: CommentUser
}
