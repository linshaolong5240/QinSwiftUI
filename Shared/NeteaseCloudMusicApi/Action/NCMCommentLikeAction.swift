//
//  NCMCommentLikeAction.swift
//  Qin
//
//  Created by 林少龙 on 2021/6/9.
//  Copyright © 2022 com.teenloong. All rights reserved.
//

import Foundation
// 评论点赞与取消点赞
// 动态点赞不需要传入 id 参数，需要传入动态的 threadId 参数
public struct NCMCommentLikeAction: NCMAction {
    public struct CommentLikeParameters: Encodable {
        public var threadId: String
        public var commentId: Int
        
        init(threadId: Int, commentId: Int, commentType: NCMCommentType) {
            self.threadId = commentType.rawValue + String(commentId)
            self.commentId = commentId
        }
    }
    public typealias Parameters = CommentLikeParameters
    public typealias Response = NCMCommentLikeResponse

    public var like: Bool
    public var uri: String { "/weapi/v1/comment/\(like ? "like" : "unlike")" }
    public let parameters: Parameters
    public let responseType = Response.self
}

public struct NCMCommentLikeResponse: NCMResponse {
    public var code: Int
    public var message: String?
}
