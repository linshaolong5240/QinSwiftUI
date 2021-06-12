//
//  AppCommand.swift
//  Qin
//
//  Created by 林少龙 on 2020/6/17.
//  Copyright © 2020 teenloong. All rights reserved.
//

import Foundation
import CoreData
import Combine
import Kingfisher
import struct CoreGraphics.CGSize

protocol AppCommand {
    func execute(in store: Store)
}
struct InitAcionCommand: AppCommand {
    func execute(in store: Store) {
        store.appState.initRequestingCount += 1
        store.dispatch(.albumSublistRequest())
        
        store.appState.initRequestingCount += 1
        store.dispatch(.artistSublistRequest())
        
        store.appState.initRequestingCount += 1
        store.dispatch(.songLikeListRequest())
        
        store.appState.initRequestingCount += 1
        store.dispatch(.playlistCatalogueRequest)
        
        store.appState.initRequestingCount += 1
        store.dispatch(.recommendPlaylistRequest)
        
        store.appState.initRequestingCount += 1
        store.dispatch(.recommendSongsRequest)
        
        store.appState.initRequestingCount += 1
        store.dispatch(.userPlaylistRequest())
    }
}

struct AlbumDetailRequestCommand: AppCommand {
    let id: Int
    
    func execute(in store: Store) {
        NeteaseCloudMusicApi
            .shared
            .requestPublisher(action: AlbumDetailAction(id: id))
            .sink { completion in
                if case .failure(let error) = completion {
                    store.dispatch(.albumDetailRequestDone(result: .failure(AppError.neteaseCloudMusic(error: error))))
                }
            } receiveValue: { albumDetailResponse in
                guard albumDetailResponse.isSuccess else {
                    store.dispatch(.albumDetailRequestDone(result: .failure(AppError.albumDetailRequest)))
                    return
                }
                DataManager.shared.updateAlbum(model: albumDetailResponse)
                store.dispatch(.albumDetailRequestDone(result: .success(albumDetailResponse.songs.map({ $0.id }))))
            }.store(in: &store.cancellableSet)
    }
}

struct AlbumSubRequestCommand: AppCommand {
    let id: Int
    let sub: Bool
    
    func execute(in store: Store) {
        NeteaseCloudMusicApi
            .shared
            .requestPublisher(action: AlbumSubAction(parameters: .init(id: id), sub: sub))
            .sink { completion in
                if case .failure(let error) = completion {
                    store.dispatch(.albumSubRequestDone(result: .failure(AppError.neteaseCloudMusic(error: error))))
                }
            } receiveValue: { albumSubResponse in
                guard albumSubResponse.isSuccess else {
                    store.dispatch(.albumSubRequestDone(result: .failure(AppError.albumSubRequest)))
                    return
                }
                store.dispatch(.albumSubRequestDone(result: .success(sub)))
            }.store(in: &store.cancellableSet)
    }
}

struct AlbumSubRequestDoneCommand: AppCommand {
    func execute(in store: Store) {
        store.dispatch(.albumSublistRequest())
    }
}

struct AlbumSublistRequestCommand: AppCommand {
    let limit: Int
    let offset: Int
    
    func execute(in store: Store) {
        NeteaseCloudMusicApi
            .shared
            .requestPublisher(action: AlbumSublistAction(parameters: .init(limit: limit, offset: limit * offset)))
            .sink { completion in
                if case .failure(let error) = completion {
                    store.dispatch(.albumSublistRequestDone(result: .failure(AppError.neteaseCloudMusic(error: error))))
                }
            } receiveValue: { albumSublistResponse in
                guard albumSublistResponse.isSuccess else {
                    store.dispatch(.albumSublistRequestDone(result: .failure(AppError.albumSublistRequest)))
                    return
                }
                store.dispatch(.albumSublistRequestDone(result: .success(albumSublistResponse)))
            }.store(in: &store.cancellableSet)
    }
}

struct ArtistAlbumsRequestCommand: AppCommand {
    let id: Int
    let limit: Int
    let offset: Int
    
    func execute(in store: Store) {
        NeteaseCloudMusicApi
            .shared
            .requestPublisher(action: ArtistAlbumsAction(id: id, parameters: .init(limit: limit, offset: offset * limit)))
            .sink { completion in
                if case .failure(let error) = completion {
                    store.dispatch(.albumSublistRequestDone(result: .failure(AppError.neteaseCloudMusic(error: error))))
                }
            } receiveValue: { artistAlbumResponse in
                guard artistAlbumResponse.isSuccess else {
                    store.dispatch(.albumSublistRequestDone(result: .failure(AppError.artistAlbumsRequest)))
                    return
                }
                DataManager.shared.updateArtistAlbums(id: id, model: artistAlbumResponse)
                store.dispatch(.artistAlbumsRequestDone(result: .success(artistAlbumResponse.hotAlbums.map({ $0.id }))))
            }.store(in: &store.cancellableSet)
    }
}

