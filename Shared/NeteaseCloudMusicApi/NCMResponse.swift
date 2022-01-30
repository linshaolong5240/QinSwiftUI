//
//  NeteaseCloudMusicResponse.swift
//  Qin
//
//  Created by 林少龙 on 2021/5/26.
//  Copyright © 2022 com.teenloong. All rights reserved.
//

import Foundation

public protocol NCMResponse: Codable {
    var code: Int { get }
    var message: String? { get }
}

public extension NCMResponse {
    var isSuccess: Bool { code == 200 }
}

public struct SongQuality: Codable {
    public var br: Int
    public var fid: Int
    public var size: Int
    public var vd: Double
}

public struct AlbumResponse: Codable {
    public struct Info: Codable {
        public struct CommentThread: Codable {
            public struct ResourceInfo: Codable {
//                    public var creator: Any?
//                    public var encodedId: Any?
                public var id: Int
                public var imgUrl: String
                public var name: String
                public var subTitle: String?
                public var userId: Int
                public var webUrl: String?
            }
            public var commentCount: Int
            public var hotCount: Int
            public var id: String
//                public var latestLikedUsers: Any?
            public var likedCount: Int
            public var resourceId: Int
            public var resourceInfo: ResourceInfo
            public var resourceOwnerId: Int
            public var resourceTitle: String
            public var resourceType: Int
            public var shareCount: Int
        }
        public var commentCount: Int
//        public var comments: Any?
        public var commentThread: CommentThread
//            public var latestLikedUsers: Any?
        public var liked: Bool
        public var likedCount: Int
        public var resourceId: Int
        public var resourceType: Int
        public var shareCount: Int
        public var threadId: String
    }
    public var alias: [String]
    public var artist: ArtistResponse
    public var artists: [ArtistResponse]
    public var blurPicUrl: String?
    public var briefDesc: String?
    public var commentThreadId: String
    public var company: String?
    public var companyId: Int
    public var copyrightId: Int?
    public var description: String?
    public var id: Int
    public var info: Info?
    public var mark: Int
    public var name: String
    public var onSale: Bool
    public var paid: Bool
    public var pic: Int
    public var picId: Int
    public var picId_str: String?
    public var picUrl: String
    public var publishTime: Int
    public var size: Int
//        public var songs: [Any]
    public var status: Int
    public var subType: String?
    public var tags: String
    public var type: String?
}

public struct ArtistResponse: Codable {
    public var accountId: Int?
    public var albumSize: Int
    public var alias: [String]
    public var briefDesc: String
    public var followed: Bool
    public var id: Int
    public var img1v1Id: Int
    public var img1v1Id_str: String?
    public var img1v1Url: String
    public var musicSize: Int
    public var name: String
    public var picId: Int
    public var picUrl: String
    public var topicPerson: Int
    public var trans: String
}

public struct CrteatorResponse: Codable {
    public var accountStatus: Int
    public var anchor: Bool
    public var authenticationTypes: Int
    public var authority: Int
    public var authStatus: Int
//            public var avatarDetail: Any?
    public var avatarImgId: Double
    public var avatarImgId_str: String?
    public var avatarImgIdStr: String
    public var avatarUrl: String
    public var backgroundImgId: Double
    public var backgroundImgIdStr: String
    public var backgroundUrl: String?
    public var birthday: Int
    public var city: Int
    public var defaultAvatar: Bool
    public var description: String
    public var detailDescription: String
    public var djStatus: Int
//            public var experts: Any?
    public var expertTags: [String]?
    public var followed: Bool
    public var gender: Int
    public var mutual: Bool
    public var nickname: String
    public var province: Int
//            public var remarkName: Any?
    public var signature: String
    public var userId, userType, vipType: Int
}

public struct SongResponse: Codable {
    public struct Al: Codable {
        public var id: Int
        public var name: String?
        public var pic: Double
        public var picUrl: String
        public var tns: [String]
        public var picStr: String?
    }

    public struct Ar: Codable {
        public var alias: [String]
        public var id: Int
        public var name: String?
        public var tns: [String]
    }
    public struct NoCopyrightRcmd: Codable {
    //            public var songId: Any?
        public var type: Int
        public var typeDesc: String
    }

