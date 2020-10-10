//
//  ArtistViewModel.swift
//  Qin
//
//  Created by 林少龙 on 2020/10/1.
//

import Foundation

class ArtistViewModel: ObservableObject, Identifiable {
    var albumSize: Int = 0
    var alias = [String]()
    var coverUrl: String = ""
    var description: String = ""
    @Published var followed: Bool = false
    var id: Int = 0
    var name: String = ""
    
    var albums = [AlbumDetailViewModel]()
    var hotSongs = [SongViewModel]()
    var mvs = [MV]()
    
    init() {
    }
    
    init(artist: Artist, hotSongs: [SongViewModel]) {
        self.albumSize = artist.albumSize
        self.alias = artist.alias
        self.coverUrl = artist.img1v1Url
        self.description = artist.briefDesc
        self.followed = artist.followed ?? false
        self.id = artist.id
        self.name = artist.name
        
        self.hotSongs = hotSongs
    }
    init(_ artistSublist: ArtistSub) {
        self.coverUrl = artistSublist.img1v1Url ?? ""
        self.id = artistSublist.id
        self.name = artistSublist.name
    }
}
