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
        dispatch(.loginRefresh)
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
        case .album(let id):
            if id != appState.album.albumViewModel.id {
                appState.album.albumRequesting = true
                appCommand = AlbumCommand(id: id)
            }
        case .albumDone(let result):
            switch result {
            case .success(let album):
                appState.album.albumViewModel = album
                appState.album.albumViewModel.isSub = appState.album.albumSublist.map{$0.id}.contains(album.id)
            case .failure(let error):
                appState.error = error
            }
            appState.album.albumRequesting = false
        case .albumDetail(let id):
            if id != appState.album.albumViewModel.id {
                appState.album.albumRequesting = true
                appCommand = AlbumDetailCommand(id: id)
            }
        case .albumDetailDone(let result):
            switch result {
            case .success(let album):
                appState.album.albumViewModel = album
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
            case .success(let sublist):
                appState.album.albumSublist = sublist
            case .failure(let error):
                appState.error = error
            }
            appState.album.albumSublistRequesting = false
        case .artistAlbum(let id, let limit, let offset):
            appState.artist.artistAlbumRequesting = true
            appCommand = ArtistAlbumCommand(id: id, limit: limit, offset: offset)
        case .artistAlbumDone(let result):
            switch result {
            case .success(let albums):
                appState.artist.viewModel.albums = albums
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
                appState.artist.viewModel.mvs = mvs
            case .failure(let error):
                appState.artist.error = error
            }
            appState.artist.artistMVRequesting = false
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
            case .success(let artistSublist):
                appState.artist.artistSublist = artistSublist
            case .failure(let error):
                appState.error = error
            }
            appState.artist.artistSublistRequesting = false
        case .artists(let id):
            if id != appState.artist.viewModel.id {
                appState.artist.artistRequesting = true
                appCommand = ArtistsCommand(id: id)
            }
        case .artistsDone(let result):
            switch result {
            case .success(let artistViewModel):
                appState.artist.viewModel = artistViewModel
                appCommand = ArtistsDoneCommand(id: artistViewModel.id)
            case .failure(let error):
                appState.artist.error = error
            }
            appState.artist.artistRequesting = false
        case .artistIntroduction(let id):
            appCommand = ArtistIntroductionCommand(id: id)
        case .artistIntroductionDone(let result):
            switch result {
            case .success(let briefDesc):
                appState.artist.viewModel.description = briefDesc
            case .failure(let error):
                appState.artist.error = error
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
            UserDefaults.standard.integer(forKey: "coverShape")
        case .initAction:
            appCommand = InitAcionCommand()
        case .like(let song):
            appCommand = LikeCommand(song: song)
        case .likeDone(let song, let result):
            switch result {
            case .success(let like):
                song.liked = like
                if like {
                    appState.playlist.likedIds.append(song.id)
                }else {
                    let index = appState.playlist.likedIds.firstIndex(of: song.id)
                    appState.playlist.likedIds.remove(at: index!)
                }
//                appCommand = LikeDoneCommand()
            case .failure(let error):
                appState.error = error
            }
        case .likelist(let uid):
            appCommand = LikeListCommand(uid: uid)
        case .likelistDone(let result):
            switch result {
            case .success(let ids):
                appState.playlist.likedIds = ids
            case .failure(let error):
                appState.error = error
            }
        case .lyric(let id):
            appState.lyric.getLyricRequesting = true
            appCommand = LyricCommand(id: id)
        case .lyricDone(result: let result):
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
        case .pause:
            Player.shared.pause()
            appState.lyric.lyric?.stopTimer()
        case .play:
            Player.shared.play()
            appState.lyric.lyric?.setTimer(every: 0.1, offset: -1)
        case .playBackward:
            appCommand = PlayBackwardCommand()
        case .playForward:
            appCommand = PlayForwardCommand()
        case .playByIndex(let index):
            let song = appState.playing.playinglist[index]
            appState.playing.index = index
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
        case .playlist(let category, let hot, let limit, let offset):
            if category != appState.playlist.discoverPlaylistViewModel.subcategory || appState.playlist.discoverPlaylistViewModel.playlists.count == 0 {
                appState.playlist.discoverPlaylistViewModel.playlistRequesting = true
                appCommand = PlaylistCommand(cat: category, hot: hot, limit: limit, offset: offset)
            }
        case .playlistDone(let result):
            switch result {
            case .success(let result):
                appState.playlist.discoverPlaylistViewModel.playlists  = result.playlists
                appState.playlist.discoverPlaylistViewModel.subcategory  = result.category
                appState.playlist.discoverPlaylistViewModel.more  = result.more
                appState.playlist.discoverPlaylistViewModel.total  = result.total
            case .failure(let error):
                appState.error = error
            }
            appState.playlist.discoverPlaylistViewModel.playlistRequesting = false
        case .playlistCategories:
            appState.playlist.discoverPlaylistViewModel.categoriesRequesting = true
            appCommand = PlaylistCategoriesCommand()
        case .playlistCategoriesDone(let result):
            switch result {
            case .success(let categories):
                appState.playlist.discoverPlaylistViewModel.categories = categories
                appState.playlist.discoverPlaylistViewModel.category = categories.last?.id ?? 0
                appState.playlist.discoverPlaylistViewModel.subcategory = categories.last?.name ?? ""
            case .failure(let error):
                appState.error = error
            }
            appState.playlist.discoverPlaylistViewModel.categoriesRequesting = false
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
            appState.playlistDetail.viewModel = PlaylistViewModel()
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
            if id == 0 {
                appState.playlistDetail.viewModel = appState.playlist.recommendSongsPlaylist
            }else if id != appState.playlistDetail.viewModel.id {
                appState.playlistDetail.requesting = true
                appState.playlistDetail.viewModel = PlaylistViewModel()
                appCommand = PlaylistDetailCommand(id: id)
            }
        case .playlistDetailDone(let result):
            switch result {
            case .success(let playlist):
                appState.playlistDetail.viewModel = PlaylistViewModel(playlist)
                let ids = playlist.trackIds?.map({$0.id}) ?? [Int]()
                if ids.count > 0 {
                    appCommand = PlaylistDetailDoneCommand(ids: ids)
                }else {
                    appState.playlistDetail.requesting = false
                }
            case .failure(let error):
                appState.error = error
                appState.playlistDetail.requesting = false
            }
        case .playlistOrderUpdate(let ids, let type):
            appState.playlist.playlistOrderUpdateRequesting = true
            var allIds = [Int]()
            if type == .created {
                allIds = ids + appState.playlist.subscribePlaylists.map{$0.id}
            }
            if type == .subable {
                allIds = appState.playlist.subscribePlaylists.map{$0.id} + ids
            }
            appCommand = PlaylistOrderUpdateCommand(ids: allIds)
        case .playlistOrderUpdateDone(let result):
            switch result {
            case .success:
                appCommand = PlaylistOrderUpdateDoneCommand()
            case .failure(let error):
                appState.error = error
            }
            appState.playlist.playlistOrderUpdateRequesting = false
        case .playlistSubscibe(let id, let sub):
            appCommand = PlaylisSubscribeCommand(id: id, sub: sub)
        case .playlistSubscibeDone(let result):
            switch result {
            case .success(let subscribe):
                appState.playlistDetail.viewModel.subscribed = subscribe
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
            case .success(let recommendPlaylists):
                appState.playlist.recommendPlaylists = recommendPlaylists.map{PlaylistViewModel($0)}
                appCommand = RecommendPlaylistDoneCommand()
            case .failure(let error):
                appState.error = error
            }
        case .recommendSongs:
            appCommand = RecommendSongsCommand()
        case .recommendSongsDone(let result):
            switch result {
            case .success(let playlsit):
                appState.playlistDetail.viewModel = playlsit
                appState.playlist.recommendSongsPlaylist = playlsit
                appState.playlist.recommendPlaylists = [playlsit] + appState.playlist.recommendPlaylists
            case .failure(let error):
                appState.error = error
            }
            appState.playlist.recommendPlaylistRequesting = false
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
            appState.playlist.songsDetailRequesting = true
            appCommand = SongsDetailCommand(ids: ids)
        case .songsDetailDone(let result):
            switch result {
            case .success(let songs):
                let songsViewModel = songs.map{SongViewModel($0)}
                for song in songsViewModel {
                    song.liked = appState.playlist.likedIds.contains(song.id) ? true : false
                }
                if appState.playlistDetail.requesting {
                    appState.playlistDetail.viewModel.songs = songsViewModel
                }
                if appState.search.searchRequesting {
                    appState.search.songs = songsViewModel
                }
            //                appCommand = GetSongsDetailDone(songsDetail: songs)
            case .failure(let error):
                appState.error = error
            }
            appState.playlistDetail.requesting = false
            appState.search.searchRequesting = false
            appState.playlist.songsDetailRequesting = false
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
            appState.playlist.songsURLRequesting = true
            appCommand = SongsURLCommand(ids: ids)
        case .songsURLDone(let result):
            appState.playlist.songsURLRequesting = false
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
            appState.playlist.userPlaylistRequesting = true
            if let userId = uid {
                appCommand = UserPlayListCommand(uid: userId)
            }else if let userId = appState.settings.loginUser?.uid {
                appCommand = UserPlayListCommand(uid: userId)
            }
        case .userPlaylistDone(let uid, result: let result):
            switch result {
            case .success(let playlists):
                appState.playlist.createdPlaylist = playlists.filter{$0.userId == uid}
                appState.playlist.subscribePlaylists = playlists.filter{$0.userId != uid}
                if let likedPlaylist = appState.playlist.createdPlaylist.first {
                    appState.playlist.likedPlaylistId = likedPlaylist.id
                }
            case .failure(let error):
                appState.error = error
            }
            appState.playlist.userPlaylistRequesting = false
        }
        return (appState, appCommand)
    }
}
