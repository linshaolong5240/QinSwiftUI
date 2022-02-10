//
//  QinSong.swift
//  Qin
//
//  Created by teenloong on 2021/12/21.
//

import Foundation
import NeteaseCloudMusicAPI

protocol QinAlbumable {
    func asQinAblbum() -> QinAlbum
}

protocol QinArtistable {
    func asQinArtist() -> QinArtist
}

protocol QinSongable {
    func asQinSong() -> QinSong
}

struct QinAlbum: Codable, Identifiable, Equatable {
    var coverURLString: String?
    var id: Int
    var name: String?
}

extension QinAlbum {
    init<Album>(_ album: Album) where Album: QinAlbumable {
        self = album.asQinAblbum()
    }
}

struct QinArtist: Codable, Identifiable, Equatable {
    var id: Int
    var name: String?
}

extension QinArtist {
    init<Artist>(_ artist: Artist) where Artist: QinArtistable {
        self = artist.asQinArtist()
    }
}

struct QinSong: Codable, Identifiable, Equatable {
    var album: QinAlbum?
    var artists: [QinArtist]
    var id: Int
    var name: String?
}

extension QinSong {
    init<Song>(_ song: Song) where Song: QinSongable {
        self = song.asQinSong()
    }
}

extension QinSong: QinSongable {
    func asQinSong() -> QinSong {
        self
    }
}

extension Album: QinAlbumable {
    func asQinAblbum() -> QinAlbum {
        .init(coverURLString: picUrl, id: Int(id), name: name)
    }
}

extension Artist: QinArtistable {
    func asQinArtist() -> QinArtist {
        .init(id: Int(id), name: name)
    }
}

extension Song: QinSongable {
    func asQinSong() -> QinSong {
        .init(album: album?.asQinAblbum(), artists: (artists?.allObjects as? [Artist])?.map(QinArtist.init) ?? [], id: Int(id), name: name)
    }
}

extension NCMSearchSongResponse.Result.Song.Album: QinAlbumable {
    func asQinAblbum() -> QinAlbum {
        .init(coverURLString: nil, id: id, name: name)
    }
}

extension NCMSearchSongResponse.Result.Song.Artist: QinArtistable {
    func asQinArtist() -> QinArtist {
        .init(id: id, name: name)
    }
}

extension NCMSearchSongResponse.Result.Song: QinSongable {
    func asQinSong() -> QinSong {
        .init(album: album.asQinAblbum(), artists: self.artists.map({ $0.asQinArtist() }), id: id, name: name)
    }
}

