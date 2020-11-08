//
//  Search.swift
//  Qin
//
//  Created by 林少龙 on 2020/8/27.
//
struct SearchSongResultJSONModel: Codable, Identifiable {
    struct Album: Codable, Identifiable {
        var artist: ArtistJSONModel
        var copyrightId: Int
        var id: Int64
        var mark: Int
        var name: String
        var picId: Int
        var publishTime: Int
        var size: Int
        var status: Int
    }
    var album: Album
    var alias: [String]
    var artists: [ArtistJSONModel]
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

struct SearchPlaylist: Codable, Identifiable {
    struct Artist: Codable, Identifiable {
        var albumSize: Int
        var alias: [String]
        var briefDesc: String
        var id: Int64
        var img1v1Id: Int
        var img1v1Url: String
        var musicSize: Int
        var name: String
        var picId: Int
        var picUrl: String?
        var trans: String
    }
    struct Album: Codable, Identifiable {
        var alias: [String]
        var artist: Artist
        var artists: [Artist]
        var blurPicUrl: String?
        var briefDesc: String
        var commentThreadId: String
        var company: String?
        var companyId: Int
        var copyrightId: Int
        var description: String
        var id: Int64
        var name: String
        var pic: Int
        var picId: Int
//        var picId_str: String?
        var picUrl: String
        var publishTime: Int
        var size: Int
//        var songs: [Any]
        var status: Int
        var tags: String
        var type: String?
    }
    struct Creator: Codable {
        var authStatus: Int
//        var expertTags: Any?
//        var experts: Any?
        var nickname: String
        var userId: Int
        var userType: Int
    }
    struct Track: Codable, Identifiable {
        struct Quality: Codable {
            var bitrate: Int
            var dfsId: Int
            var `extension`: String
            var id: Int64
            var name: String?
            var playTime: Int
            var size: Int
            var sr: Int
            var volumeDelta: Double
        }
        var album: Album
        var alias: [String]
        var artists: [Artist]
//        var audition: Any?
        var bMusic: Quality?
        var commentThreadId: String
        var copyFrom: String
        var copyright: Int
        var copyrightId: Int
//        var crbt: Any?
        var dayPlays: Int
        var disc: String
        var duration: Int
        var fee: Int
        var ftype: Int
        var hMusic: Quality?
        var hearTime: Int
        var id: Int64
        var lMusic: Quality?
        var mMusic: Quality?
        var mp3Url: String?
        var mvid: Int
        var name: String
        var no: Int
        var playedNum: Int
        var popularity: Int
        var position: Int
//        var ringtone: Any?
        var rtUrl: String?
        var rtUrls: [String]
        var rtype: Int
        var rurl: String?
        var score: Int
        var starred: Bool
        var starredNum: Int
        var status: Int
    }

    var alg: String
    var bookCount: Int
    var coverImgUrl: String
    var creator: Creator
    var description: String?
    var highQuality: Bool
    var id: Int64
    var name: String
//    var officialTags: Any?
    var playCount: Int
    var subscribed: Bool
    var track: Track
    var trackCount: Int
    var userId: Int64
}
