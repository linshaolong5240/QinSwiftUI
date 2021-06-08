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

struct AlbumRequestCommand: AppCommand {
    let id: Int
    
    func execute(in store: Store) {
        NeteaseCloudMusicApi
            .shared
            .requestPublisher(action: AlbumAction(id: id))
            .sink { completion in
            if case .failure(let error) = completion {
                store.dispatch(.albumRequestDone(result: .failure(AppError.neteaseCloudMusic(error: error))))
            }
            } receiveValue: { albumResponse in
                DataManager.shared.updateAlbum(model: albumResponse)
                store.dispatch(.albumRequestDone(result: .success(albumResponse.songs.map({ $0.id }))))
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
            store.dispatch(.albumSubRequestDone(result: .success(sub)))
        }.store(in: &store.cancellableSet)
    }
}

struct AlbumSubDoneCommand: AppCommand {
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
            let albumSublist = albumSublistResponse.data.map(\.dataModel)
            do {
                let data = try JSONEncoder().encode(albumSublist)
                let objects = try JSONSerialization.jsonObject(with: data) as! [[String: Any]]
                DataManager.shared.batchInsertAfterDeleteAll(entityName: "AlbumSub", objects: objects)
                store.dispatch(.albumSublistRequestDone(result: .success(albumSublist.map{ Int64($0.id) })))
            } catch let error {
                store.dispatch(.albumSublistRequestDone(result: .failure(AppError.neteaseCloudMusic(error: error))))
            }
        }.store(in: &store.cancellableSet)
    }
}

struct ArtistRequestCommand: AppCommand {
    let id: Int
    
    func execute(in store: Store) {
        let artistHotSongsPublisher =  NeteaseCloudMusicApi.shared.requestPublisher(action: ArtistHotSongsAction(id: id))
        let artistIntroductionPublisher = NeteaseCloudMusicApi.shared.requestPublisher(action: ArtistIntroductionAction(parameters: .init(id: id)))
        let artistInfoPublisher = Publishers.CombineLatest(artistHotSongsPublisher, artistIntroductionPublisher)
        artistInfoPublisher
            .sink { completion in
                if case .failure(let error) = completion {
                    store.dispatch(.artistRequestDone(result: .failure(AppError.neteaseCloudMusic(error: error))))
                }
            } receiveValue: { artistHotSongsResponse, artistIntroductionResponse in
                let introduction = artistIntroductionResponse.desc
                DataManager.shared.updateArtist(artistModel: artistHotSongsResponse.artist, introduction: introduction)
                DataManager.shared.updateSongs(model: artistHotSongsResponse)
                DataManager.shared.updateArtistHotSongs(to: id, songsId: artistHotSongsResponse.hotSongs.map({ $0.id }))
                store.dispatch(.artistRequestDone(result: .success(artistHotSongsResponse.hotSongs.map({ $0.id }))))
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
            DataManager.shared.updateArtistAlbums(id: id, model: artistAlbumResponse)
            store.dispatch(.artistAlbumRequestDone(result: .success(artistAlbumResponse.hotAlbums.map({ $0.id }))))
        }.store(in: &store.cancellableSet)
    }
}

struct ArtistMVCommand: AppCommand {
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
                store.dispatch(.artistMvRequestDone(result: .failure(AppError.neteaseCloudMusic(error: error))))
            }
        } receiveValue: { artistMVResponse in
            DataManager.shared.updateMV(model: artistMVResponse)
            store.dispatch(.artistMvRequestDone(result: .success(artistMVResponse.mvs.map({ $0.id }))))
        }.store(in: &store.cancellableSet)
    }
}

struct ArtistSubCommand: AppCommand {
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
            store.dispatch(.artistSubRequestDone(result: .success(sub)))
        }.store(in: &store.cancellableSet)
    }
}

