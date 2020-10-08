//
//  HotSong.swift
//  Qin
//
//  Created by 林少龙 on 2020/10/5.
//

import Foundation

struct HotSong: Codable, Identifiable {
    struct NoCopyrightRcmd: Codable {
        var songId: Int?
        var type: Int
        var typeDesc: String
    }
    struct Quality: Codable {
        var bitrate: Int
        var dfsId: Int
        var `extension`: String
        var id: Int
//        var name: Any?
        var playTime: Int
        var size: Int
        var sr: Int//采样率
        var volumeDelta: Double
    }
    var album: Album
    var alias: [String]
    var artists: [Artist]
//    var audition: Any?
    var bMusic: Quality?
    var copyFrom: String
    var copyright: Int?
//    var crbt: Any?
    var dayPlays: Int
    var disc: String
    var duration: Int// duration time
    var fee: Int
    var ftype: Int
    var hMusic: Quality?
    var hearTime: Int
    var id: Int
    var lMusic: Quality?
    var mMusic: Quality?
    var mark: Int
    var mp3Url: String?
    var mvid: Int
    var name: String
    var no: Int
    var noCopyrightRcmd: NoCopyrightRcmd?
    var playedNum: Int
    var popularity: Int
//    var ringtone: Any?
//    var rtUrl: String?
//    var rtUrls: [String]?
    var rtype: Int
//    var rurl: Any?
    var score: Int
    var starred: Bool
    var starredNum: Int
    var status: Int
}
