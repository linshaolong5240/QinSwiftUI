//
//  DiscoverPlaylistViewModel.swift
//  Qin
//
//  Created by 林少龙 on 2020/10/12.
//

import SwiftUI

class DiscoverPlaylistViewModel: ObservableObject {
    var categoriesRequesting: Bool = false
    var playlistRequesting: Bool = false

    var categories = [PlaylistCategoryViewModel]()
    @Published var category: Int = 0
    var subcategory: String = ""
    var more: Bool = false
    var playlists = [PlaylistViewModel]()
    var total: Int = 0
    
    init() {
    }
    init(categories: [PlaylistCategoryViewModel], category: Int, more: Bool, playlists: [PlaylistViewModel], total: Int) {
        self.categories = categories
        self.category = category
        self.more = more
        self.playlists = playlists
        self.total = total
    }
}
