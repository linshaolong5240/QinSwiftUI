//
//  AppCommand.swift
//  Qin
//
//  Created by 林少龙 on 2020/6/17.
//  Copyright © 2020 teenloong. All rights reserved.
//

import Foundation

protocol AppCommand {
    func execute(in store: Store)
}

struct ArtistAlbumCommand: AppCommand {
    let id: Int
    let limit: Int
    let offset: Int
    
    init(id: Int, limit: Int = 30, offset: Int = 0) {
        self.id = id
        self.limit = limit
        self.offset = offset
    }
    func execute(in store: Store) {
        NeteaseCloudMusicApi.shared.artistAlbum(id: id, limit: limit, offset: offset) { (data, error) in
            guard error == nil else {
                store.dispatch(.artistAlbumDone(result: .failure(error!)))
                return
            }
            if data?["code"] as? Int == 200 {
                let albumsDict = data!["hotAlbums"] as! [NeteaseCloudMusicApi.ResponseData]
                let albums = albumsDict.map{$0.toData!.toModel(Album.self)!}
                let albumsViewModel = albums.map{ AlbumViewModel($0) }
                store.dispatch(.artistAlbumDone(result: .success(albumsViewModel)))
            }else {
                let code = data?["code"] as? Int ?? -1
                let message = data?["message"] as? String ?? "错误信息解码错误"
                store.dispatch(.artistAlbumDone(result: .failure(.artistAlbum(code: code, message: message))))
            }
        }
    }
}

struct ArtistMVCommand: AppCommand {
    let id: Int
    let limit: Int
    let offset: Int
    
    init(id: Int, limit: Int = 30, offset: Int = 0) {
        self.id = id
        self.limit = limit
        self.offset = offset
    }
    func execute(in store: Store) {
        NeteaseCloudMusicApi.shared.artistMV(id: id, limit: limit, offset: offset) { (data, error) in
            guard error == nil else {
                store.dispatch(.artistMVDone(result: .failure(error!)))
                return
            }
            if data?["code"] as? Int == 200 {
                let mvsDict = data!["mvs"] as! [NeteaseCloudMusicApi.ResponseData]
                let mvs = mvsDict.map{$0.toData!.toModel(MV.self)!}
                store.dispatch(.artistMVDone(result: .success(mvs)))
            }else {
                let code = data?["code"] as? Int ?? -1
                let message = data?["message"] as? String ?? "错误信息解码错误"
                store.dispatch(.artistMVDone(result: .failure(.artistMV(code: code, message: message))))
            }
        }
    }
}

struct ArtistSublistCommand: AppCommand {
    let limit: Int
    let offset: Int
    
    init(limit: Int = 30, offset: Int = 0) {
        self.limit = limit
        self.offset = offset
    }
    func execute(in store: Store) {
        NeteaseCloudMusicApi.shared.artistSublist(limit: limit, offset: offset) { (data, error) in
            guard error == nil else {
                store.dispatch(.artistSublistDone(result: .failure(error!)))
                return
            }
            if data?["code"] as? Int == 200 {
                let artistSublistDict = data!["data"] as! [NeteaseCloudMusicApi.ResponseData]
                let artistSublist = artistSublistDict.map{$0.toData!.toModel(ArtistSublist.self)!}
                store.dispatch(.artistSublistDone(result: .success(artistSublist)))
            }else {
                let code = data?["code"] as? Int ?? -1
                let message = data?["message"] as? String ?? "错误信息解码错误"
                store.dispatch(.artistSublistDone(result: .failure(.artistSublist(code: code, message: message))))
            }
        }
    }
}

struct ArtistsCommand: AppCommand {
    let id: Int
    
