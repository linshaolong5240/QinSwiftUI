//
//  PlayListViewModel.swift
//  Qin
//
//  Created by teenloong on 2020/6/19.
//  Copyright © 2020 teenloong. All rights reserved.
//

import Foundation

struct PlaylistViewModel: Identifiable {
    var count: Int = 0
    var coverImgUrl: String? = nil
    var creator: String = ""
    var creatorId: Int = 0
    var description: String = ""
    var id: Int64 = 0
    var name: String = ""
    var playCount: Int = 0
    var subscribed: Bool = false
    var songs = [SongViewModel]()
    var songsId = [Int64]()
    var userId: Int64 = 0
    
    init() {
        
    }
}
