//
//  AppState.swift
//  Qin
//
//  Created by 林少龙 on 2020/6/14.
//  Copyright © 2020 teenloong. All rights reserved.
//

import Foundation
import Combine

typealias User = NCMLoginResponse

struct AppState {
    var initRequestingCount: Int = 0
    var album = Album()
    var artist = Artist()
    var cloud = Cloud()
    var comment = Comment()
    var discoverPlaylist = DiscoverPlaylist()
    var lrc = Lyric()
    var playing = Playing()
    var playlist = Playlist()
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
        @CombineUserStorge(key: .playerCoverShape, container: .standard) var coverShape: QinCoverShape = .circle
        var loginRequesting = false
        @CombineUserStorge(key: .loginUser, container: .standard) var loginUser: User? = nil
        @CombineUserStorge(key: .playerPlayingMode, container: .standard) var playMode: PlayMode = .playlist
        var theme: Theme = .light
    }
    
    struct Album {
        var detailRequesting: Bool = false
        var sublistRequesting: Bool = false

        var albumSublist = [NCMAlbumSublistResponse.Album]()
        var subedIds: [Int] { albumSublist.map(\.id) }
    }
    
    struct Artist {
        var detailRequesting: Bool = false
        var albumRequesting: Bool = false
        var introductionRequesting: Bool = false
        var mvRequesting: Bool = false
        var artistSublistRequesting: Bool = false
        var artistSublist = [NCMArtistSublistResponse.Artist]()
        var subedIds: [Int] { artistSublist.map(\.id) }

        var error: AppError?
    }
    
    struct Cloud {
        var fileURL: URL? = nil
        var md5: String = ""
        var token: CloudUploadTokenResponse.Result? = nil
        var needUpload: Bool = false
        var songId: String = ""
    }
    
    struct Comment {
        var commentRequesting = false
        var commentMusicRequesting = false
        var hotComments = [NCMCommentSongResponse.Comment]()
        var comments = [NCMCommentSongResponse.Comment]()
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
        var isRequesting = false
        var id: Int = 0
        var lyric: String = ""
    }
    
    struct Playlist {
        //用户相关歌单
        var recommendPlaylist = [NCMRecommendPlaylistResponse.RecommendPlaylist]()
        var recommendPlaylistRequesting: Bool = false
        var recommendSongsRequesting = false
        var userPlaylistRequesting: Bool = false
        //歌单详情
        var detailRequesting: Bool = false
        
        //喜欢的音乐ID
        @CombineUserStorge(key: .likedSongsId, container: .standard)
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
        @CombineUserStorge(key: .playerPlayingIndex, container: .standard)
        var index: Int = 0
        var isSeeking: Bool = false
        @CombineUserStorge(key: .playerPlaylist, container: .standard)
        var playinglist:[QinSong] = []
        var playingError: AppError?
        @CombineUserStorge(key: .playerSong, container: .standard)
        var song: QinSong? = nil
        var songUrl: String?
        var mvUrl: String?
    }
}
