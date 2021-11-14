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
    var cloud = Cloud()
    var comment = Comment()
    var discoverPlaylist = DiscoverPlaylist()
    var lyric = Lyric()
    var playing = Playing()
    var playlist = Playlist()
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
        @UserDefault(key: "coverShape") var coverShape: QinCoverShape = .circle
        var loginRequesting = false
        @UserDefault(key: "loginUser") var loginUser: User? = nil
        @UserDefault(key: "playMode") var playMode: PlayMode = .playlist
        var theme: Theme = .light
    }
    
    struct Album {
        var detailRequesting: Bool = false
        var sublistRequesting: Bool = false

        var albumSublist = [AlbumSublistResponse.Album]()
        var subedIds: [Int] { albumSublist.map(\.id) }
    }
    
    struct Artist {
        var detailRequesting: Bool = false
        var albumRequesting: Bool = false
        var introductionRequesting: Bool = false
        var mvRequesting: Bool = false
        var artistSublistRequesting: Bool = false
        var artistSublist = [ArtistSublistResponse.Artist]()
        var subedIds: [Int] { artistSublist.map(\.id) }

        var error: AppError?
    }
    
    struct Cloud {
        @UserDefault(key: "fileURL") var fileURL: URL? = nil
        @UserDefault(key: "md5") var md5: String = ""
        @UserDefault(key: "token") var token: CloudUploadTokenResponse.Result? = nil
        var needUpload: Bool = false
        var songId: String = ""
    }
    
    struct Comment {
        var commentRequesting = false
        var commentMusicRequesting = false
        var hotComments = [CommentSongResponse.Comment]()
        var comments = [CommentSongResponse.Comment]()
        var id: Int = 0
        var limit: Int = 0
        var offset: Int = 0
        var befortime: Int = 0
        var total: Int = 0
    }
    
    struct DiscoverPlaylist {
        var requesting = false
        var catalogue = [PlaylistCatalogue]()
    }
    
    struct Lyric {
        var requesting = false
        var getlyricError: AppError?
        var lyric: LyricViewModel?
    }
    
    struct Playlist {
        //用户相关歌单
        var recommendPlaylist = [RecommendPlaylistResponse.RecommendPlaylist]()
        var recommendPlaylistRequesting: Bool = false
        var recommendSongsRequesting = false
        var userPlaylistRequesting: Bool = false
        //歌单详情
        var detailRequesting: Bool = false
        
        //喜欢的音乐ID
        var songlikedIds = [Int]()
        //喜欢的音乐歌单ID
        var likedPlaylistId: Int = 0
        var createdPlaylistIds = [Int]()
        var subedPlaylistIds = [Int]()
        var userPlaylistIds = [Int]()
        var userPlaylist = [PlaylistResponse]()
        var createdPlaylist: [PlaylistResponse] { userPlaylist.filter({createdPlaylistIds.contains($0.id)}) }
    }
    
    struct Playing {
        @UserDefault(key: "index") var index: Int = 0
        var isSeeking: Bool = false
        @UserDefault(key: "playinglist") var playinglist = [Int]()
        var playingError: AppError?
        var song: Song? = nil
        var songUrl: String?
        var mvUrl: String?
    }
    
    struct Search {
        struct Result {
            var playlists = [SearchPlaylistResponse.Result.Playlist]()
            var songs = [SearchSongResponse.Result.Song]()
        }
        var keyword: String = ""
        var searchRequesting: Bool = false
        var songsId = [Int]()
        var result = Result()
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
