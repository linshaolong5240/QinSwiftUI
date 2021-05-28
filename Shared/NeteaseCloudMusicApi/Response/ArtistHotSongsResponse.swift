//
//  ArtistHotSongsResponse.swift
//  Qin
//
//  Created by 林少龙 on 2021/5/28.
//

import Foundation

public struct ArtistHotSongsResponse: NeteaseCloudMusicResponse {
    public struct HotSong: Codable {
        public struct HotSongAlbum: Codable {
            public let alias: [String]
            public let artist: CommonArtist
            public let artists: [CommonArtist]
            public let blurPicUrl: String
            public let briefDesc: String
            public let commentThreadId: String
            public let company: String?
            public let companyId: Int
            public let copyrightId: Int
            public let description: String
            public let id: Int
            public let mark: Int
            public let name: String
            public let onSale: Bool
            public let paid: Bool
            public let pic: Int
            public let picId: Int
            public let picUrl: String
            public let publishTime: Int
            public let size: Int
//            public let songs:[Any]
            public let status: Int
            public let subType: String?
            public let tags: String
            public let type: String?
        }
        public struct Quality: Codable {
            public let bitrate: Int
            public let dfsId: Int
            public let `extension`: String
            public let id: Int
            public let name: String?
            public let playTime: Int
            public let size: Int
            public let sr: Int
            public let volumeDelta: Double
        }
        public let album: HotSongAlbum
        public let alias: [String]
        public let artists: [CommonArtist]
//        public let audition: Any?
        public let bMusic: Quality?
        public let copyFrom: String
        public let copyrightId: Int
//        public let crbt: Any?
        public let dayPlays: Int
        public let disc: String
        public let duration: Int
        public let fee: Int
        public let ftype: Int
        public let hearTime: Int
        public let hMusic: Quality?
        public let id: Int
        public let lMusic: Quality?
        public let mark: Int
        public let mMusic: Quality?
        public let mp3Url: String
        public let mvid: Int
        public let name: String
        public let no: Int
//        public let noCopyrightRcmd: Any?
        public let originCoverType: Int
//        public let originSongSimpleData: Any?
        public let playedNum: Int
        public let popularity:Int
//        public let ringtone: Any?
//        public let rtUrl: Any?
//        public let rtUrls: Any?
        public let rtype:Int
//        public let rurl: Any?
        public let score: Int
        public let starred: Bool
        public let starredNum: Int
        public let status: Int
    }
    public let artist: CommonArtist
    public let code: Int
    public let hotSongs: [HotSong]
    public let more: Bool
}
