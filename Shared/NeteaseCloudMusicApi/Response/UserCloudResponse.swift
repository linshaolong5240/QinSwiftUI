//
//  UserCloudResponse.swift
//  Qin (macOS)
//
//  Created by 林少龙 on 2021/7/8.
//

import Foundation

public struct UserCloudResponse: NeteaseCloudMusicResponse {
    public struct Album: Codable {
        var id: Int
        var name: String?
        var pic: Int
        var pic_str: String?
        var picUrl: String
//        var tns: [Any]
    }

    public struct Artist: Codable {
        var alias: [String]
        var id: Int
        var name: String?
//        var tns: [Any]
    }
    public struct Privilege: Codable {
        public let cp: Int
        public let cs: Bool
        public let dl: Int
        public let fee: Int
        public let fl: Int
        public let flag: Int
        public let id: Int
        public let maxbr: Int
        public let payed: Int
        public let pl: Int
        public let sp: Int
        public let st: Int
        public let subp: Int
        public let toast: Bool
    }
    public struct SimpleSong: Codable {
//        var a: Any?
        var al: Album
        var alia: [String]
        var ar: [Artist]
        var cd: String?
        var cf: String?
        var copyright: Int
        var cp: Int
//        var crbt: Any?
        var djId: Int
        var dt: Int
        var fee: Int
        var ftype: Int
        var h: SongQuality?
        var id: Int
        var l: SongQuality?
        var m: SongQuality?
        var mark: Int
        var mst: Int
        var mv: Int
        var name: String
        var no: Int
//        var noCopyrightRcmd: Any?
        var originCoverType: Int
//        var originSongSimpleData: Any?
        var pop: Int
        var privilege: Privilege
        var pst: Int
        var publishTime: Int
//        var rt: Any
        var rtUrl: String?
        var rtUrls: [String]
        var rtype: Int
        var rurl: String?
        var s_id: Int
        var single: Int
        var st: Int
        var t: Int
        var v: Int
    }
    
    public struct UserCloudSong: Codable {
        var addTime: Int
        var album: String
        var artist: String
        var bitrate: Int
        var cover: Int
        var coverId: String
        var fileName: String
        var fileSize: Int
        var lyricId: String
        var simpleSong: SimpleSong
        var songId: Int
        var songName: String
        var version: Int
    }
    
    var code: Int
    var count: Int
    var data: [UserCloudSong]
    var hasMore: Bool
    var maxSize: String
    var size: String
    var upgradeSign: Int
}
