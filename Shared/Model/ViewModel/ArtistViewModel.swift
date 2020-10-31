//
//  ArtistViewModel.swift
//  Qin
//
//  Created by 林少龙 on 2020/10/1.
//

import Foundation

class ArtistViewModel: ObservableObject, Identifiable, Codable {
    var albumSize: Int = 0
    var alias = [String]()
    var coverUrl: String = ""
    var description: String = ""
    @Published var followed: Bool = false
    var id: Int64 = 0
    var name: String = ""
    
    var albums = [AlbumViewModel]()
    var hotSongs = [SongViewModel]()
    var mvs = [MV]()
    
    init() {
    }
    init(_ artist: ArtistJSONModel) {
        self.albumSize = artist.albumSize
        self.alias = artist.alias
        self.coverUrl = artist.img1v1Url
        self.description = artist.briefDesc
        self.followed = artist.followed ?? false
        self.id = artist.id
        self.name = artist.name ?? ""
    }
    
    init(_ artist: ArtistSubJSONModel) {
        self.coverUrl = artist.img1v1Url ?? ""
        self.id = artist.id
        self.name = artist.name
    }
    init(_ artist: SongDetailJSONModel.Artist) {
        self.id = artist.id
        self.name = artist.name ?? ""
    }
}