struct ArtistDetailRequestCommand: AppCommand {
    let id: Int
    
    func execute(in store: Store) {
        let artistHotSongsPublisher =  NeteaseCloudMusicApi.shared.requestPublisher(action: ArtistHotSongsAction(id: id))
        let artistIntroductionPublisher = NeteaseCloudMusicApi.shared.requestPublisher(action: ArtistIntroductionAction(parameters: .init(id: id)))
        let artistInfoPublisher = Publishers.CombineLatest(artistHotSongsPublisher, artistIntroductionPublisher)
        artistInfoPublisher
            .sink { completion in
                if case .failure(let error) = completion {
                    store.dispatch(.artistDetailRequestDone(result: .failure(AppError.neteaseCloudMusic(error: error))))
                }
            } receiveValue: { artistHotSongsResponse, artistIntroductionResponse in
                guard artistHotSongsResponse.isSuccess else {
                    store.dispatch(.artistDetailRequestDone(result: .failure(AppError.artistDetailRequest)))
                    return
                }
                let introduction = artistIntroductionResponse.desc
                DataManager.shared.updateArtist(artistModel: artistHotSongsResponse.artist, introduction: introduction)
                DataManager.shared.updateSongs(model: artistHotSongsResponse)
                DataManager.shared.updateArtistHotSongs(to: id, songsId: artistHotSongsResponse.hotSongs.map({ $0.id }))
                store.dispatch(.artistDetailRequestDone(result: .success(artistHotSongsResponse.hotSongs.map({ $0.id }))))
            }.store(in: &store.cancellableSet)
    }
}

struct ArtistMVsRequestCommand: AppCommand {
    let id: Int
    let limit: Int
    let offset: Int
    let total: Bool
    
    func execute(in store: Store) {
        NeteaseCloudMusicApi
            .shared
            .requestPublisher(action: ArtistMVAction(parameters: .init(artistId: id, limit: limit, offset: offset * limit, total: total)))
            .sink { completion in
                if case .failure(let error) = completion {
                    store.dispatch(.artistMVsRequestDone(result: .failure(AppError.neteaseCloudMusic(error: error))))
                }
            } receiveValue: { artistMVResponse in
                guard artistMVResponse.isSuccess else {
                    store.dispatch(.artistMVsRequestDone(result: .failure(AppError.artistMVsRequest)))
                    return
                }
                DataManager.shared.updateMV(model: artistMVResponse)
                store.dispatch(.artistMVsRequestDone(result: .success(artistMVResponse)))
            }.store(in: &store.cancellableSet)
    }
}

struct ArtistSubRequestCommand: AppCommand {
    let id: Int
    let sub: Bool
    
    func execute(in store: Store) {
        NeteaseCloudMusicApi
            .shared
            .requestPublisher(action: ArtistSubAction(sub: sub, parameters: .init(artistId: id, artistIds: [id])))
            .sink { completion in
                if case .failure(let error) = completion {
                    store.dispatch(.artistSubRequestDone(result: .failure(AppError.neteaseCloudMusic(error: error))))
                }
            } receiveValue: { artistSubResponse in
                guard artistSubResponse.isSuccess else {
                    store.dispatch(.artistSubRequestDone(result: .failure(AppError.artistSubRequest)))
                    return
                }
                store.dispatch(.artistSubRequestDone(result: .success(sub)))
            }.store(in: &store.cancellableSet)
    }
}

struct ArtistSubRequestDoneCommand: AppCommand {
    
    func execute(in store: Store) {
        store.dispatch(.artistSublistRequest())
    }
}

struct ArtistSublistRequestCommand: AppCommand {
    let limit: Int
    let offset: Int
    
    init(limit: Int, offset: Int = 0) {
        self.limit = limit
        self.offset = offset
    }
    
    func execute(in store: Store) {
        NeteaseCloudMusicApi.shared.requestPublisher(action: ArtistSublistAction(parameters: .init(limit: limit, offset: offset)))
            .sink { completion in
                if case .failure(let error) = completion {
                    store.dispatch(.artistSublistRequestDone(result: .failure(AppError.neteaseCloudMusic(error: error))))
                }
            } receiveValue: { artistSublistResponse in
                guard artistSublistResponse.isSuccess else {
                    store.dispatch(.artistSublistRequestDone(result: .failure(AppError.artistSublistRequest)))
                    return
                }
                store.dispatch(.artistSublistRequestDone(result: .success(artistSublistResponse)))
            }.store(in: &store.cancellableSet)
    }
}

struct CommentRequestCommand: AppCommand {
    let id: Int
    let commentId: Int?
    let content: String?
    let type: CommentType
    let action: CommentAction
    
