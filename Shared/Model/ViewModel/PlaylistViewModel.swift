//
//  PlayListViewModel.swift
//  Qin
//
//  Created by 林少龙 on 2020/6/19.
//  Copyright © 2020 teenloong. All rights reserved.
//

import Foundation
enum PlaylistType: Int, Codable {
    case created, subscribed, other
}

class PlaylistViewModel: Codable, Identifiable {
    var count: Int = 0
    var coverImgUrl: String = ""
    var creator: String = ""
    var creatorId: Int = 0
    var description: String?
    var id: Int = 0
    var name: String = ""
    var playCount: Int = 0
    var playlistType: PlaylistType = .other
    var subscribed: Bool = false
    var trackIds = [Int]()
    var tracks = [SongViewModel]()
    var userId: Int = 0
    init() {
        
    }
    init(_ playList: Playlist) {
        self.count = playList.trackCount
        self.coverImgUrl = playList.coverImgUrl
        self.creator = playList.creator.nickname
        self.description = playList.description
        self.id = playList.id
        self.name = playList.name
        self.playCount = playList.playCount
        self.subscribed = playList.subscribed
        self.trackIds = playList.trackIds?.map({$0.id}) ?? [Int]()
        self.tracks = playList.tracks?.map{ SongViewModel($0) } ?? [SongViewModel]()
        self.userId = playList.userId
    }
    init(_ recommendPlaylist: RecommendPlaylist) {
        self.count = recommendPlaylist.trackCount
        self.coverImgUrl = recommendPlaylist.picUrl
        self.creator = recommendPlaylist.creator.nickname
        self.description = ""
        self.id = recommendPlaylist.id
        self.name = recommendPlaylist.name
        self.playCount = recommendPlaylist.playcount
        self.userId = recommendPlaylist.userId
    }
    init(_ searchPlaylist: SearchPlaylist) {
        self.count = searchPlaylist.trackCount
        self.coverImgUrl = searchPlaylist.coverImgUrl
        self.creator = searchPlaylist.creator.nickname
        self.description = searchPlaylist.description
        self.id = searchPlaylist.id
        self.name = searchPlaylist.name
        self.playCount = searchPlaylist.playCount
        self.userId = searchPlaylist.userId
    }
}
