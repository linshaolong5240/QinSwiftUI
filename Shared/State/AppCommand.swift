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
                store.dispatch(.artistIntroductionRequestDone(result: .success(introduction)))
                DataManager.shared.updateArtistHotSongs(to: id, songsId: artistHotSongsResponse.hotSongs.map({ $0.id }))
                store.dispatch(.artistRequestDone(result: .success(artistHotSongsResponse.hotSongs.map({ $0.id }))))
            }.store(in: &store.cancellableSet)

//        NeteaseCloudMusicApi
//            .shared
//            .requestPublisher(action: ArtistHotSongsAction(id: id))
//            .sink { completion in
//                if case .failure(let error) = completion {
//                    store.dispatch(.artistRequestDone(result: .failure(AppError.neteaseCloudMusic(error: error))))
//                }
//            } receiveValue: { artistHotSongsResponse in
//                DataManager.shared.updateArtist(model: artistHotSongsResponse.artist)
//                store.dispatch(.artistRequestDone(result: .success(artistHotSongsResponse.hotSongs.map({ $0.id }))))
//            }.store(in: &store.cancellableSet)
        //        NeteaseCloudMusicApi.shared.artists(id: id) { result in
        //            switch result {
        //            case .success(let json):
        //                print(json.toJSONString)
        //                if json["code"] as? Int == 200 {
        //                    let artistDict = json["artist"] as! [String: Any]
        //                    let artistJSONModel = artistDict.toData!.toModel(ArtistJSONModel.self)!
        //                    let hotSongsDictArray = json["hotSongs"] as! [[String: Any]]
        //                    let songsJSONModel = hotSongsDictArray.map{$0.toData!.toModel(SongJSONModel.self)!}
        //                    DataManager.shared.updateArtist(artistJSONModel: artistJSONModel)
        //                    DataManager.shared.updateSongs(songsJSONModel: songsJSONModel)
        //                    DataManager.shared.updateArtistSongs(id: artistJSONModel.id, songsId: songsJSONModel.map{ $0.id })
        //                    store.dispatch(.artistRequestDone(result: .success(artistJSONModel)))
        //                }else {
        //                    let code = json["code"] as? Int ?? -1
        //                    let message = json["message"] as? String ?? "错误信息解码错误"
        //                    store.dispatch(.artistRequestDone(result: .failure(.comment(code: code, message: message))))
        //                }
        //            case .failure(let error):
        //                store.dispatch(.artistRequestDone(result: .failure(error)))
        //            }
        //        }
//        NeteaseCloudMusicApi
//            .shared
//            .requestPublisher(action: ArtistIntroductionAction(parameters: .init(id: id)))
//            .sink { completion in
//                if case .failure(let error) = completion {
//                    store.dispatch(.artistIntroductionRequestDone(result: .failure(AppError.neteaseCloudMusic(error: error))))
//                }
//            } receiveValue: { artistIntroductionResponse in
//                let introduction = artistIntroductionResponse.desc
//                DataManager.shared.updateArtistIntroduction(id: Int64(id), introduction: introduction)
//                store.dispatch(.artistIntroductionRequestDone(result: .success(introduction)))
//            }.store(in: &store.cancellableSet)
//        NeteaseCloudMusicApi.shared.artistIntroduction(id: Int64(id)) { result in
//            switch result {
//            case .success(let json):
//                print(json.toJSONString)
//                if json["code"] as? Int == 200 {
//                    let introduction = json["briefDesc"] as? String
//                    DataManager.shared.updateArtistIntroduction(id: Int64(id), introduction: introduction)
//                    store.dispatch(.artistIntroductionRequestDone(result: .success(introduction)))
//                }else {
//                    let code = json["code"] as? Int ?? -1
//                    let message = json["message"] as? String ?? "错误信息解码错误"
//                    store.dispatch(.artistIntroductionRequestDone(result: .failure(.comment(code: code, message: message))))
//                }
//            case .failure(let error):
//                store.dispatch(.artistIntroductionRequestDone(result: .failure(error)))
//            }
//        }
    }
}

struct ArtistDoneCommand: AppCommand {
    let artist: ArtistJSONModel
    
