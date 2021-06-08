//
//  NeteaseCloudMusicResponse.swift
//  Qin
//
//  Created by 林少龙 on 2021/5/26.
//

import Foundation

protocol NeteaseCloudMusicResponse: Codable {
    var code: Int { get }
}

public struct CommonAlbum: Codable {
    public struct Info: Codable {
        public struct CommentThread: Codable {
            public struct ResourceInfo: Codable {
//                    public let creator: Any?
//                    public let encodedId: Any?
                public let id: Int
                public let imgUrl: String
                public let name: String
                public let subTitle: String?
                public let userId: Int
                public let webUrl: String?
            }
            public let commentCount: Int
            public let hotCount: Int
            public let id: String
//                public let latestLikedUsers: Any?
            public let likedCount: Int
            public let resourceId: Int
            public let resourceInfo: ResourceInfo
            public let resourceOwnerId: Int
            public let resourceTitle: String
            public let resourceType: Int
            public let shareCount: Int
        }
        public let commentCount: Int
//        public let comments: Any?
        public let commentThread: CommentThread
//            public let latestLikedUsers: Any?
        public let liked: Bool
        public let likedCount: Int
        public let resourceId: Int
        public let resourceType: Int
        public let shareCount: Int
        public let threadId: String
    }
    public let alias: [String]
    public let artist: CommonArtistResponse
    public let artists: [CommonArtistResponse]
    public let blurPicUrl: String?
    public let briefDesc: String?
    public let commentThreadId: String
    public let company: String?
    public let companyId: Int
    public let copyrightId: Int?
    public let description: String?
    public let id: Int
    public let info: Info?
    public let mark: Int
    public let name: String
    public let onSale: Bool
    public let paid: Bool
    public let pic: Int
    public let picId: Int
    public let picId_str: String?
    public let picUrl: String
    public let publishTime: Int
    public let size: Int
//        public let songs: [Any]
    public let status: Int
    public let subType: String?
    public let tags: String
    public let type: String?
}

public struct CommonArtistResponse: Codable {
    public let accountId: Int?
    public let albumSize: Int
    public let alias: [String]
    public let briefDesc: String
    public let followed: Bool
    public let id: Int
    public let img1v1Id: Int
    public let img1v1Id_str: String?
    public let img1v1Url: String
    public let musicSize: Int
    public let name: String
    public let picId: Int
    public let picUrl: String
    public let topicPerson: Int
    public let trans: String
}

public struct CommonCrteator: Codable {
    public let accountStatus: Int
    public let anchor: Bool
    public let authenticationTypes: Int
    public let authority: Int
    public let authStatus: Int
//            public let avatarDetail: Any?
    public let avatarImgId: Double
    public let avatarImgId_str: String?
    public let avatarImgIdStr: String
    public let avatarUrl: String
    public let backgroundImgId: Double
    public let backgroundImgIdStr: String
    public let backgroundUrl: String
    public let birthday: Int
    public let city: Int
    public let defaultAvatar: Bool
    public let description: String
    public let detailDescription: String
    public let djStatus: Int
//            public let experts: Any?
    public let expertTags: [String]?
    public let followed: Bool
    public let gender: Int
    public let mutual: Bool
    public let nickname: String
    public let province: Int
//            public let remarkName: Any?
    public let signature: String
    public let userId, userType, vipType: Int
}

public struct PlaylistResponse: Codable {
    public struct TrackId: Codable {
//        public let alg: Any?
        public let at: Int
        public let id: Int
        public let rcmdReason: String
        public let t: Int
        public let uid: Int
        public let v: Int
    }
    public let adType: Int
    public let alg: String?
    public let anonimous: Bool?
    //        public let artists: Any?
    public let backgroundCoverId: Int?
    public let backgroundCoverUrl: String?
    public let cloudTrackCount: Int
    public let commentCount: Int?
    public let commentThreadId: String
    public let coverImgId: Int
    public let coverImgIdStr: String?
    public let coverImgUrl: String
    public let coverStatus: Int?
    public let createTime: Int
    public let creator: CommonCrteator?
    public let description: String?
    //        public let englishTitle: Any?
    public let playlistDescription: String?
    public let highQuality: Bool
    public let id: Int
    public let name: String
    public let newImported: Bool
    public let ordered: Bool
    public let playCount: Int
    public let privacy: Int
//    public let remixVideo: Any?
//        public let recommendInfo: Any?
    public let shareCount: Int?
    //        public let sharedUsers: Any?
    public let specialType: Int
    public let status: Int
    public let subscribed: Bool?
    public let subscribedCount: Int
    public let subscribers: [CommonCrteator]
    public let tags: [String]
    public let titleImage: Int?
    public let titleImageUrl: String?
    public let totalDuration: Int?
    public let trackCount: Int
    public let trackIds: [TrackId]?
    public let trackNumberUpdateTime: Int
//    public let tracks: [Track]?
    public let trackUpdateTime: Int
    //        public let updateFrequency: Any?
    public let updateTime: Int
    public let userId: Int
//    public let videoIds: Any?
//    public let videos: Any?
}

public struct PrivilegeResponse: Codable {
    public struct ChargeInfoList: Codable {
        public let chargeMessage: String?
        public let chargeType: Int
        public let chargeUrl: String?
        public let rate: Int
    }
    public struct FreeTrialPrivilege: Codable {
        public let resConsumable: Bool
        public let userConsumable: Bool
    }
    public let chargeInfoList: [ChargeInfoList]
    public let cp: Int
    public let cs: Bool
    public let dl: Int
    public let downloadMaxbr: Int
    public let fee: Int
    public let fl: Int
    public let flag: Int
    public let freeTrialPrivilege: FreeTrialPrivilege
    public let id: Int
    public let maxbr: Int
    public let payed: Int
//    public let pc: Any?
    public let pl: Int
    public let playMaxbr: Int
    public let preSell: Bool
    public let realPayed: Int?
//            public let rscl: Any?
    public let sp: Int
    public let st: Int
    public let subp: Int
    public let toast: Bool
}
