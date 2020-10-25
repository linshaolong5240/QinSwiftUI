//
//  SongViewModel.swift
//  Qin
//
//  Created by 林少龙 on 2020/8/1.
//  Copyright © 2020 teenloong. All rights reserved.
//

import Foundation

class SongViewModel: ObservableObject, Identifiable, Equatable, Codable {
    static func == (lhs: SongViewModel, rhs: SongViewModel) -> Bool {
        lhs.id == rhs.id
    }
    
    struct Artist: Identifiable, Codable {
        var id: Int = 0
        var name: String = ""
    }
    var albumPicURL = ""
    var artists = [Artist]()
    var durationTime: Int = 0
    var id: Int = 0
    @Published var liked: Bool = false
    var name: String = ""
    var url: String? = nil
    init() {
    }
    init(id: Int , name: String, artists: [Artist], albumPicURL: String = "") {
        self.albumPicURL = albumPicURL
        self.artists = artists
        self.id = id
        self.name = name
    }
    init(_ song: Song) {
        self.albumPicURL = song.album.picUrl
        self.artists = song.artists.map{Artist(id: $0.id, name: $0.name)}
        self.durationTime = song.duration
        self.id = song.id
        self.name = song.name
    }
    init(_ songDetail: SongDetail) {
        self.albumPicURL = songDetail.al.picUrl ?? ""
        self.artists = songDetail.ar.map{Artist(id: $0.id, name: $0.name ?? "None")}
        self.durationTime = songDetail.dt / 1000
        self.id = songDetail.id
        self.name = songDetail.name
    }
    init(_ searchSongDetail: SearchSongDetail) {
        self.artists = searchSongDetail.artists.map{Artist(id: $0.id, name: $0.name)}
        self.durationTime = searchSongDetail.duration / 1000
        self.id = searchSongDetail.id
        self.name = searchSongDetail.name
    }
}
