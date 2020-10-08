//
//  SongViewModel.swift
//  Qin
//
//  Created by 林少龙 on 2020/8/1.
//  Copyright © 2020 teenloong. All rights reserved.
//

import Foundation

class SongViewModel: Identifiable {
    struct Artist: Identifiable {
        var id: Int = 0
        var name: String = ""
    }
    var albumPicURL = ""
    var artists = [Artist]()
    var durationTime: Int = 0
    var id: Int = 0
    var name: String = ""
    init() {
    }
    init(id: Int , name: String, artists: [Artist], albumPicURL: String = "") {
        self.albumPicURL = albumPicURL
        self.artists = artists
        self.id = id
        self.name = name
    }
    init(_ hotSong: HotSong) {
        self.albumPicURL = hotSong.album.picUrl
        self.artists = hotSong.artists.map{Artist(id: $0.id, name: $0.name)}
        self.durationTime = hotSong.duration
        self.id = hotSong.id
        self.name = hotSong.name
    }
    init(_ songDetail: SongDetail) {
        self.albumPicURL = songDetail.al.picUrl
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
