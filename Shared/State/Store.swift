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
        case .commentLike(let id, let cid, let like, let type):
            appCommand = CommentLikeCommand(id: id, cid: cid, like: like, type: type)
        case .coverShape:
            appState.settings.coverShape = appState.settings.coverShape.next()
            UserDefaults.standard.integer(forKey: "coverShape")
        case .commentMusic(let id, let limit, let offset, let beforeTime):
            appState.comment.commentRequesting = true
            appState.comment.hotComments = [CommentViewModel]()
            appState.comment.comments = [CommentViewModel]()
            appCommand = CommentMusicCommand(id: id, limit: limit, offset: offset, beforeTime: beforeTime)
        case .commentMusicDone(let result):
            switch result {
            case .success(let comments):
                appState.comment.hotComments = comments.0.map({CommentViewModel($0)})
                appState.comment.comments = comments.1.map({CommentViewModel($0)})
            case .failure(let error):
                appState.error = error
            }
            appState.comment.commentRequesting = false
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
            appState.lyric.getLyricRequesting = true
            appCommand = LyricCommand(id: id)
        case .lyricDone(result: let result):
            switch result {
            case .success(let lyric):
                appState.lyric.lyric = LyricViewModel(lyric: lyric)
                appState.lyric.lyric.setTimer(every: 0.1, offset: -1)
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
            appState.lyric.lyric.stopTimer()
        case .play:
            Player.shared.play()
            appState.lyric.lyric.setTimer(every: 0.1, offset: -1)
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
        case .playMode:
            appState.settings.playMode = appState.settings.playMode.next()
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
            appState.playlistDetail.detail = PlaylistViewModel()
            appCommand = PlaylistDeleteCommand(pid: pid)
        case .playlistDeleteDone(let result):
            switch result {
            case .success:
//                appCommand = PlaylistDeleteDoneCommand()
                break
            case .failure(let error):
                appState.error = error
            }
        case .playlistDetail(let id):
            if id != 0 {
                appState.playlistDetail.playlistDetailRequesting = true
                appState.playlistDetail.detail = PlaylistViewModel()
                appCommand = PlaylistDetailCommand(id: id)
            }else {
                appState.playlistDetail.detail = appState.playlists.recommendSongsPlaylist
            }
        case .playlistDetailDone(let result):
            switch result {
            case .success(let playlist):
                appState.playlistDetail.detail = PlaylistViewModel(playlist)
                appCommand = PlaylistDetailDoneCommand(playlistDetail: playlist)
            case .failure(let error):
                appState.error = error
                appState.playlistDetail.playlistDetailRequesting = false
            }
        case .playlistOrderUpdate(let ids, let type):
            appState.playlists.playlistOrderUpdateRequesting = true
            var allIds = [Int]()
            if type == .created {
                allIds = ids + appState.playlists.subscribePlaylists.map{$0.id}
            }
            if type == .subscribed {
                allIds = appState.playlists.subscribePlaylists.map{$0.id} + ids
            }
            appCommand = PlaylistOrderUpdateCommand(ids: allIds)
        case .playlistOrderUpdateDone(let result):
            switch result {
            case .success:
                appCommand = PlaylistOrderUpdateDoneCommand()
            case .failure(let error):
                appState.error = error
            }
            appState.playlists.playlistOrderUpdateRequesting = false
        case .playlistSubscibe(let id, let subscibe):
            appCommand = PlaylisSubscribeCommand(id: id, subcribe: subscibe)
        case .playlistSubscibeDone(let result):
            switch result {
            case .success(let subscribe):
                appState.playlistDetail.detail.subscribed = subscribe
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
            switch result {
            case .success(let recommendPlaylists):
                appState.playlists.recommendPlaylists = recommendPlaylists.map{PlaylistViewModel($0)}
                appCommand = RecommendPlaylistDoneCommand()
            case .failure(let error):
                appState.error = error
            }
        case .recommendSongs:
            appCommand = RecommendSongsCommand()
        case .recommendSongsDone(let result):
            switch result {
            case .success(let playlsit):
                appState.playlistDetail.detail = playlsit
                appState.playlists.recommendSongsPlaylist = playlsit
                appState.playlists.recommendPlaylists = [playlsit] + appState.playlists.recommendPlaylists
            case .failure(let error):
                appState.error = error
            }
            appState.playlists.recommendPlaylistRequesting = false
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
                if appState.playlistDetail.playlistDetailRequesting {
                    appState.playlistDetail.detail.tracks = songs.map{SongViewModel($0)}
                }
                if appState.search.searchRequesting {
                    appState.search.songs = songs.map{SongViewModel($0)}
                }
            //                appCommand = GetSongsDetailDone(songsDetail: songs)
            case .failure(let error):
                appState.error = error
            }
            appState.playlistDetail.playlistDetailRequesting = false
            appState.search.searchRequesting = false
            appState.playlists.songsDetailRequesting = false
        case .songsOrderUpdate(let pid, let ids):
            appCommand = SongsOrderUpdateCommand(pid: pid, ids: ids)
        case .songsOrderUpdateDone(let result):
            switch result {
            case .success:
//                appCommand = SongsOrderUpdateDoneCommand(pid: pid)
            break
            case .failure(let error):
                appState.error = error
            }
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
        case .PlayerPlayOrPause:
            appCommand = TooglePlayCommand()
        case .userPlaylist(let uid):
            appState.playlists.userPlaylistRequesting = true
            if let userId = uid {
                appCommand = UserPlayListCommand(uid: userId)
            }else if let userId = appState.settings.loginUser?.uid {
                appCommand = UserPlayListCommand(uid: userId)
            }
        case .userPlaylistDone(let uid, result: let result):
            switch result {
            case .success(let playlists):
                appState.playlists.likedPlaylistId = playlists[0].id
                appState.playlists.createdPlaylist = playlists.filter{$0.userId == uid}
                appState.playlists.subscribePlaylists = playlists.filter{$0.userId != uid}
//                appState.playlists.userPlaylists = playlists.map{PlaylistViewModel($0)}
            case .failure(let error):
                appState.error = error
            }
            appState.playlists.userPlaylistRequesting = false
        }
        return (appState, appCommand)
    }
}