    func execute(in store: Store) {
        if let content = content, action == .add {
            NeteaseCloudMusicApi.shared.requestPublisher(action: CommentAddAction(parameters: .init(threadId: id, content: content, type: type)))
                .sink { completion in
                    if case .failure(let error) = completion {
                        store.dispatch(.commentDoneRequest(result: .failure(AppError.neteaseCloudMusic(error: error))))
                    }
                } receiveValue: { commentAddResponse in
                    guard commentAddResponse.isSuccess else {
                        store.dispatch(.commentDoneRequest(result: .failure(AppError.comment)))
                        return
                    }
                    let result = (id: id, type: type, action: action)
                    store.dispatch(.commentDoneRequest(result: .success(result)))
                }.store(in: &store.cancellableSet)
        }
        if let commentId = commentId, action == .delete {
            NeteaseCloudMusicApi.shared.requestPublisher(action: CommentDeleteAction(parameters: .init(threadId: id, commentId: commentId, type: type)))
                .sink { completion in
                    if case .failure(let error) = completion {
                        store.dispatch(.commentDoneRequest(result: .failure(AppError.neteaseCloudMusic(error: error))))
                    }
                } receiveValue: { commentDeleteResponse in
                    guard commentDeleteResponse.isSuccess else {
                        store.dispatch(.commentDoneRequest(result: .failure(AppError.comment)))
                        return
                    }
                    let result = (id: id, type: type, action: action)
                    store.dispatch(.commentDoneRequest(result: .success(result)))
                }.store(in: &store.cancellableSet)
        }
    }
}

struct CommentRequestDoneCommand: AppCommand {
    let id: Int
    let type: CommentType
    let action: CommentAction
    
    func execute(in store: Store) {
        if type == .song {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                store.dispatch(.commentMusicRequest(rid: id))
            }
        }
    }
}

struct CommentLikeRequestCommand: AppCommand {
    let id: Int
    let cid: Int
    let like: Bool
    let type: CommentType
    
    func execute(in store: Store) {
        NeteaseCloudMusicApi.shared.requestPublisher(action: CommentLikeAction(like: like, parameters: .init(threadId: id, commentId: cid, commentType: type)))
            .sink { completion in
                if case .failure(let error) = completion {
                    store.dispatch(.commentLikeDone(result: .failure(AppError.neteaseCloudMusic(error: error))))
                }
            } receiveValue: { commentlikeResponse in
                guard commentlikeResponse.isSuccess else {
                    store.dispatch(.commentLikeDone(result: .failure(AppError.commentLikeRequest)))
                    return
                }
                store.dispatch(.commentLikeDone(result: .success(id)))
            }.store(in: &store.cancellableSet)
    }
}

struct CommentMusicRequestCommand: AppCommand {
    let rid: Int
    let limit: Int
    let offset: Int
    let beforeTime: Int
    
    func execute(in store: Store) {
        NeteaseCloudMusicApi.shared.requestPublisher(action: CommentSongAction(rid: rid, parameters: .init(rid: rid, limit: limit, offset: limit * offset, beforeTime: beforeTime)))
            .sink { completion in
                if case .failure(let error) = completion {
                    store.dispatch(.commentMusicRequestDone(result: .failure(AppError.neteaseCloudMusic(error: error))))
                }
            } receiveValue: { commentSongResponse in
                guard commentSongResponse.isSuccess else {
                    store.dispatch(.commentMusicRequestDone(result: .failure(AppError.commentMusic)))
                    return
                }
                store.dispatch(.commentMusicRequestDone(result: .success(commentSongResponse)))
            }.store(in: &store.cancellableSet)
    }
}

struct LoginRequestCommand: AppCommand {
    let email: String
    let password: String
    
    func execute(in store: Store) {
        NeteaseCloudMusicApi
            .shared
            .requestPublisher(action: LoginAction(parameters: .init(email: email, password: password)))
            .sink { completion in
                if case .failure(let error) = completion {
                    store.dispatch(.loginRequestDone(result: .failure(AppError.neteaseCloudMusic(error: error))))
                }
            } receiveValue: { loginResponse in
                guard loginResponse.isSuccess else {
                    store.dispatch(.loginRequestDone(result: .failure(AppError.loginRequest)))
                    return
                }
                store.dispatch(.loginRequestDone(result: .success(loginResponse)))
            }.store(in: &store.cancellableSet)
    }
}

struct LoginRequestDoneCommand: AppCommand {
    let user: User
    
    func execute(in store: Store) {
        store.dispatch(.initAction)
    }
}

struct LoginRefreshRequestCommand: AppCommand {
    
    func execute(in store: Store) {
        NeteaseCloudMusicApi
            .shared
            .requestPublisher(action: LoginRefreshAction())
            .sink { completion in
                if case .failure(let error) = completion {
                    store.dispatch(.loginRefreshRequestDone(result: .failure(AppError.neteaseCloudMusic(error: error))))
                }
            } receiveValue: { loginRefreshResponse in
                guard loginRefreshResponse.isSuccess else {
                    store.dispatch(.loginRefreshRequestDone(result: .failure(AppError.loginRefreshRequest)))
                    return
                }
                store.dispatch(.loginRefreshRequestDone(result: .success(true)))
            }.store(in: &store.cancellableSet)
    }
}

