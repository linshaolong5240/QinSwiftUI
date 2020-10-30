//
//  Album.swift
//  Qin
//
//  Created by 林少龙 on 2020/10/5.
//

import Foundation

struct AlbumJSONModel: Codable, Identifiable {
    struct CommentThread: Codable {
        var commentCount: Int
        var hotCount: Int
        var id: String
//            var latestLikedUsers: [Any]?
        var likedCount: Int
        var resourceId: Int
        var resourceInfo: ResourceInfo
        var resourceOwnerId: Int
        var resourceTitle: String
        var resourceType: Int
        var shareCount: Int
    }
    struct ResourceInfo: Codable {
        var creator: Creator?
//        var encodedId: Any?
        var id: Int64
        var imgUrl: String
        var name: String
        var subTitle: String?
        var userId: Int
        var webUrl: String?
    }
    struct Info: Codable {
        var commentCount: Int
        var commentThread: CommentThread
//        var comments: Any?
//        var latestLikedUsers: Any?
        var liked: Int
        var likedCount: Int
        var resourceId: Int
        var resourceType: Int
        var shareCount: Int
        var threadId: String
    }
    var alias: [String]
    var artist: ArtistJSONModel
    var artists: [ArtistJSONModel]
    var blurPicUrl: String? //optional for Artist
    var briefDesc: String?
    var commentThreadId: String
    var company: String?
    var companyId: Int
    var copyrightId: Int
    var description: String?
    var id: Int64
    var Info: Info?
    var isSub: Bool?
    var mark: Int
    var name: String?
    var onSale: Bool
    var paid: Bool
    var pic: Int
    var picId: Int
    var picId_str: String?
    var picUrl: String
    var publishTime: Int
    var size: Int
    var songs: [SongDetail]
    var status: Int
    var subType: String?
    var tags: String
    var type: String?
}
