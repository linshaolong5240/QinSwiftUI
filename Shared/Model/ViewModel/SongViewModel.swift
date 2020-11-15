//
//  SongViewModel.swift
//  Qin
//
//  Created by 林少龙 on 2020/8/1.
//  Copyright © 2020 teenloong. All rights reserved.
//

import Foundation

struct SongViewModel: Identifiable, Equatable {
    static func == (lhs: SongViewModel, rhs: SongViewModel) -> Bool {
        lhs.id == rhs.id
    }
    struct Album {
        var id: Int64 = 0
        var name: String = ""
        var picURL: String? = nil
    }
    struct Artist {
        var id: Int64 = 0
        var name: String = ""
    }
    var album = Album()
    var artists = [Artist]()
    var durationTime: Int64 = 0
    var id: Int64 = 0
    var name: String = ""
    init() {
        
    }
    
    init(_ song: Song) {
        self.durationTime = song.durationTime
        self.id = song.id
        self.name = song.name ?? ""
    }
    
    init(_ song: SongJSONModel) {
        self.album = Album(id: song.album.id, name: song.album.name ?? "", picURL: song.album.picUrl)
        self.artists = song.artists.map{Artist(id: $0.id, name: $0.name ?? "")}
        self.durationTime = song.duration
        self.id = song.id
        self.name = song.name
    }
    
    init(_ song: SongDetailJSONModel) {
        self.album = Album(id: song.al.id, name: song.al.name ?? "", picURL: song.al.picUrl)
        self.artists = song.ar.map{Artist(id: $0.id, name: $0.name ?? "")}
        self.durationTime = song.dt / 1000
        self.id = song.id
        self.name = song.name
    }
    
//    init(_ song: SearchSongJSONModel) {
//        self.album = Album(id: song.album.id, name: song.album.name, picURL: "https://p3.music.126.net/e-uzCEle689BX0Z_-edljg==/\(song.album.picId).jpg")
//        self.artists = song.artists.map{Artist(id: $0.id, name: $0.name )}
//        self.durationTime = song.duration / 1000
//        self.id = song.id
//        self.name = song.name
//    }
}
