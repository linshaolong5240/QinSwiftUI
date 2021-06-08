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
    public static let shared = Store()
    
    var cancellableSet = Set<AnyCancellable>()

    @Published var appState = AppState()
    func dispatch(_ action: AppAction) {
        #if DEBUG
        print("[ACTION]: \(action)")
        #endif
        let result = reduce(state: appState, action: action)
        appState = result.0
        if let appCommand = result.1 {
            #if DEBUG
            print("[COMMAND]: \(appCommand)")
            #endif
            appCommand.execute(in: self)
        }
    }
    
    func reduce(state: AppState, action: AppAction) -> (AppState, AppCommand?) {
        var appState = state
        var appCommand: AppCommand? = nil
        
        switch action {
        case .albumRequest(let id):
                appState.album.detailRequesting = true
            appCommand = AlbumRequestCommand(id: Int(id))
        case .albumRequestDone(let result):
            switch result {
            case .success:
                break
//                appCommand = AlbumDoneCommand(ids: ids)
            case .failure(let error):
                appState.error = error
            }
            appState.album.detailRequesting = false
        case .albumSubRequest(let id, let sub):
            appCommand = AlbumSubRequestCommand(id: Int(id), sub: sub)
        case .albumSubRequestDone(let result):
            switch result {
            case .success:
                appCommand = AlbumSubDoneCommand()
            case .failure(let error):
                appState.error = error
            }
        case .albumSublistRequest(let limit, let offset):
            appState.album.sublistRequesting = true
            appCommand = AlbumSublistRequestCommand(limit: limit, offset: offset)
        case .albumSublistRequestDone(let result):
            switch result {
            case .success(let ids):
                appState.album.subedIds = ids
            case .failure(let error):
                appState.error = error
            }
            appState.album.sublistRequesting = false
            if appState.initRequestingCount > 0 {
                appState.initRequestingCount -= 1
            }
        case .artistRequest(let id):
            appState.artist.detailRequesting = true
            appCommand = ArtistRequestCommand(id: Int(id))
        case .artistRequestDone(let result):
            switch result {
            case .success: break
            case .failure(let error):
                appState.artist.error = error
            }
            appState.artist.detailRequesting = false
        case .artistAlbumRequest(let id, let limit, let offset):
            appState.artist.albumRequesting = true
            appCommand = ArtistAlbumsRequestCommand(id: Int(id), limit: limit, offset: offset)
        case .artistAlbumRequestDone(let result):
            switch result {
            case .success:
                break
            case .failure(let error):
                appState.artist.error = error
            }
            appState.artist.albumRequesting = false
            if !appState.artist.albumRequesting && !appState.artist.introductionRequesting && !appState.artist.mvRequesting {
                appState.artist.detailRequesting = false
            }
        case .artistMvRequest(let id, let limit, let offset, let total):
            appState.artist.mvRequesting = true
            appCommand = ArtistMVCommand(id: id, limit: limit, offset: offset, total: total)
        case .artistMvRequestDone(let result):
            switch result {
            case .success:
                break
            case .failure(let error):
                appState.artist.error = error
            }
            appState.artist.mvRequesting = false
            if !appState.artist.albumRequesting && !appState.artist.introductionRequesting && !appState.artist.mvRequesting {
                appState.artist.detailRequesting = false
            }
        case .artistSubRequest(let id, let sub):
            appCommand = ArtistSubCommand(id: id, sub: sub)
        case .artistSubRequestDone(let result):
            switch result {
            case .success:
                appCommand = ArtistSubDoneCommand()
            case .failure(let error):
                appState.error = error
            }
        case .artistSublistRequest(let limit, let offset):
            appState.artist.artistSublistRequesting = true
            appCommand = ArtistSublistRequestCommand(limit: limit, offset: offset)
        case .artistSublistRequestDone(let result):
            switch result {
            case .success(let ids):
                appState.artist.subedIds = ids
            case .failure(let error):
                appState.error = error
            }
            appState.artist.artistSublistRequesting = false
            if appState.initRequestingCount > 0 {
                appState.initRequestingCount -= 1
            }
        case .commentRequest(let id, let cid, let content, let type, let action):
            if content.count > 0 {
                appState.comment.commentRequesting = true
                appCommand = CommentCommand(id: id, cid: cid, content: content, type: type, action: action)
            }
        case .commentDoneRequest(let result):
            switch result {
            case .success(let args):
                appCommand = CommentDoneCommand(id: args.id, type: args.type, action: args.action)
            case .failure(let error):
                appState.error = error
            }
            appState.comment.commentRequesting = false
        case .commentLikeRequest(let id, let cid, let like, let type):
            appCommand = CommentLikeCommand(id: id, cid: cid, like: like, type: type)
        case .commentMusicRequest(let id, let limit, let offset, let beforeTime):
            if id != 0 {
                appState.comment.commentMusicRequesting = true
                appState.comment.id = id
                appState.comment.offset = offset
                appState.comment.hotComments = [CommentViewModel]()
                appState.comment.comments = [CommentViewModel]()
                appState.comment.total = 0
                appCommand = CommentMusicCommand(id: id, limit: limit, offset: offset, beforeTime: beforeTime)
            }
        case .commentMusicRequestDone(let result):
            switch result {
            case .success(let result):
                appState.comment.hotComments.append(contentsOf: result.0.map({CommentViewModel($0)}))
                appState.comment.comments.append(contentsOf: result.1.map({CommentViewModel($0)}))
                appState.comment.total = result.2
            case .failure(let error):
                appState.error = error
            }
            appState.comment.commentMusicRequesting = false
        case .commentMusicLoadMore:
            appState.comment.offset += 1
            let id = appState.comment.id
            let offset = appState.comment.offset
            appCommand = CommentMusicCommand(id: id, offset: offset)
        case .coverShape:
            appState.settings.coverShape = appState.settings.coverShape.next()
        case .error(let error):
            appState.error = error
        case .initAction:
            if appState.playing.playinglist.count > 0 {
                let index = appState.playing.index
                let songId = appState.playing.playinglist[index]
                appState.playing.song = DataManager.shared.getSong(id: Int(songId))
            }
            appCommand = InitAcionCommand()
        case .loginRequest(let email, let password):
            appState.settings.loginRequesting = true
            appCommand = LoginRequestCommand(email: email, password: password)
        case .loginRequestDone(result: let result):
            appState.settings.loginRequesting = false
            switch result {
            case .success(let user):
                appState.settings.loginUser = user
                appCommand = LoginRequestDoneCommand(user: user)
            case .failure(let error):
                appState.error = error
            }
        case .loginRefreshRequest:
            appCommand = LoginRefreshRequestCommand()
        case .loginRefreshRequestDone(let result):
            switch result {
            case .success(let result):
                appCommand = LoginRefreshDoneCommand(success: result)
            case .failure(let error):
                appState.error = error
            }
        case .logoutRequest:
            appCommand = LogoutRequestCommand()
        case .logoutRequestDone:
            appState.settings.loginUser = nil
        case .mvDetailRequest(id: let id):
            appCommand = MVDetailRequestCommand(id: id)
        case .mvDetaillRequestDone(let result):
            switch result {
            case .success(_):
                break
            case .failure(let error):
                appState.error = error
            }
        case .mvUrl(let id):
            appCommand = MVUrlCommand(id: id)
        case .playerPause:
            Player.shared.pause()
            appState.lyric.lyric?.stopTimer()
        case .playerPlay:
            Player.shared.play()
            appState.lyric.lyric?.setTimer(every: 0.1, offset: -1)
        case .playerPlayBackward:
            appCommand = PlayerPlayBackwardCommand()
        case .playerPlayByIndex(let index):
            appState.playing.index = index
            let id = appState.playing.playinglist[index]
            appState.playing.song = DataManager.shared.getSong(id: Int(id))
            appCommand = PlayerPlayRequestCommand(id: Int(id))
        case .playerPlayForward:
            appCommand = PlayerPlayForwardCommand()
        case .playerPlayMode:
            appState.settings.playMode = appState.settings.playMode.next()
        case .playerPlayRequest(let id):
            appCommand = PlayerPlayRequestCommand(id: Int(id))
        case .playerPlayRequestDone(let result):
            switch result {
            case .success(let songURL):
                appState.playing.songUrl = songURL
                if let url = songURL {
                    appCommand = PlayerPlayRequestDoneCommand(url: url)
                }else {
                    appCommand = PlayerPlayForwardCommand()
                    appState.error = AppError.songsURLError
                }
            case .failure(let error):
                appState.error = error
                break
            }
        case .playerPlayOrPause:
            if appState.playing.song != nil {
                appCommand = TooglePlayCommand()
            }
        case .PlayerPlayToendAction:
            appCommand = PlayerPlayToEndActionCommand()
        case .playerReplay:
            appCommand = RePlayCommand()
        case .playerSeek(let isSeeking, let time):
            appState.playing.isSeeking = isSeeking
            if isSeeking == false {
                appCommand = SeeKCommand(time: time)
            }
        case .playinglistInsert(let id):
            var index: Int = 0
            if appState.playing.playinglist.count > 0 {
                if let i = appState.playing.playinglist.firstIndex(of: id) {
                    index = i
                }else {
                    index = appState.playing.index + 1
                    appState.playing.playinglist.insert(id, at: index)
                }
            }else {
                appState.playing.playinglist.append(id)
                index = 0
            }
            appCommand = PlayinglistInsertCommand(index: index)
        case .PlayinglistSet(let playlist, let index):
            appState.playing.playinglist = playlist
            appState.playing.index = index
        case .playlistCatalogueRequest:
            appState.discoverPlaylist.requesting = true
            appCommand = PlaylistCategoriesCommand()
        case .playlistCatalogueRequestsDone(let result):
            switch result {
            case .success(let catalogue):
                appState.discoverPlaylist.catalogue = catalogue
            case .failure(let error):
                appState.error = error
            }
            appState.discoverPlaylist.requesting = false
            if appState.initRequestingCount > 0 {
                appState.initRequestingCount -= 1
            }
        case .playlistCreateRequest(let name, let privacy):
            appCommand = PlaylistCreateRequestCommand(name: name, privacy: privacy)
        case .playlistCreateRequestDone(let result):
            switch result {
            case .success:
                appCommand = PlaylistCreateDoneCommand()
            case .failure(let error):
                appState.error = error
            }
        case .playlistDelete(let pid):
            appCommand = PlaylistDeleteRequestCommand(pid: pid)
        case .playlistDeleteRequestDone(let result):
            switch result {
            case .success:
                appCommand = PlaylistDeleteDoneCommand()
                break
            case .failure(let error):
                appState.error = error
            }
        case .playlistDetail(let id):
            appState.playlist.detailRequesting = true
            appCommand = PlaylistDetailCommand(id: id)
        case .playlistDetailDone(let result):
            switch result {
            case .success(let playlist):
                appCommand = PlaylistDetailDoneCommand(playlist: playlist)
            case .failure(let error):
                appState.error = error
            }
        case .playlistDetailSongs(let playlist):
            appCommand = PlaylistDetailSongsCommand(playlist: playlist)
        case .playlistDetailSongsDone(let result):
            switch result {
            case .success: break
            case .failure(let error):
                appState.error = error
            }
            appState.playlist.detailRequesting = false
        case .playlistOrderUpdate(let ids):
            appCommand = PlaylistOrderUpdateCommand(ids: ids)
        case .playlistOrderUpdateDone(let result):
            switch result {
            case .success:
                appCommand = PlaylistOrderUpdateDoneCommand()
            case .failure(let error):
                appState.error = error
            }
        case .playlistSubscibe(let id, let sub):
            appCommand = PlaylisSubscribeCommand(id: id, sub: sub)
        case .playlistSubscibeDone(let result):
            switch result {
            case .success(let id):
                appCommand = PlaylisSubscribeDoneCommand(id: id)
            case .failure(let error):
                appState.error = error
            }
        case .playlistTracks(let pid, let op, let ids):
            if ids.count > 0 {
                appCommand = PlaylistTracksCommand(pid: pid, op: op, ids: ids)
            }
        case .playlistTracksDone(let result):
            switch result {
            case .success(let id):
                appCommand = PlaylistTracksDoneCommand(id: id)
            case .failure(let error):
                appState.error = error
            }
        case .recommendPlaylistRequest:
            appState.playlist.recommendPlaylistRequesting = true
            appCommand = RecommendPlaylistCommand()
        case .recommendPlaylistDone(let result):
            switch result {
            case .success:
                break
//                appCommand = RecommendPlaylistDoneCommand()
            case .failure(let error):
                appState.error = error
            }
            appState.playlist.recommendPlaylistRequesting = false
            if appState.initRequestingCount > 0 {
                appState.initRequestingCount -= 1
            }
        case .recommendSongsRequest:
            appState.playlist.detailRequesting = true
            appCommand = RecommendSongsCommand()
        case .recommendSongsDone(let result):
            switch result {
            case .success:
                break
            case .failure(let error):
                appState.error = error
            }
            appState.playlist.detailRequesting = false
            if appState.initRequestingCount > 0 {
                appState.initRequestingCount -= 1
            }
        case .search(let keyword, let type, let limit, let offset):
            appState.search.searchRequesting = true
            appCommand = SearchCommand(keyword: keyword, type: type, limit: limit, offset: offset)
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
            case .success(let ids):
                appState.search.songsId = ids
                appCommand = SearchSongDoneCommand(ids: ids)
            case .failure(let error):
                appState.error = error
            }
            appState.search.searchRequesting = false
        case .songsDetail(let ids):
            appCommand = SongsDetailCommand(ids: ids)
        case .songsDetailDone(let result):
            switch result {
            case .success: break
            case .failure(let error):
                appState.error = error
            }
        case .songLikeRequest(let id, let like):
            appCommand = SongLikeRequestCommand(id: id, like: like)
        case .songLikeRequestDone(let result):
            switch result {
            case .success:
                appCommand = SongLikeRequestDoneCommand()
            case .failure(let error):
                appState.error = error
            }
        case .songLikeListRequest(let uid):
            if let userId = uid {
                appCommand = SongLikeListRequestCommand(uid: userId)
            }else if let userId = appState.settings.loginUser?.profile.userId {
                appCommand = SongLikeListRequestCommand(uid: userId)
            }
        case .songLikeListRequestDone(let result):
            switch result {
            case .success(let ids):
                appState.playlist.likedIds = ids.map({ Int64($0) })
            case .failure(let error):
                appState.error = error
            }
            if appState.initRequestingCount > 0 {
                appState.initRequestingCount -= 1
            }
        case .songLyricRequest(let id):
            appState.lyric.requesting = true
            appCommand = SongLyricRequestCommand(id: id)
        case .songLyricRequestDone(result: let result):
            switch result {
            case .success(let lyric):
                if lyric != nil {
                    appState.lyric.lyric = LyricViewModel(lyric: lyric!)
                    appState.lyric.lyric?.setTimer(every: 0.1, offset: -1)
                }else {
                    appState.lyric.lyric = nil
                }
            case .failure(let error):
                appState.lyric.getlyricError = error
            }
            appState.lyric.requesting = false
        case .songsOrderUpdate(let pid, let ids):
            appCommand = SongsOrderUpdateCommand(pid: pid, ids: ids)
        case .songsOrderUpdateDone(let result):
            switch result {
            case .success(let id):
                appCommand = SongsOrderUpdateDoneCommand(id: id)
            break
            case .failure(let error):
                appState.error = error
            }
        case .songsURLRequest(let ids):
            appCommand = SongsURLRequestCommand(ids: ids)
        case .songsURLRequestDone(let result):
            switch result {
            case .success:
                break
            case .failure(let error):
                appState.error = error
            }
        case .userPlaylistRequest(let uid, let limit, let offset):
            appState.playlist.userPlaylistRequesting = true
            if let userId = uid {
                appCommand = UserPlayListCommand(uid: userId, limit: limit, offset: offset)
            }else if let userId = appState.settings.loginUser?.profile.userId {
                appCommand = UserPlayListCommand(uid: userId, limit: limit, offset: offset)
            }
        case .userPlaylistDone(let result):
            switch result {
            case .success(let playlists):
                if let uid = appState.settings.loginUser?.userId {
                    appState.playlist.createdPlaylistIds = playlists.filter { $0.userId == uid }.map { Int64($0.id) }
                    appState.playlist.subedPlaylistIds =  playlists.filter { $0.userId != uid }.map { Int64($0.id) }
                    appState.playlist.userPlaylistIds =  playlists.map { Int64($0.id) }
                    
                    appState.playlist.userPlaylist = playlists
                }

                if let id = playlists.first?.id {
                    appState.playlist.likedPlaylistId = Int64(id)
                }
            case .failure(let error):
                appState.error = error
            }
            appState.playlist.userPlaylistRequesting = false
            if appState.initRequestingCount > 0 {
                appState.initRequestingCount -= 1
            }
        }
        return (appState, appCommand)
    }
}
