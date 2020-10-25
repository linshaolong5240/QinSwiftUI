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
    var albumPicURL = ""
    var artists = [ArtistViewModel]()
    var durationTime: Int = 0
    var id: Int = 0
    @Published var liked: Bool = false
    var name: String = ""
    var url: String? = nil
    init() {
    }
    init(_ song: Song) {
        self.albumPicURL = song.album.picUrl
        self.artists = song.artists.map(ArtistViewModel.init)
        self.durationTime = song.duration
        self.id = song.id
        self.name = song.name
    }
    init(_ songDetail: SongDetail) {
        self.albumPicURL = songDetail.al.picUrl ?? ""
        self.artists = songDetail.ar.map(ArtistViewModel.init)
        self.durationTime = songDetail.dt / 1000
        self.id = songDetail.id
        self.name = songDetail.name
    }
    init(_ searchSongDetail: SearchSongDetail) {
        self.artists = searchSongDetail.artists.map(ArtistViewModel.init)
        self.durationTime = searchSongDetail.duration / 1000
        self.id = searchSongDetail.id
        self.name = searchSongDetail.name
    }
}
