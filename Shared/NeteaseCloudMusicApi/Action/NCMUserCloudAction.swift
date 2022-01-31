//
//  NCMUserCloudAction.swift
//  Qin (macOS)
//
//  Created by 林少龙 on 2021/7/8.
//  Copyright © 2022 com.teenloong. All rights reserved.
//

import Foundation

public struct NCMUserCloudAction: NCMAction {
    public struct UserCloudActionParameters: Encodable {
        public var limit: Int
        public var offset: Int
    }
    public typealias Parameters = UserCloudActionParameters
    public typealias Response = NCMUserCloudResponse

    public var uri: String { "/weapi/v1/cloud/get" }
    public var parameters: Parameters
    public var responseType = Response.self
    
    public init(limit: Int, offset: Int) {
        self.parameters = Parameters(limit: limit, offset: offset)
    }
}

public struct NCMUserCloudResponse: NCMResponse {
    public struct Album: Codable {
        public var id: Int
        public var name: String?
        public var pic: Int
        public var pic_str: String?
        public var picUrl: String
//        public var tns: [Any]
    }

    public struct Artist: Codable {
        public var alias: [String]
        public var id: Int
        public var name: String?
//        var tns: [Any]
    }
    public struct Privilege: Codable {
        public var cp: Int
        public var cs: Bool
        public var dl: Int
        public var fee: Int
        public var fl: Int
        public var flag: Int
        public var id: Int
        public var maxbr: Int
        public var payed: Int
        public var pl: Int
        public var sp: Int
        public var st: Int
        public var subp: Int
        public var toast: Bool
    }
    public struct SimpleSong: Codable {
//        public var a: Any?
        public var al: Album
        public var alia: [String]
        public var ar: [Artist]
        public var cd: String?
        public var cf: String?
        public var copyright: Int
        public var cp: Int
//        public var crbt: Any?
        public var djId: Int
        public var dt: Int
        public var fee: Int
        public var ftype: Int
        public var h: NCMSongQuality?
        public var id: Int
        public var l: NCMSongQuality?
        public var m: NCMSongQuality?
        public var mark: Int
        public var mst: Int
        public var mv: Int
        public var name: String
        public var no: Int
//      public var noCopyrightRcmd: Any?
        public var originCoverType: Int
//      public var originSongSimpleData: Any?
        public var pop: Int
        public var privilege: Privilege
        public var pst: Int
        public var publishTime: Int
//      public var rt: Any
        public var rtUrl: String?
        public var rtUrls: [String]
        public var rtype: Int
        public var rurl: String?
        public var s_id: Int
        public var single: Int
        public var st: Int
        public var t: Int
        public var v: Int
    }
    
    public struct UserCloudSong: Codable {
        public var addTime: Int
        public var album: String
        public var artist: String
        public var bitrate: Int
        public var cover: Int
        public var coverId: String
        public var fileName: String
        public var fileSize: Int
        public var lyricId: String
        public var simpleSong: SimpleSong
        public var songId: Int
        public var songName: String
        public var version: Int
    }
    public var code: Int
    public var upgradeSign: Int
    public var message: String?
}
