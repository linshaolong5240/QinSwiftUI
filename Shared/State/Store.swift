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
        case .album(let id):
                appState.album.albumRequesting = true
                appCommand = AlbumCommand(id: id)
        case .albumDone(let result):
            switch result {
            case .success:
                break
//                appCommand = AlbumDoneCommand(ids: ids)
            case .failure(let error):
                appState.error = error
            }
            appState.album.albumRequesting = false
        case .albumSub(let id, let sub):
            appCommand = AlbumSubCommand(id: id, sub: sub)
        case .albumSubDone(let result):
            switch result {
            case .success(let sub):
                appState.album.albumViewModel.isSub = sub
                appCommand = AlbumSubDoneCommand()
            case .failure(let error):
                appState.error = error
            }
        case .albumSublist(let limit, let offset):
            appState.album.albumSublistRequesting = true
            appCommand = AlbumSublistCommand(limit: limit, offset: offset)
        case .albumSublistDone(let result):
            switch result {
            case .success:
                break
            case .failure(let error):
                appState.error = error
            }
            appState.album.albumSublistRequesting = false
            if appState.initRequestingCount > 0 {
                appState.initRequestingCount -= 1
            }
        case .artist(let id):
                appState.artist.artistRequesting = true
                appCommand = ArtistCommand(id: id)
        case .artistDone(let result):
            switch result {
            case .success(let artist):
                appCommand = ArtistDoneCommand(artist: artist)
            case .failure(let error):
                appState.artist.error = error
            }
            appState.artist.artistRequesting = false
        case .artistAlbum(let id, let limit, let offset):
            appState.artist.artistAlbumRequesting = true
            appCommand = ArtistAlbumCommand(id: id, limit: limit, offset: offset)
        case .artistAlbumDone(let result):
            switch result {
            case .success(let albums):
                appState.artist.detail.albums = albums
            case .failure(let error):
                appState.artist.error = error
            }
            appState.artist.artistAlbumRequesting = false
        case .artistMV(let id, let limit, let offset):
            appState.artist.artistMVRequesting = true
            appCommand = ArtistMVCommand(id: id, limit: limit, offset: offset)
        case .artistMVDone(let result):
            switch result {
            case .success(let mvs):
                appState.artist.detail.mvs = mvs
            case .failure(let error):
                appState.artist.error = error
            }
            appState.artist.artistMVRequesting = false
        case .artistIntroduction(let id):
            appCommand = ArtistIntroductionCommand(id: id)
        case .artistIntroductionDone(let result):
            switch result {
            case .success(let briefDesc):
                appState.artist.detail.description = briefDesc
            case .failure(let error):
                appState.artist.error = error
            }
        case .artistSub(let id, let sub):
            appCommand = ArtistSubCommand(id: id, sub: sub)
        case .artistSubDone(let result):
            switch result {
            case .success:
                appCommand = ArtistSubDoneCommand()
            case .failure(let error):
                appState.error = error
            }
        case .artistSublist(let limit, let offset):
            appState.artist.artistSublistRequesting = true
            appCommand = ArtistSublistCommand(limit: limit, offset: offset)
        case .artistSublistDone(let result):
            switch result {
            case .success:
                break
            case .failure(let error):
                appState.error = error
            }
            appState.artist.artistSublistRequesting = false
            if appState.initRequestingCount > 0 {
                appState.initRequestingCount -= 1
            }
        case .comment(let id, let cid, let content, let type, let action):
            if content.count > 0 {
                appState.comment.commentRequesting = true
                appCommand = CommentCommand(id: id, cid: cid, content: content, type: type, action: action)
            }
        case .commentDone(let result):
            switch result {
            case .success(let args):
                appCommand = CommentDoneCommand(id: args.id, type: args.type, action: args.action)
            case .failure(let error):
                appState.error = error
            }
            appState.comment.commentRequesting = false
        case .commentLike(let id, let cid, let like, let type):
            appCommand = CommentLikeCommand(id: id, cid: cid, like: like, type: type)
        case .commentMusic(let id, let limit, let offset, let beforeTime):
            appState.comment.commentMusicRequesting = true
            appState.comment.id = id
            appState.comment.offset = offset
            if offset == 0 {
                appState.comment.hotComments = [CommentViewModel]()
                appState.comment.comments = [CommentViewModel]()
            }
            appCommand = CommentMusicCommand(id: id, limit: limit, offset: offset, beforeTime: beforeTime)
        case .commentMusicDone(let result):
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
        case .initAction:
            let index = appState.playing.index
            let songId = appState.playing.playinglist[index]
            appState.playing.song = DataManager.shared.getSong(id: songId)
            appCommand = InitAcionCommand()
        case .like(let id, let like):
            appCommand = LikeCommand(id: id, like: like)
        case .likeDone(let result):
            switch result {
            case .success:
                appCommand = LikeDoneCommand()
            case .failure(let error):
                appState.error = error
            }
        case .likelist(let uid):
            if let userId = uid {
                appCommand = LikeListCommand(uid: userId)
            }else if let userId = appState.settings.loginUser?.uid {
                appCommand = LikeListCommand(uid: userId)
            }
        case .likelistDone(let result):
            switch result {
            case .success(let ids):
                appState.playlist.likedIds = ids
            case .failure(let error):
                appState.error = error
            }
            if appState.initRequestingCount > 0 {
                appState.initRequestingCount -= 1
            }
        case .lyric(let id):
            appState.lyric.getLyricRequesting = true
            appCommand = LyricCommand(id: id)
        case .lyricDone(result: let result):
            switch result {
            case .success(let lyric):
                if lyric != nil {
                    appState.lyric.lyric = LyricViewModel(lyric: lyric!)
//                    appState.lyric.lyric?.setTimer(every: 0.1, offset: -1)
                }else {
                    appState.lyric.lyric = nil
                }
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
                appCommand = LoginDoneCommand(user: user)
            case .failure(let error):
                appState.settings.loginError = error
            }
        case .loginRefresh:
            appCommand = LoginRefreshCommand()
        case .loginRefreshDone(let result):
            switch result {
            case .success(let result):
                appCommand = LoginRefreshDoneCommand(success: result)
            case .failure(let error):
                appState.error = error
            }
        case .logout:
            appState.settings.loginUser = nil
            appCommand = LogoutCommand()
        case .PlayerPause:
            Player.shared.pause()
            appState.lyric.lyric?.stopTimer()
        case .PlayerPlay:
            Player.shared.play()
            appState.lyric.lyric?.setTimer(every: 0.1, offset: -1)
        case .PlayerPlayBackward:
            appCommand = PlayerPlayBackwardCommand()
        case .PlayerPlayByIndex(let index):
            appState.playing.index = index
            let id = appState.playing.playinglist[index]
            appState.playing.song = DataManager.shared.getSong(id: id)
            appCommand = PlayerPlayRequestCommand(id: id)
        case .PlayerPlayForward:
            appCommand = PlayerPlayForwardCommand()
        case .PlayerPlayMode:
            appState.settings.playMode = appState.settings.playMode.next()
        case .PlayerPlayRequest(let id):
            appCommand = PlayerPlayRequestCommand(id: id)
        case .PlayerPlayRequestDone(let result):
            switch result {
            case .success(let songURL):
                appState.playing.songUrl = songURL.url
                if let url = songURL.url {
                    appCommand = PlayerPlayRequestDoneCommand(url: url)
                }else {
                    appCommand = PlayerPlayForwardCommand()
                    appState.error = .songsURLError
                }
            case .failure(let error):
                appState.error = error
                break
            }
        case .PlayerPlayOrPause:
            appCommand = TooglePlayCommand()
        case .PlayerPlayToendAction:
            appCommand = PlayerPlayToEndActionCommand()
        case .playerReplay:
            appCommand = RePlayCommand()
        case .PlayerSeek(let isSeeking, let time):
            appState.playing.isSeeking = isSeeking
            if isSeeking == false {
                appCommand = SeeKCommand(time: time)
            }
        case .PlayinglistInsert(let id):
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
        case .playlist(let category, let hot, let limit, let offset):
            if category != appState.playlist.discoverPlaylist.subcategory || appState.playlist.discoverPlaylist.playlists.count == 0 {
                appState.playlist.discoverPlaylist.playlistRequesting = true
                appCommand = PlaylistCommand(cat: category, hot: hot, limit: limit, offset: offset)
            }
        case .playlistDone(let result):
            switch result {
            case .success(let result):
                appState.playlist.discoverPlaylist.playlists  = result.playlists
                appState.playlist.discoverPlaylist.subcategory  = result.category
                appState.playlist.discoverPlaylist.more  = result.more
                appState.playlist.discoverPlaylist.total  = result.total
            case .failure(let error):
                appState.error = error
            }
            appState.playlist.discoverPlaylist.playlistRequesting = false
        case .playlistCategories:
            appState.playlist.discoverPlaylist.categoriesRequesting = true
            appCommand = PlaylistCategoriesCommand()
        case .playlistCategoriesDone(let result):
            switch result {
            case .success(let categories):
                appState.playlist.discoverPlaylist.categories = categories
                appState.playlist.discoverPlaylist.category = categories.last?.id ?? 0
                appState.playlist.discoverPlaylist.subcategory = categories.last?.name ?? ""
            case .failure(let error):
                appState.error = error
            }
            appState.playlist.discoverPlaylist.categoriesRequesting = false
            if appState.initRequestingCount > 0 {
                appState.initRequestingCount -= 1
            }
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
            appCommand = PlaylistDeleteCommand(pid: pid)
        case .playlistDeleteDone(let result):
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
            case .success(let playlistJSONModel):
                appCommand = PlaylistDetailDoneCommand(playlistJSONModel: playlistJSONModel)
            case .failure(let error):
                appState.error = error
            }
        case .playlistDetailSongs(let playlistJSONModel):
            appCommand = PlaylistDetailSongsCommand(playlistJSONModel: playlistJSONModel)
        case .playlistDetailSongsDone(let result):
            switch result {
            case .success:
                break
            case .failure(let error):
                appState.error = error
            }
            appState.playlist.detailRequesting = false
        case .playlistOrderUpdate:
            break