    func execute(in store: Store) {
        NeteaseCloudMusicApi.shared.artists(id: id) { (data, error) in
            guard error == nil else {
                store.dispatch(.artistsDone(result: .failure(error!)))
                return
            }
            if data?["code"] as? Int == 200 {
                let artistDict = data!["artist"] as! NeteaseCloudMusicApi.ResponseData
                let artist = artistDict.toData!.toModel(Artist.self)!
                let hotSongsDictArray = data!["hotSongs"] as! [NeteaseCloudMusicApi.ResponseData]
                let hotSongs = hotSongsDictArray
                                .map{$0.toData!.toModel(HotSong.self)!}
                                .map{SongViewModel($0)}
                let artistviewModel = ArtistDetailViewModel(artist: artist, hotSongs: hotSongs)
                store.dispatch(.artistsDone(result: .success(artistviewModel)))
            }else {
                if let code = data?["code"] as? Int ?? 0 {
                    if let message = data?["message"] as? String ?? "" {
                        store.dispatch(.artistsDone(result: .failure(.comment(code: code, message: message))))
                    }
                }
            }
        }
    }
}

struct ArtistsDoneCommand: AppCommand {
    let id: Int
    
    func execute(in store: Store) {
        store.dispatch(.artistIntroduction(id: id))
        store.dispatch(.artistAlbum(id: id))
        store.dispatch(.artistMV(id: id))
    }
}

struct ArtistIntroductionCommand: AppCommand {
    let id: Int
    
    func execute(in store: Store) {
        NeteaseCloudMusicApi.shared.artistIntroduction(id: id) { (data, error) in
            guard error == nil else {
                store.dispatch(.artistIntroductionDone(result: .failure(error!)))
                return
            }
            if data?["code"] as? Int == 200 {
                let briefDesc = data!["briefDesc"] as! String
                store.dispatch(.artistIntroductionDone(result: .success(briefDesc)))
            }else {
                if let code = data?["code"] as? Int ?? 0 {
                    if let message = data?["message"] as? String ?? "" {
                        store.dispatch(.artistIntroductionDone(result: .failure(.comment(code: code, message: message))))
                    }
                }
            }
        }
    }
}

struct CommentCommand: AppCommand {
    let id: Int
    let cid: Int
    let content: String
    let type: NeteaseCloudMusicApi.CommentType
    let action: NeteaseCloudMusicApi.CommentAction
    
    func execute(in store: Store) {
        NeteaseCloudMusicApi.shared.comment(id: id, cid: cid, content: content,type: type, action: action) { (data, error) in
            guard error == nil else {
                store.dispatch(.commentDone(result: .failure(error!)))
                return
            }
            if data!["code"] as! Int == 200 {
                let args = (id, cid, type , action)
                store.dispatch(.commentDone(result: .success(args)))
            }else {
                if let code = data?["code"] as? Int ?? 0 {
                    if let message = data?["message"] as? String ?? "" {
                        store.dispatch(.commentDone(result: .failure(.comment(code: code, message: message))))
                    }
                }
            }
        }
    }
}

struct CommentDoneCommand: AppCommand {
    let id: Int
    let type: NeteaseCloudMusicApi.CommentType
    let action: NeteaseCloudMusicApi.CommentAction

    func execute(in store: Store) {
        if type == .song {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                store.dispatch(.commentMusic(id: id))
            }
        }
    }
}
struct CommentLikeCommand: AppCommand {
    let id: Int
    let cid: Int
    let like: Bool
    let type: NeteaseCloudMusicApi.CommentType
    
    func execute(in store: Store) {
        NeteaseCloudMusicApi.shared.commentLike(id: id, cid: cid, like: like, type: type) { (data, error) in
//            guard error == nil else {
//                store.dispatch(.commentMusicDone(result: .failure(error!)))
//                return
//            }
//            if data!["code"] as! Int == 200 {
//                var hotComments = [Comment]()
//                var comments = [Comment]()
//                if let hotCommentsArray = data?["hotComments"] as? [NeteaseCloudMusicApi.ResponseData] {
//                    hotComments = hotCommentsArray.map({$0.toData!.toModel(Comment.self)!})
//                }
//                if let commentsArray = data?["comments"] as? [NeteaseCloudMusicApi.ResponseData] {
//                    comments = commentsArray.map({$0.toData!.toModel(Comment.self)!})
//                }
//                comments.append(contentsOf: hotComments)
//                store.dispatch(.commentMusicDone(result: .success((hotComments,comments))))
//            }else {
//                store.dispatch(.commentMusicDone(result: .failure(.commentMusic)))
//            }
        }
    }
}

