//
//  CommentLikeAction.swift
//  Qin
//
//  Created by 林少龙 on 2021/6/9.
//

import Foundation
public enum CommentType: String, Encodable {
    case song = "R_SO_4_"//  歌曲
    case mv = "R_MV_5_"//  MV
    case playlist = "A_PL_0_"//  歌单
    case album = "R_AL_3_"//  专辑
    case dj = "A_DJ_1_"//  电台
    case vedio = "R_VI_62_"//  视频
    case event = "A_EV_2_"//  动态
}
// 评论点赞与取消点赞
// 动态点赞不需要传入 id 参数，需要传入动态的 threadId 参数
public struct CommentLikeAction: NeteaseCloudMusicAction {
    public struct CommentLikeParameters: Encodable {
        public var threadId: String
        public var commentId: Int
        
        init(threadId: Int, commentId: Int, commentType: CommentType) {
            self.threadId = commentType.rawValue + String(commentId)
            self.commentId = commentId
        }
    }
    public typealias Parameters = CommentLikeParameters
    public typealias ResponseType = CommentLikeResponse

    public var like: Bool
    public var uri: String { "/weapi/v1/comment/\(like ? "like" : "unlike")" }
    public let parameters: Parameters
    public let responseType = ResponseType.self
}