struct ArtistSubDoneCommand: AppCommand {
    
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
                let artistSublist = artistSublistResponse.data.map(\.dataModel)
                do {
                    let data = try JSONEncoder().encode(artistSublist)
                    let objects = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [[String: Any]]
                    DataManager.shared.batchInsertAfterDeleteAll(entityName: "ArtistSub", objects: objects)
                    store.dispatch(.artistSublistRequestDone(result: .success(artistSublist.map{$0.id})))
                }catch let error {
                    store.dispatch(.artistSublistRequestDone(result: .failure(AppError.neteaseCloudMusic(error: error))))
                }
            }.store(in: &store.cancellableSet)
    }
}

struct CommentCommand: AppCommand {
    let id: Int64
    let cid: Int64
    let content: String
    let type: NeteaseCloudMusicApi.CommentType
    let action: NeteaseCloudMusicApi.CommentAction
    
    func execute(in store: Store) {
        NeteaseCloudMusicApi.shared.comment(id: id, cid: cid, content: content,type: type, action: action) { result in
            switch result {
            case .success(let json):
                if json["code"] as! Int == 200 {
                    let args = (id, cid, type , action)
                    store.dispatch(.commentDoneRequest(result: .success(args)))
                }
            case .failure(let error):
                store.dispatch(.commentDoneRequest(result: .failure(error)))
            }
        }
    }
}

struct CommentDoneCommand: AppCommand {
    let id: Int64
    let type: NeteaseCloudMusicApi.CommentType
    let action: NeteaseCloudMusicApi.CommentAction

    func execute(in store: Store) {
        if type == .song {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                store.dispatch(.commentMusicRequest(id: id))
            }
        }
    }
}

struct CommentLikeCommand: AppCommand {
    let id: Int64
    let cid: Int64
    let like: Bool
    let type: NeteaseCloudMusicApi.CommentType
    
