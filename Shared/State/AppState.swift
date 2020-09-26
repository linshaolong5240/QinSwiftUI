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
    var comment = Comment()
    var lyric = Lyric()
    var playing = Playing()
    var playlists = Playlists()
    var playlistDetail = PlaylistDetail()
    var search = Search()
    var settings = Settings()
    var error: AppError?
}

extension AppState {
    struct Settings {
        enum AccountBehavior: CaseIterable {
            case login, logout
        }
        enum PlayMode: Int, CaseIterable {
            case playlist = 0, relplay
            var systemName: String {
                switch self {
                case .playlist:
                    return "repeat"
                case .relplay:
                    return "repeat.1"
                }
            }
        }
        enum Theme: CaseIterable {
            case dark, light, system
        }
        var accountBehavior = AccountBehavior.login
        var coverShape: NEUCoverShape {
            get {
                NEUCoverShape(rawValue: UserDefaults.standard.integer(forKey: "coverShape"))!
            }
            set {
                UserDefaults.standard.set(newValue.rawValue, forKey: "coverShape")
            }
        }
        var loginRequesting = false
        var loginUser: User? = DataManager.shared.getUser()
        var loginError: AppError?
        var playMode: PlayMode {
            get {
                PlayMode(rawValue: UserDefaults.standard.integer(forKey: "playMode"))!
            }
            set {
                UserDefaults.standard.set(newValue.rawValue, forKey: "playMode")
            }
        }
        var showLoginView = false
        var theme: Theme = .light
    }
    struct Comment {
        var commentRequesting = false
        var hotComments = [CommentViewModel]()
        var comments = [CommentViewModel]()
    }
    struct PlaylistDetail {
        var detail = PlaylistViewModel()
        var playlistDetailRequesting: Bool = false
    }
    
    struct Playlists {
        var createdPlaylist = [PlaylistViewModel]()
        var likeIds = Array<Int>()//[Int]()
        var likedPlaylistId: Int = 0
//        var playlistDetail = PlaylistViewModel()
//        var playlistDetailRequesting: Bool = false
        var playlistOrderUpdateRequesting: Bool = false
        var recommendPlaylistRequesting: Bool = false
        var recommendPlaylists = [PlaylistViewModel]()
        var recommendSongsPlaylist = PlaylistViewModel()
        var songsDetailRequesting: Bool = false
        var songsURLRequesting: Bool = false
        var subscribePlaylists = [PlaylistViewModel]()
        var userPlaylistRequesting: Bool = false
    }
    
    struct Playing {
        var index: Int = 0
        var like: Bool = false
        var isSeeking: Bool = false
        
        var playinglist = [SongViewModel]()//PlaylistViewModel()
        var playingError: AppError?
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
        var lyric = LyricViewModel(lyric: "")
    }
    
    struct Search {
        var keyword: String = ""
        var searchRequesting: Bool = false
        var songs = [SongViewModel]()
        var playlists = [PlaylistViewModel]()
    }
}
