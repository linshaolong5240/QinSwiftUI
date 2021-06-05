//
//  UserPlaylistResponse.swift
//  Qin
//
//  Created by 林少龙 on 2021/6/6.
//

import Foundation
//用户歌单
public struct UserPlaylistResponse: NeteaseCloudMusicResponse {
    public struct Playlist: Codable {
        public struct Crteator: Codable {
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
            public let birthday, city: Int
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
        public let adType: Int
        public let anonimous: Bool
//        public let artists: Any?
        public let backgroundCoverId: Int
        public let backgroundCoverUrl: String?
        public let cloudTrackCount: Int
        public let commentThreadId: String
        public let coverImgId: Double
        public let coverImgId_str: String?
        public let coverImgUrl: String
        public let createTime: Int
        public let creator: Crteator
        public let description: String?
//        public let englishTitle: Any?
        public let highQuality: Bool
        public let id: Int
        public let name: String
        public let newImported, opRecommend, ordered: Bool
        public let playCount, privacy: Int
//        public let recommendInfo: Any?
//        public let sharedUsers: Any?
        public let specialType, status: Int
        public let subscribed: Bool
        public let subscribedCount: Int
//        public let subscribers: [Any]
        public let tags: [String]
        public let titleImage: Int
        public let titleImageUrl: String?
        public let totalDuration, trackCount, trackNumberUpdateTime: Int
//        public let tracks: Any?
        public let trackUpdateTime: Int
//        public let updateFrequency: Any?
        public let updateTime, userId: Int
    }
    public let code: Int
    public let more: Bool
    public let playlist: [Playlist]
    public let version: String
}
