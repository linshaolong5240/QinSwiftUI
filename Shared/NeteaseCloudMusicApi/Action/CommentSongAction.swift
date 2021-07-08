//
//  CommentSongAction.swift
//  Qin
//
//  Created by 林少龙 on 2021/6/9.
//

import Foundation
//歌曲评论
//    说明 : 调用此接口 , 传入音乐 id 和 limit 参数 , 可获得该音乐的所有评论 ( 不需要 登录 )
//    必选参数 : id: 音乐 id
//    可选参数 : limit: 取出评论数量 , 默认为 20
//    offset: 偏移数量 , 用于分页 , 如 :( 评论页数 -1)*20, 其中 20 为 limit 的值
//    before: 分页参数,取上一页最后一项的 time 获取下一页数据(获取超过5000条评论的时候需要用到)
public struct CommentSongAction: NeteaseCloudMusicAction {
    public struct CommentSongParameters: Encodable {
        public var rid: Int
        public var limit: Int
        public var offset: Int
        public var beforeTime: Int//deftaut 0
    }
    public typealias Parameters = CommentSongParameters
    public typealias Response = CommentSongResponse
    
    public let rid: Int
    public var uri: String { "/weapi/v1/resource/comments/R_SO_4_\(rid)" }
    public let parameters: Parameters
    public let responseType = Response.self
}
