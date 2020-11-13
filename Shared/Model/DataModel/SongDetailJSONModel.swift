//
//  Song.swift
//  Qin
//
//  Created by 林少龙 on 2020/6/24.
//  Copyright © 2020 teenloong. All rights reserved.
//

import Foundation
import CoreData

struct SongDetailJSONModel: Codable, Identifiable {
    struct SongDetailAlbum: Codable {
        var id: Int64
        var name: String?
        var pic: Int
        var picUrl: String? //optional for album detail
        var pic_str: String?//optional for playlist detail
//        var tns: [Any]
        public func toAlbumEntity(context: NSManagedObjectContext) -> Album {
            let album = Album(context: context)
            album.id = self.id
            album.name = self.name
            album.picUrl = self.picUrl
            return album
        }
        public func toDictionary() -> Dictionary<String, Any> {
            return ["id": self.id, "name": self.name ?? "", "picUrl": self.picUrl ?? ""]
        }
    }
    struct SongDetailArtist: Codable, Identifiable {
        var alias: [String]? //optional for album detail
        var id: Int64
        var name: String?
//        var tns: [Any]
        init(id: Int64, name: String?) {
            self.alias = nil
            self.id = id
            self.name = name
        }
        public func toArtist(context: NSManagedObjectContext) -> Artist {
            let artist = Artist(context: context)
            artist.id = self.id
            artist.name = self.name
            return artist
        }
        public func toDictionary() -> Dictionary<String, Any> {
            return ["id": self.id, "name": self.name ?? ""]
        }
    }
    struct Privilege: Codable {// album,recommendSongs
        struct ChargeInfoList: Codable {// album
            var chargeMessage: String?
            var chargeType: Int
            var chargeUrl: String?
            var rate: Int
        }
        var chargeInfoList: [ChargeInfoList]?//optional for recommendSongs
        var cp: Int
        var cs: Bool
        var dl: Int
        var downloadMaxbr: Int? // optional for recommendSongs
        var fee: Int
        var fl: Int
        var flag: Int
        var id: Int64
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
    var al: SongDetailAlbum
    var alia: [String]
    var ar: [SongDetailArtist]
    var cd: String?
    var cf: String?
    var copyright: Int? //optional for album detail
    var cp: Int
//    var crbt: Any?
    var djId: Int
    var dt: Int64// duration time
    var fee: Int
    var ftype: Int
    var h: Quality?
    var id: Int64
    var l: Quality?
    var m: Quality?
    var mark: Int?//optional for album detail
    var mst: Int
    var mv: Int
    var name: String
    var no: Int
//    var noCopyrightRcmd: Any?
    var originCoverType: Int?//optional for album detail
    var pop: Int
    var privilege: Privilege?//optional for recommendSongs
    var pst: Int
    var reason: String? //optional for album, recommendSongs
    var publishTime: Int?//optional for album detail
    var rt: String?//optional for playlist detail
    var rtUrl: String?
    var rtUrls: [String]
    var rtype: Int
    var rurl: String?
    var s_id: Int?//optional for album detail
    var single: Int?//optional for album,playlist detail
    var st: Int
    var t: Int
    var v: Int
}

extension SongDetailJSONModel {
    public func toSongEntity(context: NSManagedObjectContext) -> Song {
        let song = Song(context: context)
        song.al = self.al.toDictionary()
        let album = self.al.toAlbumEntity(context: context)
        album.addToSongs(song)
        var ar = [[String: Any]]()
        for a in self.ar {
            ar.append(a.toDictionary())
            let artist = a.toArtist(context: context)
            artist.addToSongs(song)
            artist.addToAlbums(album)
        }
        song.ar = ar
        song.durationTime = self.dt
        song.id = self.id
        song.name = self.name
        return song
    }
}
