//
//  AlbumResponse.swift
//  Qin
//
//  Created by 林少龙 on 2021/5/27.
//

import Foundation

public struct AlbumResponse: NeteaseCloudMusicResponse {

    public struct AlbumSong: Codable {
        public struct Album: Codable {
            public let id: Int
            public let name: String
            public let pic: Int
            public let pic_str: String
        }
        public struct AlbumSongArtist: Codable {
            public let id: Int
            public let name: String
        }
        public struct Quality: Codable {
            var br: Int
            var fid: Int
            var size: Int
            var vd: Double
        }
//        public let a: Any?
        public let al: Album
        public let alia: [String]
        public let ar: [AlbumSongArtist]
        public let cd: String
        public let cf: String
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

        public let mst: Int
        public let mv: Int
        public let name: String
        public let no: Int
//        public let noCopyrightRcmd: Any?
        public let pop: Int
        public let privilege: PrivilegeResponse
        public let pst: Int
        public let rt: String?
        public let rtUrl: String?
        public let rtUrls: [String]
        public let rtype: Int
        public let rurl: String?
        public let st: Int
        public let t: Int
        public let v: Int
    }
    public let album: CommonAlbum
    public let code: Int
    public let resourceState: Bool
    public let songs: [AlbumSong]
}
