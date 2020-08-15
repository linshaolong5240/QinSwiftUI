//
//  SongViewModel.swift
//  Qin
//
//  Created by 林少龙 on 2020/8/1.
//  Copyright © 2020 teenloong. All rights reserved.
//

import Foundation

class SongViewModel: Codable, Identifiable {
    var albumPicURL = ""
    var artists: String = ""
    var id: Int = 0
    var name: String = ""
    init() {
    }
    init(id: Int , name: String, artists: String, albumPicURL: String = "") {
        self.albumPicURL = albumPicURL
        self.artists = artists
        self.id = id
        self.name = name
    }
    init(_ songDetail: SongDetail) {
        self.albumPicURL = songDetail.al.picUrl
        self.artists = songDetail.artists
        self.id = songDetail.id
        self.name = songDetail.name
    }
    init(_ searchSongDetail: SearchSongDetail) {
        self.artists = searchSongDetail.artists.map{ $0.name }.joined(separator: " & ")
        self.id = searchSongDetail.id
        self.name = searchSongDetail.name
    }
}
