//
//  QinSong.swift
//  Qin
//
//  Created by 林少龙 on 2021/12/21.
//

import Foundation

protocol QinAlbumable {
    func asQinAblbum() -> QinAlbum
}

extension Album: QinAlbumable {
    func asQinAblbum() -> QinAlbum {
        .init(coverURLString: picUrl, id: Int(id), name: name)
    }
}

protocol QinArtistable {
    func asQinArtist() -> QinArtist
}

extension Artist: QinArtistable {
    func asQinArtist() -> QinArtist {
        .init(id: Int(id), name: name)
    }
}

protocol QinSongable {
    func asQinSong() -> QinSong
}

extension Song: QinSongable {
    func asQinSong() -> QinSong {
        .init(album: album?.asQinAblbum(), artists: (artists?.allObjects as? [Artist])?.map(QinArtist.init) ?? [], id: Int(id), name: name)
    }
}

struct QinAlbum: Codable {
    var coverURLString: String?
    var id: Int
    var name: String?
}

extension QinAlbum {
    init(_ album: Album) {
        self.coverURLString = album.picUrl
        self.id = Int(album.id)
        self.name = album.name
    }
}

struct QinArtist: Codable {
    var id: Int
    var name: String?
}

extension QinArtist {
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
}

extension QinSong {
    init(_ song: Song) {
        self.album = song.album?.asQinAblbum()
        self.artists = (song.artists?.allObjects as? [Artist])?.map(QinArtist.init) ?? []
        self.id = Int(song.id)
        self.name = song.name
    }
}
