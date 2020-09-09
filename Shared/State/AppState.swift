//
//  AppState.swift
//  Qin
//
//  Created by 林少龙 on 2020/6/14.
//  Copyright © 2020 teenloong. All rights reserved.
//

import Foundation
import AVFoundation
import Combine
import CoreData

struct AppState {
    var lyric = Lyric()
    var playlists = Playlists()
    var playing = Playing()
    var search = Search()
    var settings = Settings()
    var error: AppError?
}

extension AppState {
    struct Settings {
        enum AccountBehavior: CaseIterable {
            case login, logout
        }
        enum PlayMode {
            case playlist, relplay
        }
        enum Theme: CaseIterable {
            case dark, light, system
        }
        var accountBehavior = AccountBehavior.login
        var loginRequesting = false
        var loginUser: User? = DataManager.shared.getUser()
        var loginError: AppError?
        var playMode: PlayMode = .playlist
        var showLoginView = false
        var theme: Theme = .light
    }
    
    struct Playlists {
        var createdPlaylist = [PlaylistViewModel]()
        var likeIds = [Int]()
        var likedPlaylistId: Int = 0
        var playlistDetail = PlaylistViewModel()
        var playlistDetailRequesting: Bool = false
        var playlistOrderUpdateRequesting: Bool = false
        var recommendPlaylistRequesting: Bool = false
        var recommendPlaylists = [PlaylistViewModel]()
        var songsDetailRequesting: Bool = false
        var songsURLRequesting: Bool = false
        var subscribePlaylists = [PlaylistViewModel]()
//        var userPlaylists = [PlaylistViewModel]()
    }
    
    struct Playing {
        var commentRequesting = false
        var hotComments = [CommentViewModel]()
        var comments = [CommentViewModel]()
        
        var index: Int = 0
        var like: Bool = false
        var isSeeking: Bool = false
        
        var playinglist = [SongViewModel]()//PlaylistViewModel()
        var playingError: AppError?
        var lyric: String = ""
        var songDetail = SongViewModel()
        var songUrl: String?
        
        var loadTime: Double = 0
        var seekTime: Double = 0
        var totalTime: Double = 0
        var loadPercent: Double = 0
        var loadTimelabel: String = "00:00"
        var totalTimeLabel: String = "00:00"
    }
    
    struct Lyric {
        var getLyricRequesting = false
        var getlyricError: AppError?
        var lyric = Dictionary<Int, String>()
        var lyricParser = LyricParser()
        var lyrics = Dictionary<Int, Dictionary<Int, String>>()
    }
    struct Search {
        var keyword: String = ""
        var searchRequesting: Bool = false
        var songs = [SongViewModel]()
        var playlists = [PlaylistViewModel]()
    }
}