    public struct OriginSongSimpleData: Codable {
        public struct AlbumMeta: Codable {
            public var id: Int
            public var name: String
        }
        public struct ArtistMeta: Codable {
            public var id: Int
            public var name: String
        }
        public var albumMeta: AlbumMeta
        public var artists: [ArtistMeta]
        public var name: String
        public var songId: Int
    }
//        public var a: Any?
    public var al: Al
    public var alia: [String]
    public var ar: [Ar]
    public var cd: String?
    public var cf: String?
    public var copyright: Int
    public var cp: Int
//        public var crbt: Any?
    public var djId: Int
    public var dt: Int
    public var fee: Int
    public var ftype: Int
    public var h: SongQuality?
    public var id: Int
    public var l: SongQuality?
    public var m: SongQuality?
    public var mark: Double
    public var mst: Int
    public var mv: Int
    public var name: String
    public var no: Int
    public var noCopyrightRcmd: NoCopyrightRcmd?
    public var originCoverType: Int
    public var originSongSimpleData: OriginSongSimpleData?
    public var pop: Int
    public var pst: Int
    public var publishTime: Int
    public var resourceState: Bool?
    public var rt: String?
    public var rtUrl: String?
    public var rtUrls: [String]
    public var rtype: Int
    public var rurl: String?
    public var sid: Int?
    public var single: Int
    public var st: Int
    public var t: Int
    public var v: Int
}

public struct PlaylistResponse: Codable {
    public struct TrackId: Codable {
//        public var alg: Any?
        public var at: Int
        public var id: Int
        public var rcmdReason: String
        public var t: Int
        public var uid: Int
        public var v: Int
    }
    public var adType: Int
    public var alg: String?
    public var anonimous: Bool?
    //        public var artists: Any?
    public var backgroundCoverId: Int?
    public var backgroundCoverUrl: String?
    public var cloudTrackCount: Int
    public var commentCount: Int?
    public var commentThreadId: String
    public var coverImgId: Int
    public var coverImgIdStr: String?
    public var coverImgUrl: String
    public var coverStatus: Int?
    public var createTime: Int
    public var creator: CrteatorResponse?
    public var description: String?
    //        public var englishTitle: Any?
    public var playlistDescription: String?
    public var highQuality: Bool
    public var id: Int
    public var name: String
    public var newImported: Bool
    public var ordered: Bool
    public var playCount: Int
    public var privacy: Int
//    public var remixVideo: Any?
//        public var recommendInfo: Any?
    public var shareCount: Int?
    //        public var sharedUsers: Any?
    public var specialType: Int
    public var status: Int
    public var subscribed: Bool?
    public var subscribedCount: Int
    public var subscribers: [CrteatorResponse]
    public var tags: [String]
    public var titleImage: Int?
    public var titleImageUrl: String?
    public var totalDuration: Int?
    public var trackCount: Int
    public var trackIds: [TrackId]?
    public var trackNumberUpdateTime: Int
//    public var tracks: [Track]?
    public var trackUpdateTime: Int
    //        public var updateFrequency: Any?
    public var updateTime: Int
    public var userId: Int
//    public var videoIds: Any?
//    public var videos: Any?
}

public struct PrivilegeResponse: Codable {
    public struct ChargeInfoList: Codable {
        public var chargeMessage: String?
        public var chargeType: Int
        public var chargeUrl: String?
        public var rate: Int
    }
    public struct FreeTrialPrivilege: Codable {
        public var resConsumable: Bool
        public var userConsumable: Bool
    }
    public var chargeInfoList: [ChargeInfoList]?
    public var cp: Int
    public var cs: Bool
    public var dl: Int
    public var downloadMaxbr: Int
    public var fee: Int
    public var fl: Int
    public var flag: Int
    public var freeTrialPrivilege: FreeTrialPrivilege
    public var id: Int
    public var maxbr: Int
    public var payed: Int
//    public var pc: Any?
    public var pl: Int
    public var playMaxbr: Int
    public var preSell: Bool
    public var realPayed: Int?
//            public var rscl: Any?
    public var sp: Int
    public var st: Int
    public var subp: Int
    public var toast: Bool
}