struct LoginRefreshDoneCommand: AppCommand {
    let success: Bool
    
    func execute(in store: Store) {
        if success {
            store.dispatch(.initAction)
        }else {
            store.dispatch(.logoutRequest)
        }
    }
}

struct LogoutRequestCommand: AppCommand {
    func execute(in store: Store) {
        NeteaseCloudMusicApi
            .shared
            .requestPublisher(action: LogoutAction())
            .sink { completion in
                if case .failure(let error) = completion {
                    store.dispatch(.logoutRequestDone(result: .failure(AppError.neteaseCloudMusic(error: error))))
                }
            } receiveValue: { logoutResponse in
                guard logoutResponse.isSuccess else {
                    store.dispatch(.logoutRequestDone(result: .failure(AppError.logoutRequest)))
                    return
                }
                store.dispatch(.logoutRequestDone(result: .success(logoutResponse.code)))
            }.store(in: &store.cancellableSet)
    }
}

struct MVDetailRequestCommand: AppCommand {
    let id: Int
    
    func execute(in store: Store) {
        NeteaseCloudMusicApi
            .shared
            .requestPublisher(action: LogoutAction())
            .sink { completion in
                if case .failure(let error) = completion {
                    store.dispatch(.mvDetaillRequestDone(result: .failure(AppError.neteaseCloudMusic(error: error))))
                }
            } receiveValue: { response in
                guard response.isSuccess else {
                    store.dispatch(.mvDetaillRequestDone(result: .failure(AppError.mvDetailRequest)))
                    return
                }
                store.dispatch(.mvDetaillRequestDone(result: .success(id)))
            }.store(in: &store.cancellableSet)
    }
}

struct MVUrlCommand: AppCommand {
    let id: Int
    
    func execute(in store: Store) {
        //        NeteaseCloudMusicApi
        //            .shared
        //            .requestPublisher(action: MVURLAction(parameters: .init(id: Int(mv.id))))
        //            .sink { completion in
        //                if case .failure(let error) = completion {
        //                    Store.shared.dispatch(.error(AppError.neteaseCloudMusic(error: error)))
        //                }
        //            } receiveValue: { mvURLResponse in
        ////                store.dispatch(.mvDetaillRequestDone(result: .success(id)))
        //                mvURL = URL(string: mvURLResponse.data.url)
        //                showPlayer = true
        //            }.store(in: &Store.shared.cancellableSet)
    }
}

struct PlayerPlayBackwardCommand: AppCommand {
    
    func execute(in store: Store) {
        let count = store.appState.playing.playinglist.count
        
        if count > 1 {
            var index = store.appState.playing.index
            if index == 0 {
                index = count - 1
            }else {
                index = (index - 1) % count
            }
            store.dispatch(.playerPlayBy(index: index))
        }else if count == 1 {
            store.dispatch(.playerReplay)
        }else {
            return
        }
    }
}

struct PlayerPlayForwardCommand: AppCommand {
    
    func execute(in store: Store) {
        let count = store.appState.playing.playinglist.count
        guard count > 0 else {
            return
        }
        if count > 1 {
            var index = store.appState.playing.index
            index = (index + 1) % count
            store.dispatch(.playerPlayBy(index: index))
        }else if count == 1 {
            store.dispatch(.playerReplay)
        }else {
            return
        }
    }
}

struct PlayerPlayRequestCommand: AppCommand {
    let id: Int
    
    func execute(in store: Store) {
        if let picUrl =  DataManager.shared.getSong(id: id)?.album?.picUrl {//预先下载播放器专辑图片，避免点击专辑图片动画过渡不自然
            if let url = URL(string: picUrl) {
                let  _ = KingfisherManager.shared.retrieveImage(with: .network(url), options: [.processor(DownsamplingImageProcessor(size: CGSize(width: NEUImageSize.large.width * 2, height: NEUImageSize.large.width * 2)))]) { (result) in
                    switch result {
                    case .success(_):
                        break
                    case .failure(_):
                        break
                    }
                }
                let  _ = KingfisherManager.shared.retrieveImage(with: .network(url), options: [.processor(DownsamplingImageProcessor(size: CGSize(width: NEUImageSize.medium.width * 2, height: NEUImageSize.medium.width * 2)))]) { (result) in
                    switch result {
                    case .success(_):
                        break
                    case .failure(_):
                        break
                    }
                }
            }
        }
        NeteaseCloudMusicApi
            .shared
            .requestPublisher(action: SongURLAction(parameters: .init(ids: [id])))
            .sink { completion in
                if case .failure(let error) = completion {
                    store.dispatch(.playerPlayRequestDone(result: .failure(AppError.neteaseCloudMusic(error: error))))
                }
            } receiveValue: { songURLResponse in
                store.dispatch(.playerPlayRequestDone(result: .success(songURLResponse.data.first?.url)))
            }.store(in: &store.cancellableSet)
    }
}

