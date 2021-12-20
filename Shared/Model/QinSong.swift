//
//  QinSong.swift
//  Qin
//
//  Created by 林少龙 on 2021/12/21.
//

import Foundation

struct QinAlbum: Codable {
    var coverURLString: String?
    var id: Int
    var name: String?
    
    init(_ album: Album) {
        self.coverURLString = album.picUrl
        self.id = Int(album.id)
        self.name = album.name
    }
}

struct QinArtist: Codable {
    var id: Int
    var name: String?
    init(_ artist: Artist) {
        self.id = Int(artist.id)
        self.name = artist.name
    }
}

struct QinSong: Codable {
    var album: QinAlbum?
    var artists: [QinArtist]
    var id: Int
    var name: String?
    
    init(_ song: Song) {
        self.album = song.album == nil ? nil : .init(song.album!)
        self.artists = (song.artists?.allObjects as? [Artist])?.map(QinArtist.init) ?? []
        self.id = Int(song.id)
        self.name = song.name
    }
}
