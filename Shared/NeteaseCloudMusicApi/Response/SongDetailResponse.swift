//
//  SongDetailResponse.swift
//  Qin
//
//  Created by qfdev on 2021/6/8.
//

import Foundation
//歌曲详情
public struct SongDetailResponse: NeteaseCloudMusicResponse {
    public struct SongResponse: Codable {
        public struct Album: Codable {
            public let id: Int
            public let name: String
            public let pic: Double
            public let picUrl: String
            public let tns: [String]
            public let picStr: String?
        }
        public struct Artist: Codable {
            public let alias: [String]
            public let id: Int
            public let name: String
            public let tns: [String]
        }
        public struct NoCopyrightRcmd: Codable {
//            public let songId: Any?
            public let type: Int
            public let typeDesc: String
        }
        public struct Quality: Codable {
            public let br: Int
            public let fid: Int
            public let size: Int
            public let vd: Double
        }
//        public let a: Any?
        public let al: Album
        public let alia: [String]
        public let ar: [Artist]
        public let cd: String
        public let cf: String
        public let copyright: Int
        public let cp: Int
//        public let crbt: Any?
        public let djId: Int
        public let dt: Int
        public let fee: Int
        public let ftype: Int
        public let h: Quality?
        public let id: Int
        public let l: Quality?
        public let m: Quality?
        public let mark: Double
        public let mst: Int
        public let mv: Int
        public let name: String
        public let no: Int
        public let noCopyrightRcmd: NoCopyrightRcmd?
        public let originCoverType: Int
//        public let originSongSimpleData: Any?
        public let pop: Int
        public let pst: Int
        public let publishTime: Int
        public let resourceState: Bool
        public let rt: String?
        public let rtUrl: String?
        public let rtUrls: [String]
        public let rtype: Int
        public let rurl: String?
        public let sid: Int?
        public let single: Int
        public let st: Int
        public let t: Int
        public let v: Int
    }
    public let code: Int
    public let privileges: [PrivilegeResponse]
    public let songs: [SongResponse]
}