struct PlayerPlayRequestDoneCommand: AppCommand {
    let url: String
    
    func execute(in store: Store) {
        let index = store.appState.playing.index
        let songId = store.appState.playing.playinglist[index]
        store.dispatch(.songLyricRequest(id: Int(songId)))
        if let url = URL(string: url) {
            Player.shared.playWithURL(url: url)
        }
    }
}

struct PlayerPlayToEndActionCommand: AppCommand {
    
    func execute(in store: Store) {
        switch store.appState.settings.playMode {
        case .playlist:
            store.dispatch(.playerPlayForward)
        case .relplay:
            store.dispatch(.playerReplay)
            break
        }
    }
}

struct PlayinglistInsertCommand: AppCommand {
    let index: Int
    
    func execute(in store: Store) {
        store.dispatch(.playerPlayBy(index: index))
    }
}

struct PlaylistCategoriesRequestCommand: AppCommand {
    func execute(in store: Store) {
        NeteaseCloudMusicApi
            .shared
            .requestPublisher(action: PlaylistCatalogueAction())
            .sink { completion in
                if case .failure(let error) = completion {
                    store.dispatch(.playlistCatalogueRequestsDone(result: .failure(AppError.neteaseCloudMusic(error: error))))
                }
            } receiveValue: { playlistCatalogueResponse in
                guard playlistCatalogueResponse.isSuccess else {
                    store.dispatch(.playlistCatalogueRequestsDone(result: .failure(AppError.playlistCategoriesRequest)))
                    return
                }
                var playlistCatalogue = [PlaylistCatalogue]()
                
                let keys = playlistCatalogueResponse.categories.keys.sorted(by: { $0 < $1})
                
                keys.forEach { key in
                    let category = PlaylistCatalogue(id: Int(key)!, name: playlistCatalogueResponse.categories[key]!, subs: playlistCatalogueResponse.sub.filter({ Int(key) == $0.category }).map(\.name))
                    playlistCatalogue.append(category)
                }
                
                let all = PlaylistCatalogue(id: playlistCatalogue.count, name: playlistCatalogueResponse.all.name, subs: [])
                playlistCatalogue.append(all)
                
                store.dispatch(.playlistCatalogueRequestsDone(result: .success(playlistCatalogue)))
            }.store(in: &store.cancellableSet)
    }
}

struct PlaylistCreateRequestCommand: AppCommand {
    let name: String
    let privacy: PlaylistCreateAction.Privacy
    
    func execute(in store: Store) {
        NeteaseCloudMusicApi
            .shared
            .requestPublisher(action: PlaylistCreateAction(parameters: .init(name: name, privacy: privacy)))
            .sink { completion in
                if case .failure(let error) = completion {
                    store.dispatch(.playlistCreateRequestDone(result: .failure(AppError.neteaseCloudMusic(error: error))))
                }
            } receiveValue: { playlistCreateResponse in
                guard playlistCreateResponse.isSuccess else {
                    store.dispatch(.playlistCreateRequestDone(result: .failure(AppError.playlistCreateRequest)))
                    return
                }
                store.dispatch(.playlistCreateRequestDone(result: .success(playlistCreateResponse.playlist.id)))
            }.store(in: &store.cancellableSet)
    }
}

struct PlaylistCreateRequestDoneCommand: AppCommand {
    
    func execute(in store: Store) {
        store.dispatch(.userPlaylistRequest())
    }
}

struct PlaylistDeleteRequestCommand: AppCommand {
    let pid: Int
    
    func execute(in store: Store) {
        NeteaseCloudMusicApi
            .shared
            .requestPublisher(action: PlaylistDeleteAction(parameters: .init(pid: pid)))
            .sink { completion in
                if case .failure(let error) = completion {
                    store.dispatch(.playlistDeleteRequestDone(result: .failure(AppError.neteaseCloudMusic(error: error))))
                }
            } receiveValue: { playlistDeleteResponse in
                store.dispatch(.playlistDeleteRequestDone(result: .success(playlistDeleteResponse.id)))
            }.store(in: &store.cancellableSet)
    }
}

struct PlaylistDeleteReuquestDoneCommand: AppCommand {
    
    func execute(in store: Store) {
        store.dispatch(.userPlaylistRequest())
    }
}

struct PlaylistDetailRequestCommand: AppCommand {
    let id: Int
    
