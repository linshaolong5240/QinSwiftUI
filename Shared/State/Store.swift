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
        case .albumDetailRequest(let id):
                appState.album.detailRequesting = true
            appCommand = AlbumDetailRequestCommand(id: id)
        case .albumDetailRequestDone(let result):
            switch result {
            case .success: break
            case .failure(let error):
                appState.error = error
            }
            appState.album.detailRequesting = false
        case .albumSubRequest(let id, let sub):
            appCommand = AlbumSubRequestCommand(id: id, sub: sub)
        case .albumSubRequestDone(let result):
            switch result {
            case .success:
                appCommand = AlbumSubRequestDoneCommand()
            case .failure(let error):
                appState.error = error
            }
        case .albumSublistRequest(let limit, let offset):
            appState.album.sublistRequesting = true
            appCommand = AlbumSublistRequestCommand(limit: limit, offset: offset)
        case .albumSublistRequestDone(let result):
            switch result {
            case .success(let albumSublistResponse):
                appState.album.albumSublist = albumSublistResponse.data
            case .failure(let error):
                appState.error = error
            }
            appState.album.sublistRequesting = false
            if appState.initRequestingCount > 0 {
                appState.initRequestingCount -= 1
            }
        case .artistAlbumsRequest(let id, let limit, let offset):
            appState.artist.albumRequesting = true
            appCommand = ArtistAlbumsRequestCommand(id: id, limit: limit, offset: offset)
        case .artistAlbumsRequestDone(let result):
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
        case .artistDetailRequest(let id):
            appState.artist.detailRequesting = true
            appCommand = ArtistDetailRequestCommand(id: Int(id))
        case .artistDetailRequestDone(let result):
            switch result {
            case .success: break
            case .failure(let error):
                appState.artist.error = error
            }
            appState.artist.detailRequesting = false
        case .artistMVsRequest(let id, let limit, let offset, let total):
            appState.artist.mvRequesting = true
            appCommand = ArtistMVsRequestCommand(id: id, limit: limit, offset: offset, total: total)
        case .artistMVsRequestDone(let result):
            switch result {
            case .success: break
            case .failure(let error):
                appState.artist.error = error
            }
            appState.artist.mvRequesting = false
            if !appState.artist.albumRequesting && !appState.artist.introductionRequesting && !appState.artist.mvRequesting {
                appState.artist.detailRequesting = false
            }
        case .artistSubRequest(let id, let sub):
            appCommand = ArtistSubRequestCommand(id: id, sub: sub)
        case .artistSubRequestDone(let result):
            switch result {
            case .success:
                appCommand = ArtistSubRequestDoneCommand()
            case .failure(let error):
                appState.error = error
            }
        case .artistSublistRequest(let limit, let offset):
            appState.artist.artistSublistRequesting = true
            appCommand = ArtistSublistRequestCommand(limit: limit, offset: offset)
        case .artistSublistRequestDone(let result):
            switch result {
            case .success(let artistSublistResponse):
                appState.artist.artistSublist = artistSublistResponse.data
            case .failure(let error):
                appState.error = error
            }
            appState.artist.artistSublistRequesting = false
            if appState.initRequestingCount > 0 {
                appState.initRequestingCount -= 1
            }
        case .cloudSongAddRequst(let songId):
            appCommand = CloudSongAddRequstCommand(id: songId)
        case .cloudSongAddRequstDone(let result):
            switch result {
            case .success(let response):
                break
            case .failure(let error):
                appState.error = error
            }
        case .cloudUploadCheckRequest(let fileURL):
            appState.cloud.fileURL = fileURL
            appCommand = CloudUploadCheckRequestCommand(fileURL: fileURL)
        case .cloudUploadCheckRequestDone(let result):
            switch  result {
            case .success(let data):
                appState.cloud.needUpload = data.response.needUpload
                appState.cloud.songId = data.response.songId
                appState.cloud.md5 = data.md5
                if let url = appState.cloud.fileURL {
                    appCommand = CloudUploadCheckRequestDoneCommand(fileURL: url, md5: data.md5)
                }
            case .failure(let error):
                appState.error = error
            }
        case .cloudUploadInfoRequest(let info):
            appCommand = CloudUploadInfoRequestCommand(info: info)
        case .cloudUploadInfoRequestDone(let result):
            switch result {
            case .success(let response):
                appCommand = CloudUploadInfoRequestDoneCommand(info: response)
            case .failure(let error):
                appState.error = error
            }
        case .cloudUploadSongRequest(let token, let md5, let size, let data):
            appCommand = CloudUploadCommand(token: token, fileSize: size, md5: md5, data: data)
        case .cloudUploadTokenRequest(let fileURL, let md5):
            appCommand = CloudUploadTokenRequestCommand(fileURL: fileURL, md5: md5)
        case .cloudUploadTokenRequestDone(let result):
            switch result {
            case .success(let token):
                appState.cloud.token = token
                if let url = appState.cloud.fileURL {
                    appCommand = CloudUploadTokenDoneCommand(fileURL: url, token: token, md5: appState.cloud.md5)
                }
            case .failure(let error):
                appState.error = error
            }
        case .commentRequest(let id, let cid, let content, let type, let action):
            if content != nil || action == .delete {
                appState.comment.commentRequesting = true
                appCommand = CommentRequestCommand(id: id, commentId: cid, content: content, type: type, action: action)
            }
        case .commentDoneRequest(let result):
            switch result {
            case .success(let args):
                appCommand = CommentRequestDoneCommand(id: args.id, type: args.type, action: args.action)
            case .failure(let error):
                appState.error = error
            }
            appState.comment.commentRequesting = false
        case .commentLikeRequest(let id, let cid, let like, let type):
            appCommand = CommentLikeRequestCommand(id: id, cid: cid, like: like, type: type)
        case .commentLikeDone(let result):
            switch result {
            case .success:
                break
            case .failure(let error):
                appState.error = error
            }
        case .commentMusicRequest(let rid, let limit, let offset, let beforeTime):
            if rid != 0 {
                appState.comment.commentMusicRequesting = true
                appState.comment.id = rid
                appState.comment.limit = limit
                appState.comment.offset = offset
                appState.comment.befortime = beforeTime
                appState.comment.hotComments = .init()
                appState.comment.comments = .init()
                appState.comment.total = 0
                appCommand = CommentMusicRequestCommand(rid: rid, limit: limit, offset: offset, beforeTime: beforeTime)
            }
        case .commentMusicRequestDone(let result):
            switch result {
            case .success(let commentSongResponse):
                if let hotComments = commentSongResponse.hotComments {
                    appState.comment.hotComments = hotComments
                }
                appState.comment.comments = commentSongResponse.comments
//                appState.comment.hotComments.append(contentsOf: result.0.map({CommentViewModel($0)}))
//                appState.comment.comments.append(contentsOf: result.1.map({CommentViewModel($0)}))
                appState.comment.total = commentSongResponse.total
            case .failure(let error):
                appState.error = error
            }
            appState.comment.commentMusicRequesting = false
        case .commentMusicLoadMoreRequest:
            appState.comment.offset += 1
            let id = appState.comment.id
            let limit = appState.comment.limit
            let offset = appState.comment.offset
            let beforetime = appState.comment.befortime
            appCommand = CommentMusicRequestCommand(rid: id, limit: limit, offset: offset, beforeTime: beforetime)
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
        case .mvURLRequest(let id):
            appCommand = MVUrlCommand(id: id)
        case .playerPause:
            AudioSessionManager.shared.active()
            Player.shared.pause()
            appState.lyric.lyric?.stopTimer()
        case .playerPlay:
            AudioSessionManager.shared.deactive()
            Player.shared.play()
            appState.lyric.lyric?.setTimer(every: 0.1, offset: -1)
        case .playerPlayBackward:
            appCommand = PlayerPlayBackwardCommand()
        case .playerPlayBy(let index):
            appState.playing.index = index
            let id = appState.playing.playinglist[index]
            appState.playing.song = DataManager.shared.getSong(id: Int(id))
            appCommand = PlayerPlayRequestCommand(id: Int(id))
        case .playerPlayForward:
            appCommand = PlayerPlayForwardCommand()
        case .playerPlayMode:
            appState.settings.playMode = appState.settings.playMode.next()
        case .playerPlayRequest(let id):
            appCommand = PlayerPlayRequestCommand(id: id)
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
            appCommand = PlaylistCategoriesRequestCommand()
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
                appCommand = PlaylistCreateRequestDoneCommand()
            case .failure(let error):
                appState.error = error
            }
        case .playlistDeleteRequest(let pid):
            appCommand = PlaylistDeleteRequestCommand(pid: pid)
        case .playlistDeleteRequestDone(let result):
            switch result {
            case .success:
                appCommand = PlaylistDeleteReuquestDoneCommand()
                break
            case .failure(let error):
                appState.error = error
            }
        case .playlistDetailRequest(let id):
            appState.playlist.detailRequesting = true
            appCommand = PlaylistDetailRequestCommand(id: id)
        case .playlistDetailRequestDone(let result):
            switch result {
            case .success(let playlist):
                appCommand = PlaylistDetailDoneCommand(playlist: playlist)
            case .failure(let error):
                appState.error = error
            }
        case .playlistDetailSongsRequest(let playlist):
            appCommand = PlaylistDetailSongsRequestCommand(playlist: playlist)
        case .playlistDetailSongsRequestDone(let result):
            switch result {
            case .success: break
            case .failure(let error):
                appState.error = error
            }
            appState.playlist.detailRequesting = false
        case .playlistOrderUpdateRequesting(let ids):
            appCommand = PlaylistOrderUpdateRequestCommand(ids: ids)
        case .playlistOrderUpdateDone(let result):
            switch result {
            case .success:
                appCommand = PlaylistOrderUpdateRequestDoneCommand()
            case .failure(let error):
                appState.error = error
            }
        case .playlistSubscibeRequest(let id, let sub):
            appCommand = PlaylisSubscribeRequestCommand(id: id, sub: sub)
        case .playlistSubscibeRequestDone(let result):
            switch result {
            case .success:
                appCommand = PlaylisSubscribeRequestDoneCommand()
            case .failure(let error):
                appState.error = error
            }
        case .playlistTracksRequest(let pid, let ids, let op):
            if ids.count > 0 {
                appCommand = PlaylistTracksRequestCommand(pid: pid, ids: ids, op: op)
            }
        case .playlistTracksRequestDone(let result):
            switch result {
            case .success(let id):
                appCommand = PlaylistTracksRequestDoneCommand(id: id)
            case .failure(let error):
                appState.error = error
            }
        case .recommendPlaylistRequest:
            appState.playlist.recommendPlaylistRequesting = true
            appCommand = RecommendPlaylistRequestCommand()
        case .recommendPlaylistRequestDone(let result):
            switch result {
            case .success(let recommandPlaylistResponse):
                appState.playlist.recommendPlaylist = recommandPlaylistResponse.recommend
            case .failure(let error):
                appState.error = error
            }
            appState.playlist.recommendPlaylistRequesting = false
            if appState.initRequestingCount > 0 {
                appState.initRequestingCount -= 1
            }
        case .recommendSongsRequest:
            appState.playlist.recommendSongsRequesting = true
            appCommand = RecommendSongsRequestCommand()
        case .recommendSongsRequestDone(let result):
            switch result {
            case .success: break
            case .failure(let error):
                appState.error = error
            }
            appState.playlist.recommendSongsRequesting = false
            if appState.initRequestingCount > 0 {
                appState.initRequestingCount -= 1
            }
        case .searchRequest(let keyword, let type, let limit, let offset):
            if keyword.count > 0 {
                appState.search.searchRequesting = true
                appCommand = SearchRequestCommand(keyword: keyword, type: type, limit: limit, offset: offset)
            }
        case .searchPlaylistRequestDone(let result):
            switch result {
            case .success(let searchPlaylistResponse):
                appState.search.result.playlists = searchPlaylistResponse.result.playlists
            case .failure(let error):
                appState.error = error
            }
            appState.search.searchRequesting = false
        case .searchSongRequestDone(let result):
            switch result {
            case .success(let ids):
                appState.search.songsId = ids
                appCommand = SearchSongDoneCommand(ids: ids)
            case .failure(let error):
                appState.error = error
            }
            appState.search.searchRequesting = false
        case .songsDetailRequest(let ids):
            appCommand = SongsDetailCommand(ids: ids)
        case .songsDetailRequestDone(let result):
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
                appState.playlist.songlikedIds = ids
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
        case .songsOrderUpdateRequesting(let pid, let ids):
            appCommand = SongsOrderUpdateRequestCommand(pid: pid, ids: ids)
        case .songsOrderUpdateRequestDone(let result):
            switch result {
            case .success(let id):
                appCommand = SongsOrderUpdateRequestingDoneCommand(id: id)
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
        case .userCloudRequest:
            appCommand = UserCloudRequestCommand()
        case .userPlaylistRequest(let uid, let limit, let offset):
            appState.playlist.userPlaylistRequesting = true
            if let userId = uid {
                appCommand = UserPlayListRequestCommand(uid: userId, limit: limit, offset: offset)
            }else if let userId = appState.settings.loginUser?.profile.userId {
                appCommand = UserPlayListRequestCommand(uid: userId, limit: limit, offset: offset)
            }
        case .userPlaylistRequestDone(let result):
            switch result {
            case .success(let playlists):
                if let uid = appState.settings.loginUser?.userId {
                    appState.playlist.createdPlaylistIds = playlists.filter { $0.userId == uid }.map(\.id)
                    appState.playlist.subedPlaylistIds =  playlists.filter { $0.userId != uid }.map(\.id)
                    appState.playlist.userPlaylistIds =  playlists.map(\.id)
                    
                    appState.playlist.userPlaylist = playlists
                }

                if let id = playlists.first?.id {
                    appState.playlist.likedPlaylistId = id
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
