//
//  AlbumViewModel.swift
//  Qin
//
//  Created by 林少龙 on 2020/10/7.
//

import Foundation

class AlbumViewModel: Identifiable {
    var id: Int = 0
    var name: String = ""
    var picUrl: String = ""

    init(_ album: Album) {
        self.id = album.id
        self.name = album.name
        self.picUrl = album.picUrl
    }
}
