//
//  AlbumViewModel.swift
//  Qin
//
//  Created by 林少龙 on 2020/10/7.
//

import Foundation

class AlbumDetailViewModel: Identifiable {
    var coverUrl: String = ""
    var description: String = ""
    var id: Int = 0
    var isSub: Bool = false
    var name: String = ""
    var songs = [SongViewModel]()
    
    init() {
        
    }
    
    init(_ album: Album) {
        self.coverUrl = album.picUrl
        self.description = album.description ?? ""
        self.id = album.id
        self.isSub = album.isSub ?? false
        self.name = album.name
        self.songs = album.songs.map{SongViewModel($0)}
    }
}
