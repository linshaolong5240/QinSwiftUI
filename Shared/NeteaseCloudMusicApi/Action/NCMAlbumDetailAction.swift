//
//  NCMAlbumDetailAction.swift
//  Qin
//
//  Created by 林少龙 on 2021/6/11.
//  Copyright © 2022 com.teenloong. All rights reserved.
//

import Foundation
//专辑内容
public struct NCMAlbumDetailAction: NCMAction {
    public typealias Parameters = NCMEmptyParameters
    public typealias Response = NCMAlbumDetailResponse
    
    public var id: Int
    public var uri: String { "/weapi/v1/album/\(id)"}
    public var parameters = Parameters()
    public var responseType = Response.self
}

public struct NCMAlbumDetailResponse: NCMResponse {

    public struct AlbumSong: Codable {
        public struct Album: Codable {
            public var id: Int
            public var name: String
            public var pic: Int
            public var pic_str: String
        }
        public struct AlbumSongArtist: Codable {
            public var id: Int
            public var name: String
        }
        public struct Quality: Codable {
            var br: Int
            var fid: Int
            var size: Int
            var vd: Double
        }
//        public var a: Any?
        public var al: Album
        public var alia: [String]
        public var ar: [AlbumSongArtist]
        public var cd: String
        public var cf: String
        public var cp: Int
//        public var crbt: Any?
        public var djId: Int
        public var dt: Int
        public var fee: Int
        public var ftype: Int
        public var h: Quality?
        public var id: Int
        public var l: Quality?
        public var m: Quality?

        public var mst: Int
        public var mv: Int
        public var name: String
        public var no: Int
//        public var noCopyrightRcmd: Any?
        public var pop: Int
        public var privilege: PrivilegeResponse
        public var pst: Int
        public var rt: String?
        public var rtUrl: String?
        public var rtUrls: [String]
        public var rtype: Int
        public var rurl: String?
        public var st: Int
        public var t: Int
        public var v: Int
    }
    public var album: AlbumResponse
    public var code: Int
    public var resourceState: Bool
    public var songs: [AlbumSong]
    public var message: String?
}
