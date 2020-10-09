//
//  AlbumViewModel.swift
//  Qin
//
//  Created by 林少龙 on 2020/10/7.
//

import Foundation

class AlbumViewModel: Identifiable {
    var coverUrl: String = ""
    var description: String = ""
    var id: Int = 0
    var name: String = ""
    var songs = [SongViewModel]()
    
    init() {
        
    }
    
    init(_ album: Album) {
        self.coverUrl = album.picUrl
        self.description = album.description ?? ""
        self.id = album.id
        self.name = album.name
        self.songs = album.songs.map{SongViewModel($0)}
    }
}
