//
//  SearchSongJSONModel.swift
//  Qin
//
//  Created by 林少龙 on 2020/8/27.
//
struct SearchSongJSONModel: Codable, Identifiable {
    struct Album: Codable, Identifiable {
        var artist: Artist
        var copyrightId: Int
        var id: Int64
        var mark: Int
        var name: String
        var picId: Int
        var publishTime: Int
        var size: Int
        var status: Int
    }
    struct Artist: Codable, Identifiable {
        var albumSize: Int
        var alias: [String]
        var copyrightId: Int
        var id: Int64
        var img1v1: Int
        var img1v1Url: String
        var name: String
        var picId: Int
        var picUrl: String?
        var trans: String?
    }
    var album: Album
    var alias: [String]
    var artists: [Artist]
    var copyrightId: Int
    var duration: Int
    var fee: Int
    var ftype: Int
    var id: Int64
    var mark: Int
    var mvid: Int
    var name: String
    var rUrl: String?
    var rtype: Int
    var status: Int
}