    func execute(in store: Store) {
        NeteaseCloudMusicApi
            .shared
            .requestPublisher(action: PlaylistDetailAction(parameters: .init(id: id)))
            .sink { completion in
                if case .failure(let error) = completion {
                    store.dispatch(.playlistDetailRequestDone(result: .failure(AppError.neteaseCloudMusic(error: error))))
                }
            } receiveValue: { playlistDetailResponse in
                DataManager.shared.update(model: playlistDetailResponse.playlist)
                store.dispatch(.playlistDetailRequestDone(result: .success(playlistDetailResponse.playlist)))
            }.store(in: &store.cancellableSet)
    }
}

struct PlaylistDetailDoneCommand: AppCommand {
    let playlist: PlaylistResponse
    
    func execute(in store: Store) {
        store.dispatch(.playlistDetailSongsRequest(playlist: playlist))
    }
}

struct PlaylistDetailSongsRequestCommand: AppCommand {
    let playlist: PlaylistResponse
    
    func execute(in store: Store) {
        if let ids = playlist.trackIds?.map(\.id) {
            NeteaseCloudMusicApi
                .shared
                .requestPublisher(action: SongDetailAction(parameters: .init(ids: ids)))
                .sink { completion in
                    if case .failure(let error) = completion {
                        store.dispatch(.playlistDetailSongsRequestDone(result: .failure(AppError.neteaseCloudMusic(error: error))))
                    }
                } receiveValue: { songDetailResponse in
                    guard songDetailResponse.isSuccess else {
                        store.dispatch(.playlistDetailSongsRequestDone(result: .failure(AppError.songsDetailError)))
                        return
                    }
                    DataManager.shared.updateSongs(model: songDetailResponse.songs)
                    DataManager.shared.updatePlaylistSongs(id: playlist.id, songsId: ids)
                    store.dispatch(.playlistDetailSongsRequestDone(result: .success(ids)))
                }.store(in: &store.cancellableSet)
        }
    }
}

struct PlaylistOrderUpdateRequestCommand: AppCommand {
    let ids: [Int]
    
    func execute(in store: Store) {
        NeteaseCloudMusicApi
            .shared
            .requestPublisher(action: PlaylistOrderUpdateAction(parameters: .init(ids: ids)))
            .sink { completion in
                if case .failure(let error) = completion {
                    store.dispatch(.playlistOrderUpdateDone(result: .failure(AppError.neteaseCloudMusic(error: error))))
                }
            } receiveValue: { playlistOrderUpdateResponse in
                store.dispatch(.playlistOrderUpdateDone(result: .success(playlistOrderUpdateResponse.isSuccess)))
            }.store(in: &store.cancellableSet)
    }
}

struct PlaylistOrderUpdateRequestDoneCommand: AppCommand {
    func execute(in store: Store) {
        store.dispatch(.userPlaylistRequest())
    }
}

struct PlaylisSubscribeRequestCommand: AppCommand {
    let id: Int
    let sub: Bool
    
    func execute(in store: Store) {
        NeteaseCloudMusicApi
            .shared
            .requestPublisher(action: PlaylistSubscribeAction(sub: sub, parameters: .init(id: id)))
            .sink { completion in
                if case .failure(let error) = completion {
                    store.dispatch(.playlistSubscibeRequestDone(result: .failure(AppError.neteaseCloudMusic(error: error))))
                }
            } receiveValue: { playlistSubscribeResponse in
                if playlistSubscribeResponse.isSuccess {
                    store.dispatch(.playlistSubscibeRequestDone(result: .success(id)))
                }else {
                    store.dispatch(.playlistSubscibeRequestDone(result: .failure(AppError.playlistSubscribeError)))
                }
            }.store(in: &store.cancellableSet)
    }
}

struct PlaylisSubscribeRequestDoneCommand: AppCommand {
    func execute(in store: Store) {
        store.dispatch(.userPlaylistRequest())
    }
}

struct PlaylistTracksRequestCommand: AppCommand {
    let pid: Int
    let ids: [Int]
    let op: Bool
    
    func execute(in store: Store) {
        NeteaseCloudMusicApi
            .shared
            .requestPublisher(action: PlaylistTracksAction(parameters: .init(pid: pid, ids: ids, op: op ? .add : .del)))
            .sink { completion in
                if case .failure(let error) = completion {
                    store.dispatch(.playlistTracksRequestDone(result: .failure(AppError.neteaseCloudMusic(error: error))))
                }
            } receiveValue: { playlistSubscribeResponse in
                if playlistSubscribeResponse.isSuccess {
                    store.dispatch(.playlistTracksRequestDone(result: .success(pid)))
                }else {
                    store.dispatch(.playlistTracksRequestDone(result: .failure(AppError.playlistSubscribeError)))
                }
            }.store(in: &store.cancellableSet)
    }
}

struct PlaylistTracksRequestDoneCommand: AppCommand {
    let id: Int
    
    func execute(in store: Store) {
        store.dispatch(.playlistDetailRequest(id: id))
    }
}