struct CommentMusicCommand: AppCommand {
    let id: Int
    let limit: Int
    let offset: Int
    let beforeTime: Int
    
    init(id: Int = 0, limit: Int = 20, offset: Int = 0, beforeTime: Int = 0) {
        self.id = id
        self.limit = limit
        self.offset = offset
        self.beforeTime = beforeTime
    }
    func execute(in store: Store) {
        NeteaseCloudMusicApi.shared.commentMusic(id: id, limit: limit, offset: offset, beforeTime: beforeTime) { (data, error) in
            guard error == nil else {
                store.dispatch(.commentMusicDone(result: .failure(error!)))
                return
            }
            if data!["code"] as! Int == 200 {
                var hotComments = [Comment]()
                var comments = [Comment]()
               
                if let hotCommentsArray = data?["hotComments"] as? [NeteaseCloudMusicApi.ResponseData] {
                    hotComments = hotCommentsArray.map({$0.toData!.toModel(Comment.self)!})
                }
                if let commentsArray = data?["comments"] as? [NeteaseCloudMusicApi.ResponseData] {
                    comments = commentsArray.map({$0.toData!.toModel(Comment.self)!})
                }
                let total = data!["total"] as! Int
                store.dispatch(.commentMusicDone(result: .success((hotComments,comments,total))))
            }else {
                store.dispatch(.commentMusicDone(result: .failure(.commentMusic)))
            }
        }
    }
}

struct InitAcionCommand: AppCommand {
    func execute(in store: Store) {
        if let user = store.appState.settings.loginUser {
            store.dispatch(.userPlaylist(uid: user.uid))
            store.dispatch(.recommendPlaylist)
            store.dispatch(.likelist(uid: user.uid))
            store.dispatch(.artistSublist())
        }
    }
}

struct LikeCommand: AppCommand {
    let id: Int
    let like: Bool
    
    func execute(in store: Store) {
        NeteaseCloudMusicApi.shared.like(id: id, like: like) { (data, error) in
            guard error == nil else {
                store.dispatch(.likeDone(result: .failure(error!)))
                return
            }
            if data!["code"] as! Int == 200 {
                store.dispatch(.likeDone(result: .success(self.like)))
            }else {
                store.dispatch(.likeDone(result: .failure(.like)))
            }
        }
    }
}

struct LikeDoneCommand: AppCommand {

    func execute(in store: Store) {
        if let uid = store.appState.settings.loginUser?.uid {
        store.dispatch(.likelist(uid: uid))
        }
    }
}

struct LikeListCommand: AppCommand {
    let uid: Int
    
    func execute(in store: Store) {
        NeteaseCloudMusicApi.shared.likeList(uid: uid) { (data, error) in
            guard error == nil else {
                store.dispatch(.likelistDone(result: .failure(error!)))
                return
            }
            if data!["code"] as! Int == 200 {
                let likelist = data!["ids"] as! [Int]
                
                store.dispatch(.likelistDone(result: .success(likelist)))
            }else {
                store.dispatch(.likelistDone(result: .failure(.likelist)))
            }
        }
    }
}

struct LyricCommand: AppCommand {
    let id: Int
    func execute(in store: Store) {
        NeteaseCloudMusicApi.shared.lyric(id: id) { (data, error) in
            guard error == nil else {
                store.dispatch(.lyricDone(result: .failure(error!)))
                return
            }
            if data!["code"] as! Int == 200 {
                if let lrc = data?["lrc"] as? NeteaseCloudMusicApi.ResponseData {
                    let lyric = lrc["lyric"] as! String
                    store.dispatch(.lyricDone(result: .success(lyric)))
                }
            }else {
                store.dispatch(.lyricDone(result: .failure(.lyricError)))
            }
        }
    }

}

struct LoginCommand: AppCommand {
    let email: String
    let password: String

