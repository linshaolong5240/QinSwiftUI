//
//  Song.swift
//  Qin
//
//  Created by 林少龙 on 2020/6/24.
//  Copyright © 2020 teenloong. All rights reserved.
//

import Foundation
struct SongDetail: Codable, Identifiable {
    struct Album: Codable {
        var id: Int
        var name: String?
        var pic: Int
        var picUrl: String
        var pic_str: String?//optional for playlist detail
//        var tns: [Any]
    }
    struct Artist: Codable, Identifiable {
        var alias: [String]
        var id: Int
        var name: String?
//        var tns: [Any]
    }
    struct Privilege: Codable {//recommendSongs
        var cp: Int
        var cs: Bool
        var dl: Int
        var fee: Int
        var fl: Int
        var flag: Int
        var id: Int
        var maxbr: Int
        var payed: Int
        var pl: Int
        var preSell: Bool
        var sp: Int
        var st: Int
        var subp: Int
        var toast: Bool
    }
    struct Quality: Codable {
        var br: Int
        var fid: Int
        var size: Int
        var vd: Double?
    }
//    var a: Any?
    var al: Album
    var alia: [String]
    var ar: [Artist]
    var cd: String?
    var cf: String?
    var copyright: Int
    var cp: Int
//    var crbt: Any?
    var djId: Int
    var dt: Int// duration time
    var fee: Int
    var ftype: Int
    var h: Quality?
    var id: Int
    var l: Quality?
    var m: Quality?
    var mark: Int
    var mst: Int
    var mv: Int
    var name: String
    var no: Int
//    var noCopyrightRcmd: Any?
    var originCoverType: Int
    var pop: Int
    var privilege: Privilege?//optional for recommendSongs
    var pst: Int
    var reason: String? //optional for recommendSongs
    var publishTime: Int
    var rt: String?//optional for playlist detail
    var rtUrl: String?
    var rtUrls: [String]
    var rtype: Int
    var rurl: String?
    var s_id: Int
    var single: Int?//optional for playlist detail
    var st: Int
    var t: Int
    var v: Int
}
