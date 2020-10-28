//
//  PlaylistModel.swift
//  Qin
//
//  Created by 林少龙 on 2020/10/28.
//

import Foundation

struct PlaylistModel: Codable {
    var coverImgUrl: String
    var id: Int64
    var name: String
    var subscribed: Bool
    var trackIds: [Int64]?
    var userId: Int64
//    private enum CodingKeys: String, CodingKey {
//        case album = "al"
//        case artists = "ar"
//        case id = "id"
//        case name = "name"
//    }
//    public func insetObject(context: NSManagedObjectContext) {
//        let song = Song(context: context)
//        song.id = self.id
//        song.name = self.name
//
//        let album = Album(context: context)
//        album.id = self.al.id
//        album.name = self.al.name
//        album.picUrl = self.al.picUrl
//        album.addToSongs(song)
//
//        for ar in self.ar {
//            let artist = Artist(context: context)
//            artist.id = ar.id
//            artist.name = ar.name
//            artist.picUrl = ar.picUrl
//            artist.addToSongs(song)
//        }
//    }
}
