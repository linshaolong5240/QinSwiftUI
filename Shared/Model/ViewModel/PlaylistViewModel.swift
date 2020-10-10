//
//  PlayListViewModel.swift
//  Qin
//
//  Created by 林少龙 on 2020/6/19.
//  Copyright © 2020 teenloong. All rights reserved.
//

import Foundation
enum PlaylistType: Int, Codable {
    case created, recommendSongs, subable
}

class PlaylistViewModel: Identifiable {
    var count: Int = 0
    var coverImgUrl: String = ""
    var creator: String = ""
    var creatorId: Int = 0
    var description: String = ""
    var id: Int = 0
    var name: String = ""
    var playCount: Int = 0
    var subscribed: Bool = false
    var songIds = [Int]()
    var songs = [SongViewModel]()
    var userId: Int = 0
    init() {
        
    }
    init(_ playList: Playlist) {
        self.count = playList.trackCount
        self.coverImgUrl = playList.coverImgUrl
        self.creator = playList.creator.nickname
        self.description = playList.description ?? ""
        self.id = playList.id
        self.name = playList.name
        self.playCount = playList.playCount
        self.subscribed = playList.subscribed
        self.songIds = playList.trackIds?.map({$0.id}) ?? [Int]()
        self.songs = playList.tracks?.map{ SongViewModel($0) } ?? [SongViewModel]()
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
    init(_ recommendSongs: RecommendSongsPlaylist) {
        self.count = recommendSongs.dailySongs.count
//        self.description = recommendSongs.recommendReasons.map{$0.reason}.joined(separator: "\n")
        self.description = "它聪明、熟悉每个用户的喜好，从海量音乐中挑选出你可能喜欢的音乐。\n它通过你每一次操作来记录你的口味"
        self.name = "每日歌曲推荐"
        self.songs = recommendSongs.dailySongs.map{SongViewModel($0)}
    }
    init(_ searchPlaylist: SearchPlaylist) {
        self.count = searchPlaylist.trackCount
        self.coverImgUrl = searchPlaylist.coverImgUrl
        self.creator = searchPlaylist.creator.nickname
        self.description = searchPlaylist.description ?? ""
        self.id = searchPlaylist.id
        self.name = searchPlaylist.name
        self.playCount = searchPlaylist.playCount
        self.userId = searchPlaylist.userId
    }
}
