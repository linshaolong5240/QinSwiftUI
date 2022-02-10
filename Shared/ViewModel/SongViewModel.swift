//
//  SongViewModel.swift
//  Qin
//
//  Created by teenloong on 2020/8/1.
//  Copyright © 2020 teenloong. All rights reserved.
//

import Foundation

struct SongViewModel: Identifiable, Equatable {
    static func == (lhs: SongViewModel, rhs: SongViewModel) -> Bool {
        lhs.id == rhs.id
    }
    struct SongAlbum {
        var id: Int64 = 0
        var name: String = ""
        var picURL: String? = nil
    }
    struct SongArtist: Identifiable {
        var id: Int64 = 0
        var name: String = ""
    }
    var album = SongAlbum()
    var artists = [SongArtist]()
    var durationTime: Int64 = 0
    var id: Int64 = 0
    var name: String = ""
    init() {
        
    }
    
    init(_ song: Song) {
        if let al = song.album {
            self.album = SongAlbum(id: al.id , name: al.name ?? "", picURL: al.picUrl)
        }
        if let ar = song.artists as? Set<Artist> {
            self.artists = ar.map{ SongArtist(id: $0.id, name: $0.name ?? "") }
        }
        self.durationTime = song.durationTime
        self.id = song.id
        self.name = song.name ?? ""
    }
}