struct RecommendPlaylistRequestCommand: AppCommand {
    func execute(in store: Store) {
        NeteaseCloudMusicApi
            .shared
            .requestPublisher(action: RecommendPlaylistAction())
            .sink { completion in
                if case .failure(let error) = completion {
                    store.dispatch(.recommendPlaylistRequestDone(result: .failure(AppError.neteaseCloudMusic(error: error))))
                }
            } receiveValue: { recommendPlaylistResponse in
                guard recommendPlaylistResponse.isSuccess else {
                    store.dispatch(.recommendPlaylistRequestDone(result: .failure(AppError.recommendPlaylistRequest)))
                    return
                }
                store.dispatch(.recommendPlaylistRequestDone(result: .success(recommendPlaylistResponse)))
            }.store(in: &store.cancellableSet)
    }
}

struct RecommendSongsRequestCommand: AppCommand {
    func execute(in store: Store) {
        NeteaseCloudMusicApi
            .shared
            .requestPublisher(action: RecommendSongAction())
            .sink { completion in
                if case .failure(let error) = completion {
                    store.dispatch(.recommendSongsRequestDone(result: .failure(AppError.neteaseCloudMusic(error: error))))
                }
            } receiveValue: { recommendSongsResponse in
                guard recommendSongsResponse.isSuccess else {
                    store.dispatch(.recommendSongsRequestDone(result: .failure(AppError.recommendSongsError)))
                    return
                }
                DataManager.shared.update(model: recommendSongsResponse)
                store.dispatch(.recommendSongsRequestDone(result: .success(recommendSongsResponse.data.dailySongs.map(\.id))))
            }.store(in: &store.cancellableSet)
    }
}

struct SearchRequestCommand: AppCommand {
    let keyword: String
    let type: SearchType
    let limit: Int
    let offset: Int
    
    func execute(in store: Store) {
        if type == .song {
            NeteaseCloudMusicApi
                .shared
                .requestPublisher(action: SearchSongAction(parameters: .init(s: keyword, type: type, limit: limit, offset: limit * offset)))
                .sink { completion in
                    if case .failure(let error) = completion {
                        store.dispatch(.searchSongRequestDone(result: .failure(AppError.neteaseCloudMusic(error: error))))
                    }
                } receiveValue: { searchSongResponse in
                    guard searchSongResponse.isSuccess else {
                        store.dispatch(.searchSongRequestDone(result: .failure(AppError.searchError)))
                        return
                    }
                    store.dispatch(.searchSongRequestDone(result: .success(searchSongResponse.result.songs.map(\.id))))
                }.store(in: &store.cancellableSet)
        }
        if type == .playlist {
            NeteaseCloudMusicApi
                .shared
                .requestPublisher(action: SearchPlaylistAction(parameters: .init(s: keyword, type: type, limit: limit, offset: limit * offset)))
                .sink { completion in
                    if case .failure(let error) = completion {
                        store.dispatch(.searchPlaylistRequestDone(result: .failure(AppError.neteaseCloudMusic(error: error))))
                    }
                } receiveValue: { searchPlaylistResponse in
                    guard searchPlaylistResponse.isSuccess else {
                        store.dispatch(.searchPlaylistRequestDone(result: .failure(AppError.searchError)))
                        return
                    }
                    store.dispatch(.searchPlaylistRequestDone(result: .success(searchPlaylistResponse)))
                }.store(in: &store.cancellableSet)
        }
    }
}

struct SearchSongDoneCommand: AppCommand {
    let ids: [Int]
    
    func execute(in store: Store) {
        store.dispatch(.songsDetailRequest(ids: ids))
    }
}

struct SongsDetailCommand: AppCommand {
    let ids: [Int]
    
    func execute(in store: Store) {
        NeteaseCloudMusicApi
            .shared
            .requestPublisher(action: SongDetailAction(parameters: .init(ids: ids)))
            .sink { completion in
                if case .failure(let error) = completion {
                    store.dispatch(.songsDetailRequestDone(result: .failure(AppError.neteaseCloudMusic(error: error))))
                }
            } receiveValue: { songDetailResponse in
                DataManager.shared.batchInsert(type: Song.self, models: songDetailResponse.songs)
                store.dispatch(.songsDetailRequestDone(result: .success(ids)))
            }.store(in: &store.cancellableSet)
    }
}

struct SongLikeRequestCommand: AppCommand {
    let id: Int
    let like: Bool
    
    func execute(in store: Store) {
        NeteaseCloudMusicApi
            .shared
            .requestPublisher(action: SongLikeAction(parameters: .init(trackId: id, like: like)))
            .sink { completion in
                if case .failure(let error) = completion {
                    store.dispatch(.songLikeRequestDone(result: .failure(AppError.neteaseCloudMusic(error: error))))
                }
            } receiveValue: { songLikeResponse in
                store.dispatch(.songLikeRequestDone(result: .success(songLikeResponse.isSuccess)))
            }.store(in: &store.cancellableSet)
    }
}