    func execute(in store: Store) {
        NeteaseCloudMusicApi.shared.login(email: email, password: password) { (data, error) in
            guard error == nil else {
                store.dispatch(.loginDone(result: .failure(error!)))
                return
            }
            if data?["code"] as? Int == 200 {
                var user = User()
                if let accountDict = data!["account"] as? NeteaseCloudMusicApi.ResponseData {
                    user.account = accountDict.toData!.toModel(Account.self)!
                }
                user.csrf = NeteaseCloudMusicApi.shared.getCSRFToken()
                user.loginType = data!["loginType"] as! Int
                if let profile = data!["profile"] as? NeteaseCloudMusicApi.ResponseData {
                    user.profile = profile.toData!.toModel(Profile.self)!
                    user.uid = profile["userId"] as! Int
                }
                DataManager.shared.userLogin(user)
                store.dispatch(.loginDone(result: .success(user)))
                store.dispatch(.showLoginView(show: false))
            }else {
                store.dispatch(.loginDone(result: .failure(.loginError(code: data!["code"] as! Int, message: data!["message"] as! String))))
            }
            
        }
    }
}

struct LoginDoneCommand: AppCommand {
    func execute(in store: Store) {
        store.dispatch(.initAction)
    }
}

struct LogoutCommand: AppCommand {

    func execute(in store: Store) {
        NeteaseCloudMusicApi.shared.logout { (data, error) in
            
        }
    }
}

struct PlaylistCreateCommand: AppCommand {
    let name: String
    let privacy: Int
    
    func execute(in store: Store) {
        NeteaseCloudMusicApi.shared.playlistCreate(name: name, privacy: privacy) { (data, error) in
            guard error == nil else {
                store.dispatch(.playlistCreateDone(result: .failure(error!)))
                return
            }
            if data!["code"] as! Int == 200 {
                store.dispatch(.playlistCreateDone(result: .success(true)))
            }else {
                store.dispatch(.playlistCreateDone(result: .failure(.playlistCreateError)))
            }
        }
    }
}

struct PlaylistCreateDoneCommand: AppCommand {
    
    func execute(in store: Store) {
        if let uid = store.appState.settings.loginUser?.uid {
            store.dispatch(.userPlaylist(uid: uid))
        }
    }
}

struct PlaylistDeleteCommand: AppCommand {
    let pid: Int
    
    func execute(in store: Store) {
        NeteaseCloudMusicApi.shared.playlistDelete(pid: pid) { (data, error) in
            guard error == nil else {
                store.dispatch(.playlistDeleteDone(result: .failure(error!)))
                return
            }
            if data!["code"] as! Int == 200 {
                store.dispatch(.playlistDeleteDone(result: .success(data!["id"] as! Int)))
            }else {
                store.dispatch(.playlistDeleteDone(result: .failure(.playlistDeleteError)))
            }
        }
    }
}

struct PlaylistDeleteDoneCommand: AppCommand {
    
    func execute(in store: Store) {
        if let uid = store.appState.settings.loginUser?.uid {
            store.dispatch(.userPlaylist(uid: uid))
        }
    }
}

struct PlaylistDetailCommand: AppCommand {
    let id: Int
    
    func execute(in store: Store) {
        NeteaseCloudMusicApi.shared.playlistDetail(id) { (data, error) in
            guard error == nil else {
                store.dispatch(.playlistDetailDone(result: .failure(error!)))
                return
            }
            if data!["code"] as! Int == 200 {
                if let playlistDict = data?["playlist"] as? NeteaseCloudMusicApi.ResponseData {
                    let playlist = playlistDict.toData?.toModel(Playlist.self)
                    store.dispatch(.playlistDetailDone(result: .success(playlist!)))
                }
            }else {
                store.dispatch(.playlistDetailDone(result: .failure(.playlistDetailError)))
            }
        }
    }
}

struct PlaylistDetailDoneCommand: AppCommand {
    let playlistDetail: Playlist
    
    func execute(in store: Store) {
        if let ids = playlistDetail.trackIds?.map({$0.id}) {
            store.dispatch(.songsDetail(ids: ids))
        }
    }
}

struct PlaylistOrderUpdateCommand: AppCommand {
    let ids: [Int]
    
