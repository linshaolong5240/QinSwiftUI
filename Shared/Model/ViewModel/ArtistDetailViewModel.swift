//
//  ArtistViewModel.swift
//  Qin
//
//  Created by 林少龙 on 2020/10/1.
//

import Foundation

class ArtistDetailViewModel {
    var albumSize: Int = 0
    var alias = [String]()
    var briefDesc: String = ""
    var followed: Bool = false
    var id: Int = 0
    var img1v1Url: String = ""
    var name: String = ""
    
    var albums = [AlbumViewModel]()
    var hotSongs = [SongViewModel]()
    var mvs = [MV]()
    init() {
    }
    
    init(artist: Artist, hotSongs: [SongViewModel]) {
        self.albumSize = artist.albumSize
        self.alias = artist.alias
        self.briefDesc = artist.briefDesc
        self.followed = artist.followed ?? false
        self.id = artist.id
        self.img1v1Url = artist.img1v1Url
        self.name = artist.name
        
        self.hotSongs = hotSongs
    }
}
