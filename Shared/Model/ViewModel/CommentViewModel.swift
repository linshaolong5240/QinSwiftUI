//
//  CommentViewModel.swift
//  Qin
//
//  Created by 林少龙 on 2020/8/1.
//  Copyright © 2020 teenloong. All rights reserved.
//

import Foundation

class CommentViewModel: ObservableObject, Identifiable {
    var beReplied = [CommentViewModel]()
    var commentId: Int64 = 0
    var content: String = ""
    var id: Int64 = 0 // commentId for Identifiable
    @Published var liked: Bool = false
    var likedCount: Int = 0
    var parentCommentId: Int = 0
    var userId: Int64 = 0
    var avatarUrl: String = ""
    var nickname: String = ""
    
    init() {
    }
    init(_ comment: CommentSongResponse.Comment) {
        self.beReplied = comment.beReplied.map{CommentViewModel($0)}
        self.commentId = Int64(comment.commentId)
        self.content = comment.content
        self.id = Int64(comment.commentId)
        self.liked = comment.liked
        self.likedCount = comment.likedCount
        self.parentCommentId = comment.parentCommentId
        self.userId = Int64(comment.user.userId)
        self.avatarUrl = comment.user.avatarUrl
        self.nickname = comment.user.nickname
    }
    
    init(_ comment: CommentSongResponse.Comment.BeReplied) {
        self.commentId = Int64(comment.beRepliedCommentId)
        self.content = comment.content
        self.id = Int64(comment.user.userId)
        self.avatarUrl = comment.user.avatarUrl
        self.nickname = comment.user.nickname
    }
    
    init(_ comment: CommentJSONModel.RepliedComment) {
        self.commentId = comment.beRepliedCommentId
        self.content = comment.content ?? ""
        self.id = comment.user.userId
        self.avatarUrl = comment.user.avatarUrl
        self.nickname = comment.user.nickname
    }
    init(_ comment: CommentJSONModel) {
        self.beReplied = comment.beReplied.map{CommentViewModel($0)}
        self.commentId = comment.commentId
        self.content = comment.content
        self.id = comment.commentId
        self.liked = comment.liked
        self.likedCount = comment.likedCount
        self.parentCommentId = comment.parentCommentId
        self.userId = comment.user.userId
        self.avatarUrl = comment.user.avatarUrl
        self.nickname = comment.user.nickname
    }
}