struct SongLikeRequestDoneCommand: AppCommand {
    
    func execute(in store: Store) {
        if let uid = store.appState.settings.loginUser?.profile.userId {
            store.dispatch(.songLikeListRequest(uid: uid))
        }
    }
}

struct SongLikeListRequestCommand: AppCommand {
    let uid: Int
    
    func execute(in store: Store) {
        NeteaseCloudMusicApi
            .shared
            .requestPublisher(action: SongLikeListAction(parameters: .init(uid: uid)))
            .sink { completion in
                if case .failure(let error) = completion {
                    store.dispatch(.songLikeListRequestDone(result: .failure(AppError.neteaseCloudMusic(error: error))))
                }
            } receiveValue: { songLikeListResponse in
                store.dispatch(.songLikeListRequestDone(result: .success(songLikeListResponse.ids)))
            }.store(in: &store.cancellableSet)
    }
}

struct SongLyricRequestCommand: AppCommand {
    let id: Int
    
    func execute(in store: Store) {
        NeteaseCloudMusicApi
            .shared
            .requestPublisher(action: SongLyricAction(parameters: .init(id: id)))
            .sink { completion in
                if case .failure(let error) = completion {
                    store.dispatch(.songLyricRequestDone(result: .failure(AppError.neteaseCloudMusic(error: error))))
                }
            } receiveValue: { songLyricResponse in
                store.dispatch(.songLyricRequestDone(result: .success(songLyricResponse.lrc.lyric)))
            }.store(in: &store.cancellableSet)
    }
}

struct SongsOrderUpdateRequestCommand: AppCommand {
    let pid: Int
    let ids: [Int]
    
    func execute(in store: Store) {
        NeteaseCloudMusicApi
            .shared
            .requestPublisher(action: SongOrderUpdateAction(parameters: .init(pid: pid, trackIds: ids)))
            .sink { completion in
                if case .failure(let error) = completion {
                    store.dispatch(.songsOrderUpdateRequestDone(result: .failure(AppError.neteaseCloudMusic(error: error))))
                }
            } receiveValue: { songOrderUpdateResponse in
                guard songOrderUpdateResponse.isSuccess else {
                    store.dispatch(.songsOrderUpdateRequestDone(result: .failure(AppError.songsOrderUpdate)))
                    return
                }
                store.dispatch(.songsOrderUpdateRequestDone(result: .success(pid)))
            }.store(in: &store.cancellableSet)
    }
}

struct SongsOrderUpdateRequestingDoneCommand: AppCommand {
    let id: Int
    
    func execute(in store: Store) {
        store.dispatch(.playlistDetailRequest(id: id))
    }
}

struct SongsURLRequestCommand: AppCommand {
    let ids: [Int]
    
    func execute(in store: Store) {
        //        NeteaseCloudMusicApi.shared.songsURL(ids) { result in
        //            switch result {
        //            case .success(let json):
        //                if let songsURLDict = json["data"] as? [NeteaseCloudMusicApi.ResponseData] {
        //                    if songsURLDict.count > 0 {
        //                        store.dispatch(.songsURLRequestDone(result: .success(songsURLDict.map{$0.toData!.toModel(SongURLJSONModel.self)!})))
        //                    }
        //                }else {
        //                    store.dispatch(.songsURLRequestDone(result: .failure(.songsURLError)))
        //                }
        //            case .failure(let error):
        //                store.dispatch(.songsURLRequestDone(result: .failure(error)))
        //            }
        //        }
    }
}


struct RePlayCommand: AppCommand {
    func execute(in store: Store) {
        Player.shared.seek(seconds: 0)
        Player.shared.play()
    }
}

struct SeeKCommand: AppCommand {
    let time: Double
    
    func execute(in store: Store) {
        Player.shared.seek(seconds: time)
    }
}

struct TooglePlayCommand: AppCommand {
    
    func execute(in store: Store) {
        guard store.appState.playing.songUrl != nil else {
            store.dispatch(.playerPlayBy(index: store.appState.playing.index))
            return
        }
        if Player.shared.isPlaying {
            store.dispatch(.playerPause)
        }else {
            store.dispatch(.playerPlay)
        }
    }
}

struct UserPlayListRequestCommand: AppCommand {
    let uid: Int
    let limit: Int
    let offset: Int
    
    func execute(in store: Store) {
        NeteaseCloudMusicApi
            .shared
            .requestPublisher(action: UserPlaylistAction(parameters: .init(uid: uid, limit: limit, offset: offset)))
            .sink { completion in
                if case .failure(let error) = completion {
                    store.dispatch(.userPlaylistRequestDone(result: .failure(AppError.neteaseCloudMusic(error: error))))
                }
            } receiveValue: { userPlaylistResponse in
                store.dispatch(.userPlaylistRequestDone(result: .success(userPlaylistResponse.playlist)))
            }.store(in: &store.cancellableSet)
    }
}