    func execute(in store: Store) {
        NeteaseCloudMusicApi.shared.playlistOrderUpdate(ids: ids) { (data, error) in
            guard error == nil else {
                store.dispatch(.playlistOrderUpdateDone(result: .failure(error!)))
                return
            }
            if data?["code"] as? Int == 200 {
                store.dispatch(.playlistOrderUpdateDone(result: .success(true)))
            }else {
                store.dispatch(.playlistOrderUpdateDone(result: .failure(.playlistOrderUpdateError(code: data!["code"] as! Int, message: data!["msg"] as! String))))
            }
        }
    }
}

struct PlaylistOrderUpdateDoneCommand: AppCommand {
    func execute(in store: Store) {
        if let uid = store.appState.settings.loginUser?.uid {
            store.dispatch(.userPlaylist(uid: uid))
        }
    }
}

struct PlaylisSubscribeCommand: AppCommand {
    let id: Int
    let subcribe: Bool
    
    func execute(in store: Store) {
        NeteaseCloudMusicApi.shared.playlistSubscribe(id: id, subscribe: subcribe) { (data, error) in
            guard error == nil else {
                store.dispatch(.playlistSubscibeDone(result: .failure(error!)))
                return
            }
            if data!["code"] as! Int == 200 {
                store.dispatch(.playlistSubscibeDone(result: .success(self.subcribe)))
            }else {
                store.dispatch(.playlistSubscibeDone(result: .failure(.playlistSubscribeError)))
            }
        }
    }
}

struct PlaylisSubscribeDoneCommand: AppCommand {

    func execute(in store: Store) {
        if let uid = store.appState.settings.loginUser?.uid {
            store.dispatch(.userPlaylist(uid: uid))
        }
    }
}

struct PlaylistTracksCommand: AppCommand {
    let pid: Int
    let op: Bool
    let ids: [Int]
    
    func execute(in store: Store) {
        NeteaseCloudMusicApi.shared.playlistTracks(pid: pid, op: op, ids: ids) { (data, error) in
            guard error == nil else {
                store.dispatch(.playlistTracksDone(result: .failure(error!)))
                return
            }
            if data!["code"] as! Int == 200 {
                store.dispatch(.playlistTracksDone(result: .success(true)))
            }else {
                store.dispatch(.playlistTracksDone(result: .failure(.playlistTracksError(code: data!["code"] as! Int, message: data!["message"] as! String))))
            }
        }
    }
}

struct PlaylistTracksDoneCommand: AppCommand {
    
    func execute(in store: Store) {
        if let uid = store.appState.settings.loginUser?.uid {
            store.dispatch(.userPlaylist(uid: uid))
        }
    }
}

struct PlayRequestCommand: AppCommand {
    let id: Int
    
    func execute(in store: Store) {
        NeteaseCloudMusicApi.shared.songsURL([id]) { data, error in
            guard error == nil else {
                store.dispatch(.playRequestDone(result: .failure(error!)))
                return
            }
            if let songsURLDict = data?["data"] as? [NeteaseCloudMusicApi.ResponseData] {
                if songsURLDict.count > 0 {
                    store.dispatch(.playRequestDone(result: .success(songsURLDict[0].toData!.toModel(SongURL.self)!)))
                }
            }else {
                store.dispatch(.playRequestDone(result: .failure(.songsURLError)))
            }
        }
    }
}

struct PlayRequestDoneCommand: AppCommand {
    let url: String
    
    func execute(in store: Store) {
        let index = store.appState.playing.index
        let songId = store.appState.playing.playinglist[index].id
        store.appState.playing.loadTime = 0
        store.appState.playing.loadTimelabel = "00:00"
        store.appState.playing.totalTime = 0
        store.appState.playing.totalTimeLabel = "00:00"
        store.appState.playing.loadPercent = 0
        Player.shared.playWithURL(url: url)
        store.dispatch(.lyric(id: songId))
    }
}

struct PlayBackwardCommand: AppCommand {
    
