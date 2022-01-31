//
//  NCMCommentAction.swift
//  Qin
//
//  Created by 林少龙 on 2021/6/9.
//

import Foundation

fileprivate let URI = "/weapi/resource/comments/"

public enum NCMCommentType: String, Encodable {
    case song = "R_SO_4_"//  歌曲
    case mv = "R_MV_5_"//  MV
    case playlist = "A_PL_0_"//  歌单
    case album = "R_AL_3_"//  专辑
    case dj = "A_DJ_1_"//  电台
    case vedio = "R_VI_62_"//  视频
    case event = "A_EV_2_"//  动态
}

public enum NCMCommentAction: String, Encodable {
    case add = "add"
    case delete = "delete"
    case reply = "reply"
}

public struct NCMCommentAddAction: NCMAction {
    public struct CommentAddParameters: Encodable {
        public var threadId: String
        public var content: String
        init(threadId: Int, content: String, type: NCMCommentType) {
            self.threadId = type.rawValue + String(threadId)
            self.content = content
        }
    }
    public typealias Parameters = CommentAddParameters
    public typealias Response = NCMCommentAddRespone
    
    public var uri: String { "\(URI)\(NCMCommentAction.add.rawValue)" }
    public var parameters: Parameters?
    public var responseType = Response.self
    
    public init(threadId: Int, content: String, type: NCMCommentType) {
        self.parameters = Parameters(threadId: threadId, content: content, type: type)
    }
}

public struct NCMCommentAddRespone: NCMResponse {
    public var code: Int
//    public var comment: NCMCommentSongResponse.Comment
    public var message: String?
}


public struct NCMCommentDeleteAction: NCMAction {
    public struct CommentDeleteParameters: Encodable {
        public var threadId: String
        public var commentId: Int
        init(threadId: Int, commentId: Int, type: NCMCommentType) {
            self.threadId = type.rawValue + String(threadId)
            self.commentId = commentId
        }
    }
    public typealias Parameters = CommentDeleteParameters
    public typealias Response = NCMCommentDeleteResponse
    
    public var uri: String { "\(URI)\(NCMCommentAction.delete.rawValue)" }
    public var parameters: Parameters?
    public var responseType = Response.self
    
    public init(threadId: Int, commentId: Int, type: NCMCommentType) {
        self.parameters = Parameters(threadId: threadId, commentId: commentId, type: type)
    }
}

public struct NCMCommentDeleteResponse: NCMResponse {
    public var code: Int
    public var message: String?
}

//public struct NCMCommentReplayAction: NCMAction {
//    public struct CommentReplayParameters: Encodable {
//        public var threadId: String
//        public var commentId: Int
//        init(threadId: Int, cid: Int, commentId: Int, type: CommentType) {
//            self.threadId = type.rawValue + String(threadId)
//            self.commentId = commentId
//        }
//    }
//    public typealias Parameters = CommentReplayParameters
//    public typealias ResponseType = NCMCommentDeleteResponse
//
//    public var uri: String { "\(URI)\(CommentAction.delete.rawValue)" }
//    public let parameters: Parameters
//    public let responseType = ResponseType.self
//}