//            let allIds = [Int]()
//            if type == .created {
//                allIds = ids + appState.playlist.subscribePlaylists.map{$0.id}
//            }
//            if type == .subscribed {
//                allIds = appState.playlist.subscribePlaylists.map{$0.id} + ids
//            }
//            appCommand = PlaylistOrderUpdateCommand(ids: allIds)
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
            case .success:
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
        case .recommendSongs:
            appCommand = RecommendSongsCommand()
        case .recommendSongsDone(let result):
            switch result {
            case .success(let playlsit):
                appState.playlist.recommendSongsPlaylist = playlsit
            case .failure(let error):
                appState.error = error
            }
            if appState.initRequestingCount > 0 {
                appState.initRequestingCount -= 1
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
            if ids.count > 0 {
                appState.playlist.songsRequesting = true
                appCommand = SongsDetailCommand(ids: ids)
            }else{
                appState.album.albumRequesting = false
                appState.artist.artistRequesting = false
                appState.search.searchRequesting = false
            }
        case .songsDetailDone(let result):
            switch result {
            case .success(let songs):
                for song in songs {
                    song.liked = appState.playlist.likedIds.contains(song.id) ? true : false
                }
                if appState.album.albumRequesting {
                    appState.album.albumViewModel.songs = songs
                }
                if appState.artist.artistRequesting {
                    appState.artist.detail.hotSongs = songs
                }
                if appState.search.searchRequesting {
                    appState.search.songs = songs
                }
//                appCommand = SongsDetailDoneCommand(songs: songs)
            case .failure(let error):
                appState.error = error
            }
            appState.playlist.songsRequesting = false
            appState.album.albumRequesting = false
            appState.artist.artistRequesting = false
            appState.search.searchRequesting = false
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
            appCommand = SongsURLCommand(ids: ids)
        case .songsURLDone(let result):
            switch result {
            case .success(let songsURL):
                if appState.album.albumRequesting {
                    for url in  songsURL {
                        appState.album.albumViewModel.songs.first{$0.id == url.id}?.url = url.url
                    }
                }
                if appState.artist.artistRequesting {
                    for url in  songsURL {
                        appState.artist.detail.hotSongs.first{$0.id == url.id}?.url = url.url
                    }
                }
                if appState.search.searchRequesting {
                    for url in  songsURL {
                        appState.search.songs.first{$0.id == url.id}?.url = url.url
                    }
                }
            case .failure(let error):
                appState.error = error
            }
            appState.album.albumRequesting = false
            appState.artist.artistRequesting = false
            appState.search.searchRequesting = false
        case .userPlaylist(let uid):
            appState.playlist.userPlaylistRequesting = true
            if let userId = uid {
                appCommand = UserPlayListCommand(uid: userId)
            }else if let userId = appState.settings.loginUser?.uid {
                appCommand = UserPlayListCommand(uid: userId)
            }
        case .userPlaylistDone(let result):
            switch result {
            case .success:
                break
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