    func execute(in store: Store) {
        let count = store.appState.playing.playinglist.count
        
        if count > 1 {
            var index = store.appState.playing.index
            if index == 0 {
                index = count - 1
            }else {
                index = (index - 1) % count
            }
            store.dispatch(.playByIndex(index: index))
        }else if count == 1 {
            store.dispatch(.replay)
        }else {
            return
        }
    }
}

struct PlayForwardCommand: AppCommand {
    
    func execute(in store: Store) {
        let count = store.appState.playing.playinglist.count
        guard count > 0 else {
            return
        }
        if count > 1 {
            var index = store.appState.playing.index
            index = (index + 1) % count
            store.dispatch(.playByIndex(index: index))
        }else if count == 1 {
            store.dispatch(.replay)
        }else {
            return
        }
    }
}

struct PlayToEndActionCommand: AppCommand {
    
    func execute(in store: Store) {
        switch store.appState.settings.playMode {
        case .playlist:
            store.dispatch(.playForward)
        case .relplay:
            store.dispatch(.replay)
            break
        }
    }
}

struct RecommendPlaylistCommand: AppCommand {
    func execute(in store: Store) {
        NeteaseCloudMusicApi.shared.recommendResource { (data, error) in
            guard error == nil else {
                store.dispatch(.recommendPlaylistDone(result: .failure(error!)))
                return
            }
            if data!["code"] as! Int == 200 {
                if let recommendPlaylists = data?["recommend"] as? [NeteaseCloudMusicApi.ResponseData] {

//                    let playlist = playlistDict.toData?.toModel(Playlist.self)
                    store.dispatch(.recommendPlaylistDone(result: .success(recommendPlaylists.map { $0.toData!.toModel(RecommendPlaylist.self)!})))
                }
            }else {
                store.dispatch(.recommendPlaylistDone(result: .failure(.playlistDetailError)))
            }
        }
    }
}

struct RecommendPlaylistDoneCommand: AppCommand {
    func execute(in store: Store) {
        store.dispatch(.recommendSongs)
    }
}

struct RecommendSongsCommand: AppCommand {
    func execute(in store: Store) {
        NeteaseCloudMusicApi.shared.recommendSongs { (data, error) in
            guard error == nil else {
                store.dispatch(.recommendSongsDone(result: .failure(error!)))
                return
            }
            if data!["code"] as! Int == 200 {
                if let recommendSongsPlaylist = data?["data"] as? NeteaseCloudMusicApi.ResponseData {
                    let playlist = recommendSongsPlaylist.toData!.toModel(RecommendSongsPlaylist.self)!
                    store.dispatch(.recommendSongsDone(result: .success(PlaylistViewModel(playlist))))
                }
            }else {
                store.dispatch(.recommendSongsDone(result: .failure(.playlistDetailError)))
            }
        }
    }
}

struct SearchCommand: AppCommand {
    let keyword: String
    let type: NeteaseCloudMusicApi.SearchType
    let limit: Int
    let offset: Int
    
    func execute(in store: Store) {
        guard keyword.count > 0 else {
            return
        }
        NeteaseCloudMusicApi.shared.search(keyword: keyword, type: type, limit: limit, offset: offset) { data, error in
//            print(data as? NeteaseCloudMusicApi.ResponseData)
            guard error == nil else {
                store.dispatch(.searchSongDone(result: .failure(error!)))
                return
            }
            if let result = data?["result"] as? NeteaseCloudMusicApi.ResponseData {
                if let songs = result["songs"] as? [NeteaseCloudMusicApi.ResponseData] {
                    store.dispatch(.searchSongDone(result: .success(songs.map{($0.toData?.toModel(SearchSongDetail.self))!})))
                }
                if let playlists = result["playlists"] as? [NeteaseCloudMusicApi.ResponseData] {
                    let playlistsViewModel = playlists.map{$0.toData!.toModel(SearchPlaylist.self)!}.map{PlaylistViewModel($0)}
                    store.dispatch(.searchPlaylistDone(result: .success(playlistsViewModel)))
                }
            }else {
                store.dispatch(.searchSongDone(result: .failure(.songsDetailError)))
            }
        }
    }
}

struct SearchSongDoneCommand: AppCommand {
    
