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
    var initRequestingCount: Int = 0
    var album = Album()
    var artist = Artist()
    var comment = Comment()
    var lyric = Lyric()
    var playing = Playing()
    var playlist = Playlists()
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
        var theme: Theme = .light
    }
    
    struct Album {
        var detailRequesting: Bool = false
        var sublistRequesting: Bool = false
        var subedIds = [Int64]()
    }
    
    struct Artist {
        var detailRequesting: Bool = false
        var albumRequesting: Bool = false
        var introductionRequesting: Bool = false
        var mvRequesting: Bool = false
        var artistSublistRequesting: Bool = false
        var subedIds = [Int64]()

        var error: AppError?
    }
    
    struct Comment {
        var commentRequesting = false
        var commentMusicRequesting = false
        var hotComments = [CommentViewModel]()
        var comments = [CommentViewModel]()
        var id: Int64 = 0
        var offset: Int = 0
        var total: Int = 0
    }
    
    struct Lyric {
        var getLyricRequesting = false
        var getlyricError: AppError?
        var lyric: LyricViewModel?
    }
    
    struct Playlists {
        //用户相关歌单
        var recommendPlaylistRequesting: Bool = false
        var userPlaylistRequesting: Bool = false

        //发现歌单
        var discoverPlaylist = DiscoverPlaylistViewModel()
        
        //歌单详情
        var detailRequesting: Bool = false
        
        //喜欢的音乐ID
        var likedIds = [Int64]()
        //喜欢的音乐歌单ID
        var likedPlaylistId: Int = 0
        var userPlaylistIds = [Int64]()
    }
    
    struct Playing {
        var index: Int {
            get {
                UserDefaults.standard.integer(forKey: "playingIndex")
            }
            set {
                UserDefaults.standard.set(newValue, forKey: "playingIndex")
            }
        }
        var isSeeking: Bool = false
        var playinglist: [Int64] {
            get {
                return UserDefaults.standard.array(forKey: "playinglist") as? [Int64] ?? [Int64]()
            }
            set {
                UserDefaults.standard.set(newValue, forKey: "playinglist")
            }
        }
        var playingError: AppError?
        var song: Song? = nil
        var songUrl: String?
    }
    
    struct Search {
        var keyword: String = ""
        var searchRequesting: Bool = false
        var songsId = [Int64]()
        var playlists = [PlaylistViewModel]()
    }
}
