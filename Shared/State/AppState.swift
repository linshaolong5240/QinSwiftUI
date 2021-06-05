//
//  AppState.swift
//  Qin
//
//  Created by 林少龙 on 2020/6/14.
//  Copyright © 2020 teenloong. All rights reserved.
//

import Foundation
import Combine

typealias User = LoginResponse

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
        enum PlayMode: Int, CaseIterable, Codable {
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
        @UserDefault(key: "coverShape") var coverShape: NEUCoverShape = .circle
        var loginRequesting = false
        @UserDefault(key: "loginUser") var loginUser: User? = nil
        @UserDefault(key: "playMode") var playMode: PlayMode = .playlist
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
        var requesting = false
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
        var likedPlaylistId: Int64 = 0
        var createdPlaylistIds = [Int64]()
        var subedPlaylistIds = [Int64]()
        var userPlaylistIds = [Int64]()
    }
    
    struct Playing {
        @UserDefault(key: "index") var index: Int = 0
        var isSeeking: Bool = false
        @UserDefault(key: "playinglist") var playinglist = [Int64]()
        var playingError: AppError?
        var song: Song? = nil
        var songUrl: String?
        var mvUrl: String?
    }
    
    struct Search {
        var keyword: String = ""
        var searchRequesting: Bool = false
        var songsId = [Int64]()
        var playlists = [PlaylistViewModel]()
    }
}

@propertyWrapper
struct UserDefault<T: Codable> {
    private let key: String
    private let defaultValue: T
    public var wrappedValue: T {
        set {
            UserDefaults.standard.set(try? JSONEncoder().encode(newValue) , forKey: key)
            UserDefaults.standard.synchronize()
        }
        get {
            guard let data = UserDefaults.standard.data(forKey: key) else { return defaultValue }
            return (try? JSONDecoder().decode(T.self, from: data)) ?? defaultValue
        }
    }
    
    init(wrappedValue: T, key: String) {
        self.key = key
        self.defaultValue = wrappedValue
    }
}

@propertyWrapper
struct UserDefaultPublisher<T: Codable> {
    private let key: String
    private let defaultValue: T
    public let projectedValue: CurrentValueSubject<T, Never>
    public var wrappedValue: T {
        set {
            UserDefaults.standard.set(try? JSONEncoder().encode(newValue) , forKey: key)
            UserDefaults.standard.synchronize()
            projectedValue.send(newValue)
        }
        get {
            guard let data = UserDefaults.standard.data(forKey: key) else { return defaultValue }
            return (try? JSONDecoder().decode(T.self, from: data)) ?? defaultValue
        }
    }
    
    init(wrappedValue: T, key: String) {
        self.key = key
        self.defaultValue = wrappedValue
        if let data = UserDefaults.standard.data(forKey: key) {
            projectedValue = .init((try? JSONDecoder().decode(T.self, from: data)) ?? wrappedValue)
        }else {
            projectedValue = .init(wrappedValue)
        }
    }
}