    func execute(in store: Store) {
        let ids = store.appState.search.songs.map{$0.id}
        store.dispatch(.songsDetail(ids: ids))
    }
}

struct SongsDetailCommand: AppCommand {
    let ids: [Int]
    
    func execute(in store: Store) {
            NeteaseCloudMusicApi.shared.songsDetail(ids) { data, error in
                guard error == nil else {
                    store.dispatch(.songsDetailDone(result: .failure(error!)))
                    return
                }
                if let songs = data?["songs"] as? [NeteaseCloudMusicApi.ResponseData] {
                    if songs.count > 0 {
                        store.dispatch(.songsDetailDone(result: .success(songs.map{$0.toData!.toModel(SongDetail.self)!})))
                    }
                }else {
                    store.dispatch(.songsDetailDone(result: .failure(.songsDetailError)))
                }
            }
    }
}

struct SongsDetailDoneCommand: AppCommand {
    let songsDetail: [SongDetail]
    
    func execute(in store: Store) {
        store.dispatch(.songsURL(ids: songsDetail.map{$0.id}))
    }
}

struct SongsOrderUpdateCommand: AppCommand {
    let pid: Int
    let ids: [Int]
    
    func execute(in store: Store) {
            NeteaseCloudMusicApi.shared.songsOrderUpdate(pid: pid, ids: ids) { data, error in
                guard error == nil else {
                    store.dispatch(.songsOrderUpdateDone(result: .failure(error!)))
                    return
                }
                if data?["code"] as? Int == 200 {
                    store.dispatch(.songsOrderUpdateDone(result: .success(pid)))
                }else {
                    store.dispatch(.songsOrderUpdateDone(result: .failure(.playlistOrderUpdateError(code: data!["code"] as! Int, message: data!["message"] as! String))))
                }
            }
    }
}

struct SongsOrderUpdateDoneCommand: AppCommand {
    let pid: Int
    
    func execute(in store: Store) {
        store.dispatch(.playlistDelete(pid: pid))
    }
}

struct SongsURLCommand: AppCommand {
    let ids: [Int]
    
    func execute(in store: Store) {
        NeteaseCloudMusicApi.shared.songsURL(ids) { data, error in
            guard error == nil else {
                store.dispatch(.songsURLDone(result: .failure(error!)))
                return
            }
            if let songsURLDict = data?["data"] as? [NeteaseCloudMusicApi.ResponseData] {
                if songsURLDict.count > 0 {
                    store.dispatch(.songsURLDone(result: .success(songsURLDict.map{$0.toData!.toModel(SongURL.self)!})))
                }
            }else {
                store.dispatch(.songsURLDone(result: .failure(.songsURLError)))
            }
        }
    }
}


struct RePlayCommand: AppCommand {
    func execute(in store: Store) {
        Player.shared.seek(seconds: 0)
        Player.shared.play()
    }
}

struct SeeKCommand: AppCommand {
    
    func execute(in store: Store) {
        Player.shared.seek(seconds: store.appState.playing.loadTime)
    }
}

struct TooglePlayCommand: AppCommand {

    func execute(in store: Store) {
        guard store.appState.playing.songUrl != nil else {
            return
        }
        if Player.shared.isPlaying {
            store.dispatch(.pause)
        }else {
            store.dispatch(.play)
        }
    }
}

struct UserPlayListCommand: AppCommand {
    let uid: Int
    
    func execute(in store: Store) {
        NeteaseCloudMusicApi.shared.userPlayList(uid) { (data, error) in
            guard error == nil else {
                store.dispatch(.userPlaylistDone(uid: uid, result: .failure(error!)))
                return
            }
            if data!["code"] as! Int == 200 {
                if let lists = data?["playlist"] as? [NeteaseCloudMusicApi.ResponseData] {
                    let playlists = lists.map{PlaylistViewModel($0.toData!.toModel(Playlist.self)!)}
                    store.dispatch(.userPlaylistDone(uid: uid, result: .success(playlists)))
                }
            }else {
                store.dispatch(.userPlaylistDone(uid: uid, result: .failure(.userPlaylistError)))
            }
        }
    }
}
