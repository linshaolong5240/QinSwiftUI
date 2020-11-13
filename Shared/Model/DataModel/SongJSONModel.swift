//
//  SongJSONModel.swift
//  Qin
//
//  Created by 林少龙 on 2020/10/5.
//

import Foundation
import CoreData

struct SongJSONModel: Codable, Identifiable {
    struct NoCopyrightRcmd: Codable {
        var songId: String?
        var type: Int
        var typeDesc: String
    }
    struct Quality: Codable {
        var bitrate: Int
        var dfsId: Int
        var `extension`: String
        var id: Int64
//        var name: Any?
        var playTime: Int
        var size: Int
        var sr: Int//采样率
        var volumeDelta: Double
    }
    var album: AlbumJSONModel
    var alias: [String]
    var artists: [ArtistJSONModel]
//    var audition: Any?
    var bMusic: Quality?
    var commentThreadId: String?// album
    var copyFrom: String
    var copyright: Int?
    var copyrightId: Int?// album
//    var crbt: Any?
    var dayPlays: Int
    var disc: String
    var duration: Int64// duration time
    var fee: Int
    var ftype: Int
    var hMusic: Quality?
    var hearTime: Int
    var id: Int64
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
    var position: Int?// album
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

extension SongJSONModel {
    public func toSongEntity(context: NSManagedObjectContext) -> Song {
        let song = Song(context: context)
        song.al = self.album.toDictionary()
        let album = self.album.toAlbumEntity(context: context)
        album.addToSongs(song)
        var ar = [[String: Any]]()
        for a in self.artists {
            let artist = a.toArtistEntity(context: context)
            artist.addToSongs(song)
            artist.addToAlbums(album)
            ar.append(a.toDictionary())
        }
        song.ar = ar
        song.durationTime = self.duration
        song.id = self.id
        song.name = self.name
        return song
    }
}