    func execute(in store: Store) {
        NeteaseCloudMusicApi.shared.commentLike(id: id, cid: cid, like: like, type: type) { result in
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
    let id: Int64
    let limit: Int
    let offset: Int
    let beforeTime: Int
    
    init(id: Int64 = 0, limit: Int = 20, offset: Int = 0, beforeTime: Int = 0) {
        self.id = id
        self.limit = limit
        self.offset = offset
        self.beforeTime = beforeTime
    }
    
    func execute(in store: Store) {
        NeteaseCloudMusicApi.shared.commentMusic(id: id, limit: limit, offset: offset, beforeTime: beforeTime) { result in
            switch result {
            case .success(let json):
                if json["code"] as! Int == 200 {
                    var hotComments = [CommentJSONModel]()
                    var comments = [CommentJSONModel]()
                   
                    if let hotCommentsArray = json["hotComments"] as? [NeteaseCloudMusicApi.ResponseData] {
                        hotComments = hotCommentsArray.map({$0.toData!.toModel(CommentJSONModel.self)!})
                    }
                    if let commentsArray = json["comments"] as? [NeteaseCloudMusicApi.ResponseData] {
                        comments = commentsArray.map({$0.toData!.toModel(CommentJSONModel.self)!})
                    }
                    let total = json["total"] as! Int
                    store.dispatch(.commentMusicRequestDone(result: .success((hotComments,comments,total))))
                }else {
                    store.dispatch(.commentMusicRequestDone(result: .failure(.commentMusic)))
                }
            case .failure(let error):
                store.dispatch(.commentMusicRequestDone(result: .failure(error)))
            }
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
                guard loginRefreshResponse.code == 200 else {
                    store.dispatch(.loginRefreshRequestDone(result: .success(false)))
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
            } receiveValue: { mvDetailResponse in
                store.dispatch(.mvDetaillRequestDone(result: .success(id)))
            }.store(in: &store.cancellableSet)
    }
}

struct MVDetailDoneCommand: AppCommand {
    let id: Int64
    
    func execute(in store: Store) {
//        NeteaseCloudMusicApi.shared.mvDetail(id: id) { (data, error) in
//            guard error == nil else {
//                if let err = error {
//                    store.dispatch(.mvDetaillDone(result: .failure(err)))
//                }
//                return
//            }
//            if data?["code"] as? Int == 200 {
//                if let mvDict = data?["data"] as? [String: Any] {
//                    if let mvJSONModel = mvDict.toData?.toModel(MVJSONModel.self) {
//                        print(mvJSONModel)
//                        store.dispatch(.mvDetaillDone(result: .success(mvJSONModel)))
//                    }
//                }
//            }else if let data = data {
//                let (code, message) = NeteaseCloudMusicApi.parseErrorMessage(data)
//                store.dispatch(.mvDetaillDone(result: .failure(.mvDetailError(code: code, message: message))))
//            }
//        }
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
            store.dispatch(.playerPlayByIndex(index: index))
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
            store.dispatch(.playerPlayByIndex(index: index))
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
        store.dispatch(.playerPlayByIndex(index: index))
    }
}

struct PlaylistCategoriesCommand: AppCommand {
    func execute(in store: Store) {
        NeteaseCloudMusicApi
            .shared
            .requestPublisher(action: PlaylistCatalogueAction())
            .sink { completion in
                if case .failure(let error) = completion {
                    store.dispatch(.playlistCatalogueRequestsDone(result: .failure(AppError.neteaseCloudMusic(error: error))))
                }
            } receiveValue: { playlistCatalogueResponse in
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
                store.dispatch(.playlistCreateRequestDone(result: .success(playlistCreateResponse.playlist.id)))
            }.store(in: &store.cancellableSet)
    }
}

struct PlaylistCreateDoneCommand: AppCommand {
    
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

struct PlaylistDeleteDoneCommand: AppCommand {
    
    func execute(in store: Store) {
        store.dispatch(.userPlaylistRequest())
    }
}

struct PlaylistDetailCommand: AppCommand {
    let id: Int
    
    func execute(in store: Store) {
        NeteaseCloudMusicApi
            .shared
            .requestPublisher(action: PlaylistDetailAction(parameters: .init(id: id)))
            .sink { completion in
                if case .failure(let error) = completion {
                    store.dispatch(.playlistDetailDone(result: .failure(AppError.neteaseCloudMusic(error: error))))
                }
            } receiveValue: { playlistDetailResponse in
                DataManager.shared.update(model: playlistDetailResponse.playlist)
                store.dispatch(.playlistDetailDone(result: .success(playlistDetailResponse.playlist)))
            }.store(in: &store.cancellableSet)
    }
}

struct PlaylistDetailDoneCommand: AppCommand {
    let playlist: PlaylistResponse
    
    func execute(in store: Store) {
        store.dispatch(.playlistDetailSongs(playlist: playlist))
    }
}

struct PlaylistDetailSongsCommand: AppCommand {
    let playlist: PlaylistResponse
    
    func execute(in store: Store) {
        if let ids = playlist.trackIds?.map(\.id) {
            NeteaseCloudMusicApi
                .shared
                .requestPublisher(action: SongDetailAction(parameters: .init(ids: ids)))
                .sink { completion in
                    if case .failure(let error) = completion {
                        store.dispatch(.playlistDetailSongsDone(result: .failure(AppError.neteaseCloudMusic(error: error))))
                    }
                } receiveValue: { playlistDetailResponse in
                    DataManager.shared.batchInsert(type: Song.self, models: playlistDetailResponse.songs)
                    DataManager.shared.updatePlaylistSongs(id: playlist.id, songsId: ids)
                    store.dispatch(.playlistDetailSongsDone(result: .success(ids)))
                }.store(in: &store.cancellableSet)
        }
    }
}

struct PlaylistOrderUpdateCommand: AppCommand {
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

struct PlaylistOrderUpdateDoneCommand: AppCommand {
    func execute(in store: Store) {
        store.dispatch(.userPlaylistRequest())
    }
}

struct PlaylisSubscribeCommand: AppCommand {
    let id: Int64
    let sub: Bool
    
    func execute(in store: Store) {
        NeteaseCloudMusicApi.shared.playlistSubscribe(id: id, sub: sub) { result in
            switch result {
            case .success(let json):
                if json["code"] as! Int == 200 {
                    store.dispatch(.playlistSubscibeDone(result: .success(id)))
                }else {
                    store.dispatch(.playlistSubscibeDone(result: .failure(.playlistSubscribeError)))
                }
            case .failure(let error):
                store.dispatch(.playlistSubscibeDone(result: .failure(error)))
            }
        }
    }
}

struct PlaylisSubscribeDoneCommand: AppCommand {
    let id: Int64
    
    func execute(in store: Store) {
        store.dispatch(.playlistDetail(id: Int(id)))
        store.dispatch(.userPlaylistRequest())
    }
}

struct PlaylistTracksCommand: AppCommand {
    let pid: Int64
    let op: Bool
    let ids: [Int64]
    
    func execute(in store: Store) {
        NeteaseCloudMusicApi.shared.playlistTracks(pid: pid, op: op, ids: ids) { result in
            switch result {
            case .success(let json):
                if json["code"] as! Int == 200 {
                    store.dispatch(.playlistTracksDone(result: .success(pid)))
                }else {
                    store.dispatch(.playlistTracksDone(result: .failure(.playlistTracksError(code: json["code"] as! Int, message: json["message"] as! String))))
                }
            case .failure(let error):
                store.dispatch(.playlistTracksDone(result: .failure(error)))
            }
        }
    }
}

struct PlaylistTracksDoneCommand: AppCommand {
    let id: Int64
    
    func execute(in store: Store) {
        store.dispatch(.playlistDetail(id: Int(id)))
        store.dispatch(.userPlaylistRequest())
    }
}

struct RecommendPlaylistCommand: AppCommand {
    func execute(in store: Store) {
        NeteaseCloudMusicApi.shared.recommendResource { result in
            switch result {
            case .success(let json):
                if json["code"] as! Int == 200 {
                    if let playlistDicts = json["recommend"] as? [NeteaseCloudMusicApi.ResponseData] {

                        let playlistModels = playlistDicts.map{$0.toData!.toModel(RecommendPlaylistModel.self)!}
                        do {
                            let data = try JSONEncoder().encode(playlistModels)
                            let objects = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)  as! [[String: Any]]
                            DataManager.shared.batchInsertAfterDeleteAll(entityName: "RecommendPlaylist", objects: objects)
                        }catch let error {
                            print("\(#function) \(error)")
                        }
                        store.dispatch(.recommendPlaylistDone(result: .success(playlistModels.map{$0.id})))
                    }
                }else {
                    store.dispatch(.recommendPlaylistDone(result: .failure(.playlistDetailError)))
                }
            case .failure(let error):
                store.dispatch(.recommendPlaylistDone(result: .failure(error)))
            }
        }
    }
}

struct RecommendPlaylistDoneCommand: AppCommand {
    func execute(in store: Store) {
    }
}

struct RecommendSongsCommand: AppCommand {
    func execute(in store: Store) {
        NeteaseCloudMusicApi.shared.recommendSongs { result in
            switch result {
            case .success(let json):
                if json["code"] as! Int == 200 {
                    if let recommendSongDicts = json["data"] as? NeteaseCloudMusicApi.ResponseData {
                        let recommendSongsJSONModel = recommendSongDicts.toData!.toModel(RecommendSongsJSONModel.self)!
                        DataManager.shared.updateRecommendSongsPlaylist(recommendSongsJSONModel: recommendSongsJSONModel)
                        DataManager.shared.updateSongs(songsJSONModel: recommendSongsJSONModel.dailySongs)
                        DataManager.shared.updateRecommendSongsPlaylistSongs(ids: recommendSongsJSONModel.dailySongs.map{ Int($0.id) })
                        store.dispatch(.recommendSongsDone(result: .success(recommendSongsJSONModel)))
                    }
                }else {
                    store.dispatch(.recommendSongsDone(result: .failure(.playlistDetailError)))
                }
            case .failure(let error):
                store.dispatch(.recommendSongsDone(result: .failure(error)))
            }
        }
    }
}

struct RecommendSongsDoneCommand: AppCommand {
    let playlist: PlaylistViewModel
    
    func execute(in store: Store) {
        store.dispatch(.songsDetail(ids: playlist.songsId.map(Int.init)))
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
        NeteaseCloudMusicApi.shared.search(keyword: keyword, type: type, limit: limit, offset: offset) { result in
            switch result {
            case .success(let json):
                if let result = json["result"] as? [String: Any] {
                    if let songsDict = result["songs"] as? [[String: Any]] {
                        let songsJSONModel = songsDict.map{$0.toData!.toModel(SearchSongJSONModel.self)!}
                        store.dispatch(.searchSongDone(result: .success(songsJSONModel.map{$0.id})))
                    }
                    if let playlists = result["playlists"] as? [[String: Any]] {
                        let playlistsViewModel = playlists.map{$0.toData!.toModel(SearchPlaylistJSONModel.self)!}.map{PlaylistViewModel($0)}
                        store.dispatch(.searchPlaylistDone(result: .success(playlistsViewModel)))
                    }
                }else {
                    store.dispatch(.searchSongDone(result: .failure(.songsDetailError)))
                }
            case .failure(let error):
                store.dispatch(.searchSongDone(result: .failure(error)))
            }
        }
    }
}

struct SearchSongDoneCommand: AppCommand {
    let ids: [Int64]
    
    func execute(in store: Store) {
        store.dispatch(.songsDetail(ids: ids.map(Int.init)))
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
                    store.dispatch(.songsDetailDone(result: .failure(AppError.neteaseCloudMusic(error: error))))
                }
            } receiveValue: { songDetailResponse in
                DataManager.shared.batchInsert(type: Song.self, models: songDetailResponse.songs)
                store.dispatch(.songsDetailDone(result: .success(ids)))
            }.store(in: &store.cancellableSet)

//        NeteaseCloudMusicApi.shared.songsDetail(ids: ids) { result in
//            switch result {
//            case .success(let json):
//                if let songsDict = json["songs"] as? [[String: Any]] {
//                    let songsJSONModel = songsDict.map{$0.toData!.toModel(SongDetailJSONModel.self)!}
//                    DataManager.shared.updateSongs(songsJSONModel: songsJSONModel)
//                    store.dispatch(.songsDetailDone(result: .success(songsJSONModel)))
//                }else {
//                    store.dispatch(.songsDetailDone(result: .failure(.songsDetailError)))
//                }
//            case .failure(let error):
//                store.dispatch(.songsDetailDone(result: .failure(error)))
//            }
//        }
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
        } receiveValue: { likeSongResponse in
            store.dispatch(.songLikeRequestDone(result: .success(like)))
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

struct SongsOrderUpdateCommand: AppCommand {
    let pid: Int64
    let ids: [Int64]
    
    func execute(in store: Store) {
        NeteaseCloudMusicApi.shared.songsOrderUpdate(pid: pid, ids: ids) { result in
            switch result {
            case .success(let json):
                if json["code"] as? Int == 200 {
                    store.dispatch(.songsOrderUpdateDone(result: .success(pid)))
                }else {
                    store.dispatch(.songsOrderUpdateDone(result: .failure(.playlistOrderUpdateError(code: json["code"] as! Int, message: json["message"] as! String))))
                }
            case .failure(let error):
                store.dispatch(.songsOrderUpdateDone(result: .failure(error)))
            }
        }
    }
}

struct SongsOrderUpdateDoneCommand: AppCommand {
    let id: Int64
    
    func execute(in store: Store) {
        store.dispatch(.playlistDetail(id: Int(id)))
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
            store.dispatch(.playerPlayByIndex(index: store.appState.playing.index))
            return
        }
        if Player.shared.isPlaying {
            store.dispatch(.playerPause)
        }else {
            store.dispatch(.playerPlay)
        }
    }
}

struct UserPlayListCommand: AppCommand {
    let uid: Int
    let limit: Int
    let offset: Int
    
    func execute(in store: Store) {
        NeteaseCloudMusicApi
            .shared
            .requestPublisher(action: UserPlaylistAction(parameters: .init(uid: uid, limit: limit, offset: offset)))
            .sink { completion in
            if case .failure(let error) = completion {
                store.dispatch(.userPlaylistDone(result: .failure(AppError.neteaseCloudMusic(error: error))))
            }
        } receiveValue: { userPlaylistResponse in
            store.dispatch(.userPlaylistDone(result: .success(userPlaylistResponse.playlist)))
        }.store(in: &store.cancellableSet)
    }
}
