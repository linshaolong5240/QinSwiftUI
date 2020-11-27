//
//  Album.swift
//  Qin
//
//  Created by 林少龙 on 2020/10/5.
//

import Foundation
import CoreData

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
        var creator: CreatorJSONModel?
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
        var liked: Bool
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
    var isSub: Bool? //optional for Artist album
    var mark: Int
    var name: String?
    var onSale: Bool
    var paid: Bool
    var pic: Int
    var picId: Int
    var picId_str: String?
    var picUrl: String
    var publishTime: Int64
    var size: Int
//    var songs: [Any]
    var status: Int
    var subType: String?
    var tags: String
    var type: String?
}

extension AlbumJSONModel {
    public func toAlbumEntity(context: NSManagedObjectContext) -> Album {
        let entity = Album(context: context)
        entity.id = self.id
        entity.introduction = self.description
        entity.name = self.name
        entity.picUrl = self.picUrl
        entity.publishTime = self.publishTime
        return entity
    }
}