    func execute(in store: Store) {
        let id = artist.id
        store.dispatch(.artistAlbumRequest(id: id))
        store.dispatch(.artistIntroductionRequest(id: id))
        store.dispatch(.artistMvRequest(id: id))
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

struct ArtistIntroductionRequestCommand: AppCommand {
    let id: Int64
    
    func execute(in store: Store) {
//        NeteaseCloudMusicApi.shared.artistIntroduction(id: id) { result in
//            switch result {
//            case .success(let json):
//                if json["code"] as? Int == 200 {
//                    let introduction = json["briefDesc"] as? String
//                    DataManager.shared.updateArtistIntroduction(id: Int(id), introduction: introduction)
//                    store.dispatch(.artistIntroductionRequestDone(result: .success(introduction)))
//                }else {
//                    let code = json["code"] as? Int ?? -1
//                    let message = json["message"] as? String ?? "错误信息解码错误"
//                    store.dispatch(.artistIntroductionRequestDone(result: .failure(.comment(code: code, message: message))))
//                }
//            case .failure(let error):
//                store.dispatch(.artistIntroductionRequestDone(result: .failure(error)))
//            }
//        }
    }
}

struct ArtistMVCommand: AppCommand {
    let id: Int64
    let limit: Int
    let offset: Int
    
    init(id: Int64, limit: Int = 30, offset: Int = 0) {
        self.id = id
        self.limit = limit
        self.offset = offset
    }
    func execute(in store: Store) {
        NeteaseCloudMusicApi.shared.artistMV(id: id, limit: limit, offset: offset) { result in
            switch result {
            case .success(let json):
                if json["code"] as? Int == 200 {
                    if let mvsDict = json["mvs"] as? [[String: Any]] {
                        let mvsJSONModel = mvsDict.map{$0.toData!.toModel(ArtistMVJSONModel.self)!}
                        DataManager.shared.updateMvs(mvsJSONModel: mvsJSONModel)
                        DataManager.shared.updateArtistMVs(id: id, mvIds: mvsJSONModel.map{ $0.id })
                        store.dispatch(.artistMvRequestDone(result: .success(mvsJSONModel)))
                    }
                }else {
                    let (code,message) = NeteaseCloudMusicApi.parseErrorMessage(json)
                    store.dispatch(.artistMvRequestDone(result: .failure(.artistMV(code: code, message: message))))
                }
            case .failure(let error):
                store.dispatch(.artistMvRequestDone(result: .failure(error)))
            }
        }
    }
}

struct ArtistSubCommand: AppCommand {
    let id: Int64
    let sub: Bool
    
    func execute(in store: Store) {
        NeteaseCloudMusicApi.shared.artistSub(id: id, sub: sub) { result in
            switch result {
            case .success(let json):
                if json["code"] as? Int == 200 {
                    store.dispatch(.artistSubRequestDone(result: .success(true)))
                }else {
                    let code = json["code"] as? Int ?? -1
                    let message = json["message"] as? String ?? "错误信息解码错误"
                    store.dispatch(.artistSubRequestDone(result: .failure(.artistSub(code: code, message: message))))
                }
            case .failure(let error):
                store.dispatch(.artistSubRequestDone(result: .failure(error)))
            }
        }
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

struct InitAcionCommand: AppCommand {
    func execute(in store: Store) {
        store.appState.initRequestingCount += 1
        store.dispatch(.albumSublistRequest())
        
        store.appState.initRequestingCount += 1
        store.dispatch(.artistSublistRequest())
        
        store.appState.initRequestingCount += 1
        store.dispatch(.likelistRequest())
        
        store.appState.initRequestingCount += 1
        store.dispatch(.playlistCategories)
        
        store.appState.initRequestingCount += 1
        store.dispatch(.recommendPlaylist)
        
        store.appState.initRequestingCount += 1
        store.dispatch(.recommendSongs)
        
        store.appState.initRequestingCount += 1
        store.dispatch(.userPlaylist())
    }
}

struct LikeRequestCommand: AppCommand {
    let id: Int64
    let like: Bool
    
    func execute(in store: Store) {
        NeteaseCloudMusicApi.shared.like(id: id, like: like) { result in
            switch result {
            case .success(let json):
                if json["code"] as! Int == 200 {
                    store.dispatch(.likeRequestDone(result: .success(like)))
                }else {
                    store.dispatch(.likeRequestDone(result: .failure(.like)))
                }
            case .failure(let error):
                store.dispatch(.likeRequestDone(result: .failure(error)))
            }
        }
    }
}

struct LikeRequestDoneCommand: AppCommand {

    func execute(in store: Store) {
        if let uid = store.appState.settings.loginUser?.profile.userId {
            store.dispatch(.likelistRequest(uid: Int64(uid)))
        }
    }
}

struct LikeListRequestCommand: AppCommand {
    let uid: Int
    
    func execute(in store: Store) {
        NeteaseCloudMusicApi.shared.likeList(uid: uid) { result in
            switch result {
            case .success(let json):
                if json["code"] as! Int == 200 {
                    let likelist = json["ids"] as! [Int64]
                    
                    store.dispatch(.likelistRequestDone(result: .success(likelist)))
                }else {
                    store.dispatch(.likelistRequestDone(result: .failure(.likelist)))
                }
            case .failure(let error):
                store.dispatch(.likelistRequestDone(result: .failure(error)))
            }
        }
    }
}

struct LyricRequestCommand: AppCommand {
    let id: Int64
    func execute(in store: Store) {
        NeteaseCloudMusicApi.shared.lyric(id: id) { result in
            switch result {
            case .success(let json):
                if json["code"] as! Int == 200 {
                    if let lrc = json["lrc"] as? NeteaseCloudMusicApi.ResponseData {
                        let lyric = lrc["lyric"] as! String
                        store.dispatch(.lyricRequestDone(result: .success(lyric)))
                    }else {
                        store.dispatch(.lyricRequestDone(result: .success(nil)))
                    }
                }else {
                    store.dispatch(.lyricRequestDone(result: .failure(.lyricError)))
                }
            case .failure(let error):
                store.dispatch(.lyricRequestDone(result: .failure(error)))
            }
        }
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
//        NeteaseCloudMusicApi.shared.login(email: email, password: password) { result in
//            switch result {
//            case .success(let json):
//                print(json.toJSONString)
//                if json["code"] as? Int == 200 {
//                    var user = User()
//                    if let accountDict = json["account"] as? NeteaseCloudMusicApi.ResponseData {
//                        user.account = accountDict.toData!.toModel(Account.self)!
//                    }
//                    user.csrf = NeteaseCloudMusicApi.shared.getCSRFToken()
//                    user.loginType = json["loginType"] as! Int
//                    if let profile = json["profile"] as? NeteaseCloudMusicApi.ResponseData {
//                        user.profile = profile.toData!.toModel(Profile.self)!
//                        user.uid = profile["userId"] as! Int64
//                    }
//                    store.dispatch(.loginRequestDone(result: .success(user)))
//                }else {
//                    store.dispatch(.loginRequestDone(result: .failure(.loginError(code: json["code"] as! Int, message: json["message"] as! String))))
//                }
//            case .failure(let error):
//                store.dispatch(.loginRequestDone(result: .failure(error)))
//            }
//
//        }
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
        NeteaseCloudMusicApi.shared.loginRefresh{ result in
            switch result {
            case .success(let json):
                if json["code"] as? Int == 200 {
                    store.dispatch(.loginRefreshRequestDone(result: .success(true)))
                }else {
                    store.dispatch(.loginRefreshRequestDone(result: .success(false)))
                }
            case .failure(let error):
                store.dispatch(.loginRefreshRequestDone(result: .failure(error)))
            }
        }
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
    let id: Int64
    
    func execute(in store: Store) {
        NeteaseCloudMusicApi.shared.mvDetail(id: id) { result in
            switch result {
            case .success(let json):
                if let mvDict = json["data"] as? [String: Any] {
                    if let mvJSONModel = mvDict.toData?.toModel(MVJSONModel.self) {
                        store.dispatch(.mvDetaillRequestDone(result: .success(mvJSONModel)))
                    }
                }
            case .failure(let error):
                store.dispatch(.mvDetaillRequestDone(result: .failure(error)))
            }
        }
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
    let id: Int64
    
    func execute(in store: Store) {
        NeteaseCloudMusicApi.shared.mvUrl(id: id) { result in
//            print(data)
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
        }
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
    let id: Int64
    
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
        NeteaseCloudMusicApi.shared.songsURL([id]) { result in
            switch result {
            case .success(let json):
                if let songsURLDict = json["data"] as? [NeteaseCloudMusicApi.ResponseData] {
                    if songsURLDict.count > 0 {
                        store.dispatch(.playerPlayRequestDone(result: .success(songsURLDict[0].toData!.toModel(SongURLJSONModel.self)!)))
                    }
                }else {
                    store.dispatch(.playerPlayRequestDone(result: .failure(.songsURLError)))
                }
            case .failure(let error):
                store.dispatch(.playerPlayRequestDone(result: .failure(error)))
            }
        }
    }
}

struct PlayerPlayRequestDoneCommand: AppCommand {
    let url: String
    
    func execute(in store: Store) {
        let index = store.appState.playing.index
        let songId = store.appState.playing.playinglist[index]
        store.dispatch(.lyricRequest(id: songId))
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

struct PlaylistCommand: AppCommand {
    let cat: String
    let hot: Bool
    let limit: Int
    let offset: Int
    
    func execute(in store: Store) {
        NeteaseCloudMusicApi.shared.playlist(cat: cat, hot: hot, limit: limit, offset: offset) { result in
            switch result {
            case .success(let json):
                if json["code"] as! Int == 200 {
                    let playlistDicts = json["playlists"]! as! [NeteaseCloudMusicApi.ResponseData]
                    let playlists = playlistDicts.map{$0.toData!.toModel(PlaylistJSONModel.self)!}.map{PlaylistViewModel($0)}
                    let category = json["cat"]! as! String
                    let more = json["more"]! as! Bool
                    let total = json["total"] as! Int
                    let result = (playlists: playlists, category: category, total: total , more: more)
                    store.dispatch(.playlistDone(result: .success(result)))
                }else {
                    let code = json["code"] as? Int ?? -1
                    let message = json["message"] as? String ?? "PlaylistCommandError"
                    store.dispatch(.playlistDone(result: .failure(.playlistCategories(code: code, message: message))))
                }
            case .failure(let error):
                store.dispatch(.playlistDone(result: .failure(error)))
            }
        }
    }
}

struct PlaylistCategoriesCommand: AppCommand {
    func execute(in store: Store) {
        NeteaseCloudMusicApi.shared.playlistCategories { result in
            switch result {
            case .success(let json):
                let alldict = json["all"] as! NeteaseCloudMusicApi.ResponseData
                let all = alldict.toData!.toModel(PlaylistSubCategory.self)!
                
                let categoriesdict = json["categories"] as! [String: Any]
                let categoriesModel = categoriesdict.toData!.toModel(PlaylistCategoryJSONModel.self)!

                let subcategoriesdict = json["sub"] as! [[String: Any]]
                let subcategories = subcategoriesdict.map{$0.toData!.toModel(PlaylistSubCategory.self)!}
                
                let categoriesMirror = Mirror(reflecting: categoriesModel)
                
                var categories = categoriesMirror.children.map{ children -> PlaylistCategoryViewModel in
                    var id: Int
                    switch children.label {
                    case "_0":
                        id = 0
                    case "_1":
                        id = 1
                    case "_2":
                        id = 2
                    case "_3":
                        id = 3
                    case "_4":
                        id = 4
                    default:
                        id = 5
                    }
                    let name = children.value as! String
                    let subs = subcategories.filter { (sub) -> Bool in
                        sub.category == id
                    }.map { c in
                        return c.name
                    }
                    return PlaylistCategoryViewModel(id: id, name: name, subCategories: subs)
                }
                categories.append(PlaylistCategoryViewModel(id: all.category + 1, name: all.name, subCategories: [String]()))
                store.dispatch(.playlistCategoriesDone(result: .success(categories)))
            case .failure(let error):
                store.dispatch(.playlistCategoriesDone(result: .failure(error)))
            }
        }
    }
}

struct PlaylistCategoriesDoneCommand: AppCommand {
    let category: String
    
    func execute(in store: Store) {
            store.dispatch(.playlist(category: category))
    }
}

struct PlaylistCreateCommand: AppCommand {
    let name: String
    let privacy: Int
    
    func execute(in store: Store) {
        NeteaseCloudMusicApi.shared.playlistCreate(name: name, privacy: privacy) { result in
            switch result {
            case .success(let json):
                if json["code"] as! Int == 200 {
                    store.dispatch(.playlistCreateDone(result: .success(true)))
                }else {
                    store.dispatch(.playlistCreateDone(result: .failure(.playlistCreateError)))
                }
            case .failure(let error):
                store.dispatch(.playlistCreateDone(result: .failure(error)))
            }
        }
    }
}

struct PlaylistCreateDoneCommand: AppCommand {
    
    func execute(in store: Store) {
        store.dispatch(.userPlaylist())
    }
}

struct PlaylistDeleteCommand: AppCommand {
    let pid: Int64
    
    func execute(in store: Store) {
        NeteaseCloudMusicApi.shared.playlistDelete(pid: pid) { result in
            switch result {
            case .success(let json):
                if json["code"] as! Int == 200 {
                    store.dispatch(.playlistDeleteDone(result: .success(json["id"] as! Int64)))
                }else {
                    store.dispatch(.playlistDeleteDone(result: .failure(.playlistDeleteError)))
                }
            case .failure(let error):
                store.dispatch(.playlistDeleteDone(result: .failure(error)))
            }
        }
    }
}

struct PlaylistDeleteDoneCommand: AppCommand {
    
    func execute(in store: Store) {
        store.dispatch(.userPlaylist())
    }
}

struct PlaylistDetailCommand: AppCommand {
    let id: Int64
    
    func execute(in store: Store) {
        NeteaseCloudMusicApi.shared.playlistDetail(id: id) { result in
            switch result {
            case .success(let json):
                if json["code"] as! Int == 200 {
                    if let playlistDict = json["playlist"] as? NeteaseCloudMusicApi.ResponseData {
                        let playlistJSONModel = playlistDict.toData!.toModel(PlaylistJSONModel.self)!
                        DataManager.shared.updatePlaylist(playlistJSONModel: playlistJSONModel)
                        store.dispatch(.playlistDetailDone(result: .success(playlistJSONModel)))
                    }
                }else {
                    store.dispatch(.playlistDetailDone(result: .failure(.playlistDetailError)))
                }
            case .failure(let error):
                store.dispatch(.playlistDetailDone(result: .failure(error)))
            }
        }
    }
}

struct PlaylistDetailDoneCommand: AppCommand {
    let playlistJSONModel: PlaylistJSONModel
    
    func execute(in store: Store) {
        store.dispatch(.playlistDetailSongs(playlistJSONModel: playlistJSONModel))
    }
}

struct PlaylistDetailSongsCommand: AppCommand {
    let playlistJSONModel: PlaylistJSONModel
    
    func execute(in store: Store) {
        if let ids = playlistJSONModel.trackIds?.map({$0.id}) {
            NeteaseCloudMusicApi.shared.songsDetail(ids: ids) { result in
                switch result {
                case .success(let json):
                    if let songsDict = json["songs"] as? [[String: Any]] {
                        let songsDetailJSONModel = songsDict.map{$0.toData!.toModel(SongDetailJSONModel.self)!}
                        let songsId = songsDetailJSONModel.map{$0.id}
                        DataManager.shared.updateSongs(songsJSONModel: songsDetailJSONModel)
                        DataManager.shared.updatePlaylistSongs(id: Int(playlistJSONModel.id), songsId: songsId.map({ Int($0) }))
                        store.dispatch(.playlistDetailSongsDone(result: .success(songsId)))
                    }else {
                        store.dispatch(.playlistDetailSongsDone(result: .failure(.songsDetailError)))
                    }
                case .failure(let error):
                    store.dispatch(.playlistDetailSongsDone(result: .failure(error)))
                }
            }
        }
    }
}

//struct PlaylistDetailSongsDoneCommand: AppCommand {
//    let playlistJSONModel: PlaylistJSONModel
//
//    func execute(in store: Store) {
//    }
//}

struct PlaylistOrderUpdateCommand: AppCommand {
    let ids: [Int64]
    
    func execute(in store: Store) {
        NeteaseCloudMusicApi.shared.playlistOrderUpdate(ids: ids) { result in
            switch result {
            case .success(let json):
                if json["code"] as? Int == 200 {
                    store.dispatch(.playlistOrderUpdateDone(result: .success(true)))
                }else {
                    store.dispatch(.playlistOrderUpdateDone(result: .failure(.playlistOrderUpdateError(code: json["code"] as! Int, message: json["msg"] as! String))))
                }
            case .failure(let error):
                store.dispatch(.playlistOrderUpdateDone(result: .failure(error)))
            }
        }
    }
}

struct PlaylistOrderUpdateDoneCommand: AppCommand {
    func execute(in store: Store) {
        store.dispatch(.userPlaylist())
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
        store.dispatch(.playlistDetail(id: id))
        store.dispatch(.userPlaylist())
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
        store.dispatch(.playlistDetail(id: id))
        store.dispatch(.userPlaylist())
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
        store.dispatch(.songsDetail(ids: playlist.songsId))
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
        store.dispatch(.songsDetail(ids: ids))
    }
}

struct SongsDetailCommand: AppCommand {
    let ids: [Int64]
    
    func execute(in store: Store) {
        NeteaseCloudMusicApi.shared.songsDetail(ids: ids) { result in
            switch result {
            case .success(let json):
                if let songsDict = json["songs"] as? [[String: Any]] {
                    let songsJSONModel = songsDict.map{$0.toData!.toModel(SongDetailJSONModel.self)!}
                    DataManager.shared.updateSongs(songsJSONModel: songsJSONModel)
                    store.dispatch(.songsDetailDone(result: .success(songsJSONModel)))
                }else {
                    store.dispatch(.songsDetailDone(result: .failure(.songsDetailError)))
                }
            case .failure(let error):
                store.dispatch(.songsDetailDone(result: .failure(error)))
            }
        }
    }
}

struct SongsDetailDoneCommand: AppCommand {
    let songsJSONModel: [SongDetailJSONModel]
    
    func execute(in store: Store) {
        DataManager.shared.updateSongs(songsJSONModel: songsJSONModel)
//        store.dispatch(.songsURL(ids: songs.map{$0.id}))
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
        store.dispatch(.playlistDetail(id: id))
    }
}

struct SongsURLCommand: AppCommand {
    let ids: [Int64]
    
    func execute(in store: Store) {
        NeteaseCloudMusicApi.shared.songsURL(ids) { result in
            switch result {
            case .success(let json):
                if let songsURLDict = json["data"] as? [NeteaseCloudMusicApi.ResponseData] {
                    if songsURLDict.count > 0 {
                        store.dispatch(.songsURLDone(result: .success(songsURLDict.map{$0.toData!.toModel(SongURLJSONModel.self)!})))
                    }
                }else {
                    store.dispatch(.songsURLDone(result: .failure(.songsURLError)))
                }
            case .failure(let error):
                store.dispatch(.songsURLDone(result: .failure(error)))
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
    
    func execute(in store: Store) {
        NeteaseCloudMusicApi.shared.userPlayList(uid) { result in
            switch result {
            case .success(let json):
                if json["code"] as! Int == 200 {
                    if let playlistDicts = json["playlist"] as? [NeteaseCloudMusicApi.ResponseData] {
                        let playlistModels = playlistDicts.map{$0.toData!.toModel(UserPlaylistModel.self)!}
                        do {
                            let data = try JSONEncoder().encode(playlistModels)
                            let objects = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)  as! [[String: Any]]
                            let createdPlaylistIds = playlistModels.filter { $0.userId == uid }.map { $0.id }
                            let subedPlaylistIds = playlistModels.filter { $0.userId != uid }.map { $0.id }
                            let userPlaylistIds = playlistModels.map{ $0.id }
                            let result = (createdPlaylistId: createdPlaylistIds, subedPlaylistIds: subedPlaylistIds, userPlaylistIds: userPlaylistIds)
                            DataManager.shared.batchInsertAfterDeleteAll(entityName: "UserPlaylist", objects: objects)
                            store.dispatch(.userPlaylistDone(result: .success(result)))
                        }catch let error {
                            print("\(#function) \(error)")
                        }
                    }
                }else {
                    store.dispatch(.userPlaylistDone(result: .failure(.userPlaylistError)))
                }
            case .failure(let error):
                store.dispatch(.userPlaylistDone(result: .failure(error)))
            }
        }
    }
}
