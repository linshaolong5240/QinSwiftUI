//
//  Store.swift
//  Qin
//
//  Created by 林少龙 on 2020/6/14.
//  Copyright © 2020 teenloong. All rights reserved.
//

import Foundation
import Combine

class Store: ObservableObject {
    static let shared = Store()
    
    @Published var appState = AppState()
    
    init() {
        #if os(macOS)
        dispatch(.initAction)
        #else
        dispatch(.initAction)
        #endif
    }
    
    func dispatch(_ action: AppAction) {
        #if DEBUG
        print("[ACTION]: \(action)")
        #endif
        let result = reduce(state: appState, action: action)
        appState = result.0
        if let appCommand = result.1 {
            print("[COMMAND]: \(appCommand)")
            appCommand.execute(in: self)
        }
    }
    
    func reduce(state: AppState, action: AppAction) -> (AppState, AppCommand?) {
        var appState = state
        var appCommand: AppCommand? = nil
        
        switch action {
        case .commentMusic(let id, let limit, let offset, let beforeTime):
            appState.playing.commentRequesting = true
            appState.playing.hotComments = [CommentViewModel]()
            appState.playing.comments = [CommentViewModel]()
            appCommand = CommentMusicCommand(id: id, limit: limit, offset: offset, beforeTime: beforeTime)
        case .commentMusicDone(let result):
            switch result {
            case .success(let comments):
                appState.playing.hotComments = comments.0.map({CommentViewModel($0)})
                appState.playing.comments = comments.1.map({CommentViewModel($0)})
            case .failure(let error):
                appState.error = error
            }
            appState.playing.commentRequesting = false
        case .initAction:
            appCommand = InitAcionCommand()
        case .like(let id, let like):
            appCommand = LikeCommand(id: id, like: like)
        case .likeDone(let result):
            switch result {
            case .success(let like):
                appState.playing.like = like
                appCommand = LikeDoneCommand()
            case .failure(let error):
                appState.error = error
            }
        case .likelist(let uid):
            appCommand = LikeListCommand(uid: uid)
        case .likelistDone(let result):
            switch result {
            case .success(let ids):
                appState.playlists.likeIds = ids
            case .failure(let error):
                appState.error = error
            }
        case .lyric(let id):
            if appState.lyric.lyrics[id] == nil {
                appState.lyric.getLyricRequesting = true
                appCommand = LyricCommand(id: id)
            }
        case .lyricDone(let id, result: let result):
            switch result {
            case .success(let lyric):
                //                appState.playing.lyric = lyric
                appState.lyric.lyric[id] = lyric
                appState.lyric.lyricParser = LyricParser(lyric)
//                appState.lyric.lyrics[id] = parseLyric(lyric)
            //                appState.lyric.lyric = parseLyric(lyric)
            case .failure(let error):
                appState.lyric.getlyricError = error
            }
            appState.lyric.getLyricRequesting = false
        case .login(let email, let password):
            appState.settings.loginRequesting = true
            appCommand = LoginCommand(email: email, password: password)
        case .loginDone(result: let result):
            appState.settings.loginRequesting = false
            switch result {
            case .success(let user):
                appState.settings.loginUser = user
                appCommand = LoginDoneCommand()
            case .failure(let error):
                appState.settings.loginError = error
            }
        case .showLoginView(let show):
            appState.settings.showLoginView = show
        case .logout:
            appState.settings.loginUser = nil
            appCommand = LogoutCommand()
        case .pause:
            Player.shared.pause()
        case .play:
            Player.shared.play()
        case .playBackward:
            appCommand = PlayBackwardCommand()
        case .playForward:
            appCommand = PlayForwardCommand()
        case .playByIndex(let index):
            let song = appState.playing.playinglist[index]
            appState.playing.index = index
            appState.playing.like =  appState.playlists.likeIds.contains(song.id)
            appState.playing.songDetail = song
            appCommand = PlayRequestCommand(id: song.id)
        case .playModeToggle:
            if appState.settings.playMode == .playlist {
                appState.settings.playMode = .relplay
            }else {
                appState.settings.playMode = .playlist
            }
        case .playRequest(let id):
            appCommand = PlayRequestCommand(id: id)
        case .playRequestDone(let result):
            switch result {
            case .success(let songURL):
                appState.playing.songUrl = songURL.url
                if let url = songURL.url {
                    appCommand = PlayRequestDoneCommand(url: url)
                }else {
                    appCommand = PlayForwardCommand()
                    appState.error = .songsURLError
                }
            case .failure(let error):
                appState.error = error
                break
            }
        case .playToendAction:
            appCommand = PlayToEndActionCommand()
        case .replay:
            appCommand = RePlayCommand()
        case .playlistCreate(let name, let privacy):
            appCommand = PlaylistCreateCommand(name: name, privacy: privacy)
        case .playlistCreateDone(let result):
            switch result {
            case .success:
                //                appState.playlists.userPlaylists.append(PlaylistViewModel(playlist))
                appCommand = PlaylistCreateDoneCommand()
            case .failure(let error):
                appState.error = error
            }
        case .playlistDelete(let pid):
            appState.playlists.playlistDetail = PlaylistViewModel()
            appCommand = PlaylistDeleteCommand(pid: pid)
        case .playlistDeleteDone(let result):
            switch result {
            case .success:
                appCommand = PlaylistDeleteDoneCommand()
            case .failure(let error):
                appState.error = error
            }
        case .playlistDetail(let id):
            appState.playlists.playlistDetailRequesting = true
            appState.playlists.playlistDetail = PlaylistViewModel()
            appCommand = PlaylistDetailCommand(id: id)
        case .playlistDetailDone(let result):
            switch result {
            case .success(let playlist):
                appState.playlists.playlistDetail = PlaylistViewModel(playlist)
                appCommand = PlaylistDetailDoneCommand(playlistDetail: playlist)
            case .failure(let error):
                appState.error = error
                appState.playlists.playlistDetailRequesting = false
            }
        case .playlistSubscibe(let id, let subscibe):
            appCommand = PlaylisSubscribeCommand(id: id, subcribe: subscibe)
        case .playlistSubscibeDone(let result):
            switch result {
            case .success(let subscribe):
                appState.playlists.playlistDetail.subscribed = subscribe
                appCommand = PlaylisSubscribeDoneCommand()
            case .failure(let error):
                appState.error = error
            }
        case .playlistTracks(let pid, let op, let ids):
            appCommand = PlaylistTracksCommand(pid: pid, op: op, ids: ids)
        case .playlistTracksDone(let result):
            switch result {
            case .success:
                appCommand = PlaylistTracksDoneCommand()
            case .failure(let error):
                appState.error = error
            }
            
        case .recommendPlaylist:
            appState.playlists.recommendPlaylistRequesting = true
            appCommand = RecommendPlaylistCommand()
        case .recommendPlaylistDone(let result):
            appState.playlists.recommendPlaylistRequesting = false
            switch result {
            case .success(let recommendPlaylists):
                appState.playlists.recommendPlaylists = recommendPlaylists.map{PlaylistViewModel($0)}
            case .failure(let error):
                appState.error = error
            }
        case .search(let keyword, let type, let limit, let offset):
            appState.search.searchRequesting = true
            appCommand = SearchCommand(keyword: keyword, type: type, limit: limit, offset: offset)
        case .searchClean:
            appState.search.songs = [SongViewModel]()
            appState.search.playlists = [PlaylistViewModel]()
        case .searchPlaylistDone(let result):
            switch result {
            case .success(let playlists):
                appState.search.playlists = playlists
            case .failure(let error):
                appState.error = error
            }
            appState.search.searchRequesting = false
        case .searchSongDone(let result):
            switch result {
            case .success(let songs):
                appState.search.songs = songs.map{SongViewModel($0)}
                appCommand = SearchSongDoneCommand()
            case .failure(let error):
                appState.error = error
                appState.search.searchRequesting = false
            }
        case .songsDetail(let ids):
            appState.playlists.songsDetailRequesting = true
            appCommand = SongsDetailCommand(ids: ids)
        case .songsDetailDone(let result):
            switch result {
            case .success(let songs):
                if appState.playlists.playlistDetailRequesting {
                    appState.playlists.playlistDetail.tracks = songs.map{SongViewModel($0)}
                }
                if appState.search.searchRequesting {
                    appState.search.songs = songs.map{SongViewModel($0)}
                }
            //                appCommand = GetSongsDetailDone(songsDetail: songs)
            case .failure(let error):
                appState.error = error
            }
            appState.playlists.playlistDetailRequesting = false
            appState.search.searchRequesting = false
            appState.playlists.songsDetailRequesting = false
        case .songsURL(let ids):
            appState.playlists.songsURLRequesting = true
            appCommand = SongsURLCommand(ids: ids)
        case .songsURLDone(let result):
            appState.playlists.songsURLRequesting = false
            switch result {
            case .success:
                break
            case .failure(let error):
                appState.error = error
            }
        case .seek(let isSeeking):
            appState.playing.isSeeking = isSeeking
            if isSeeking == false {
                appCommand = SeeKCommand()
            }
            break
        case .setPlayinglist(let playlist, let index):
            appState.playing.playinglist = playlist
            appState.playing.index = index
        case .togglePlay:
            appCommand = TooglePlayCommand()
        case .showPlaylistDetail:
            appState.playlists.showPlaylistDetail.toggle()
        case .userPlaylist(let uid):
            appState.playlists.playlistDetailRequesting = true
            appCommand = UserPlayListCommand(uid: uid)
        case .userPlaylistDone(result: let result):
            switch result {
            case .success(let playlists):
                appState.playlists.likedPlaylistId = playlists[0].id
                appState.playlists.userPlaylists = playlists.map{PlaylistViewModel($0)}
            case .failure(let error):
                appState.error = error
            }
            appState.playlists.playlistDetailRequesting = false
        }
        return (appState, appCommand)
    }
}
