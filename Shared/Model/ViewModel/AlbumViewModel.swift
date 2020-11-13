//
//  AlbumViewModel.swift
//  Qin
//
//  Created by 林少龙 on 2020/10/7.
//

import Foundation

class AlbumViewModel: ObservableObject, Identifiable, Equatable {
    static func == (lhs: AlbumViewModel, rhs: AlbumViewModel) -> Bool {
        lhs.id == rhs.id
    }
    
    var coverUrl: String = ""
    var description: String = ""
    var id: Int64 = 0
    @Published var isSub: Bool = false
    var name: String = ""
    var songs = [SongViewModel]()
    
    init() {
        
    }
    
    init(_ album: AlbumJSONModel) {
        self.coverUrl = album.picUrl
        self.description = album.description ?? ""
        self.id = album.id
        self.isSub = album.isSub ?? false
        self.name = album.name ?? ""
    }
    init(_ album: AlbumSubJSONModel) {
        self.coverUrl = album.picUrl
        self.description = ""
        self.id = album.id
        self.name = album.name
    }
}
