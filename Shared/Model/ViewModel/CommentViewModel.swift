//
//  CommentViewModel.swift
//  Qin
//
//  Created by 林少龙 on 2020/8/1.
//  Copyright © 2020 teenloong. All rights reserved.
//

import Foundation

class CommentViewModel: Codable, Identifiable {
    var beReplied = [CommentViewModel]()
    var commentId: Int = 0
    var content: String = ""
    var id: Int = 0
    var liked: Bool = false
    var likedCount: Int = 0
    var parentCommentId: Int = 0
    
    var avatarUrl: String = ""
    var nickname: String = ""
    
    init() {
    }
    
    init(_ comment: Comment) {
        self.commentId = comment.commentId
        self.content = comment.content
        self.id = comment.commentId
        self.liked = comment.liked
        self.likedCount = comment.likedCount
        self.parentCommentId = comment.parentCommentId
        
        self.avatarUrl = comment.user.avatarUrl
        self.nickname = comment.user.nickname
    }
}
