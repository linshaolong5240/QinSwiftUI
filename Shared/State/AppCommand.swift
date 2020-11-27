//
//  AppCommand.swift
//  Qin
//
//  Created by 林少龙 on 2020/6/17.
//  Copyright © 2020 teenloong. All rights reserved.
//

import Foundation
import CoreData

protocol AppCommand {
    func execute(in store: Store)
}

struct AlbumCommand: AppCommand {
    let id: Int64
    
    func execute(in store: Store) {
        NeteaseCloudMusicApi.shared.album(id: id) { (data, error) in
            guard error == nil else {
                store.dispatch(.albumDone(result: .failure(error!)))
                return
            }
            if data?["code"] as? Int == 200 {
                do {
                    let context = DataManager.shared.Context()
                    //clean relationship
//                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Album")
//                    fetchRequest.predicate = NSPredicate(format: "%K == \(id)", "id")
//                    if let saved = try context.fetch(fetchRequest).first as? Album {
//                        if let songs = saved.songs {
//                            saved.removeFromSongs(songs)
//                            try context.save()
//                        }
//                    }
                    let albumDict = data!["album"] as! [String: Any]
                    let albumJSONModel = albumDict.toData!.toModel(AlbumJSONModel.self)!
                    let songsDict = data!["songs"] as! [[String: Any]]
                    let songsJSONModel = songsDict.map{$0.toData!.toModel(SongDetailJSONModel.self)!}
                    let album = albumJSONModel.toAlbumEntity(context: context)
                    let songsIds = songsJSONModel.map{$0.id}
                    album.songsId = songsIds
                    for ar in albumJSONModel.artists {
                        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Artist")
                        fetchRequest.predicate = NSPredicate(format: "%K == \(ar.id)", "id")
                        if let artist = try context.fetch(fetchRequest).first as? Artist {
                            album.addToArtists(artist)
                        }else {
                            let artist = ar.toArtistEntity(context: context)
                            album.addToArtists(artist)
                        }
                    }
                    try context.save()
                    for songModel in songsJSONModel {
                        let song = songModel.toSongEntity(context: context)
                        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Album")
                        fetchRequest.predicate = NSPredicate(format: "%K == \(songModel.al.id)", "id")
                        if let album = try context.fetch(fetchRequest).first as? Album {
                            album.addToSongs(song)
                        }
                        for ar in songModel.ar {
                            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Artist")
                            fetchRequest.predicate = NSPredicate(format: "%K == \(ar.id)", "id")
                            if let artist = try context.fetch(fetchRequest).first as? Artist {
                                artist.addToSongs(song)
                            }else {
                                let artist = ar.toArtistEntity(context: context)
                                artist.addToSongs(song)
                            }
                        }
                    }
                    try context.save()
                    store.dispatch(.albumDone(result: .success(songsIds)))
                }catch let err {
                    print("\(#function) \(err)")
                }
            }else {
                let code = data?["code"] as? Int ?? -1
                let message = data?["message"] as? String ?? "错误信息解码错误"
                store.dispatch(.albumDone(result: .failure(.album(code: code, message: message))))
            }
        }
    }
}

struct AlbumDoneCommand: AppCommand {
    let ids: [Int64]
    
    func execute(in store: Store) {
    }
}

struct AlbumSubCommand: AppCommand {
    let id: Int64
    let sub: Bool
    
    func execute(in store: Store) {
        NeteaseCloudMusicApi.shared.albumSub(id: id, sub: sub) { (data, error) in
            guard error == nil else {
                store.dispatch(.albumSubDone(result: .failure(error!)))
                return
            }
            if data?["code"] as? Int == 200 {
                store.dispatch(.albumSubDone(result: .success(sub)))
            }else {
                let code = data?["code"] as? Int ?? -1
                let message = data?["message"] as? String ?? "错误信息解码错误"
                store.dispatch(.albumSubDone(result: .failure(.albumSub(code: code, message: message))))
            }
        }
    }
}

struct AlbumSubDoneCommand: AppCommand {
    
    func execute(in store: Store) {
        store.dispatch(.albumSublist())
    }
}

struct AlbumSublistCommand: AppCommand {
    let limit: Int
    let offset: Int
    
    func execute(in store: Store) {
        NeteaseCloudMusicApi.shared.albumSublist(limit: limit, offset: offset) { (data, error) in
            guard error == nil else {
                store.dispatch(.albumSublistDone(result: .failure(error!)))
                return
            }
            if data?["code"] as? Int == 200 {
                let sublistDict = data!["data"] as! [[String: Any]]
                let albumSublist = sublistDict.map{$0.toData!.toModel(AlbumSubModel.self)!}
                do {
                    let data = try JSONEncoder().encode(albumSublist)
                    let objects = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [[String: Any]]
                    DataManager.shared.batchInsertAfterDeleteAll(entityName: "AlbumSub", objects: objects)
                    store.dispatch(.albumSublistDone(result: .success(albumSublist.map{$0.id})))
                } catch let err {
                    print("\(#function) \(err)")
                }
            }else {
                let code = data?["code"] as? Int ?? -1
                let message = data?["message"] as? String ?? "错误信息解码错误"
                store.dispatch(.albumSublistDone(result: .failure(.albumSublist(code: code, message: message))))
            }
        }
    }
}

struct ArtistCommand: AppCommand {
    let id: Int64
    
    func execute(in store: Store) {
        NeteaseCloudMusicApi.shared.artists(id: id) { (data, error) in
            guard error == nil else {
                store.dispatch(.artistDone(result: .failure(error!)))
                return
            }
            if data?["code"] as? Int == 200 {
                do {
                    let context = DataManager.shared.Context()
                    //clean relationship
//                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Artist")
//                    fetchRequest.predicate = NSPredicate(format: "%K == \(id)", "id")
//                    if let saved = try context.fetch(fetchRequest).first as? Artist {
//                        if let songs = saved.songs {
//                            saved.removeFromSongs(songs)
//                            try context.save()
//                        }
//                    }
                    let artistDict = data!["artist"] as! [String: Any]
                    let artistJSONModel = artistDict.toData!.toModel(ArtistJSONModel.self)!
                    
                    let hotSongsDictArray = data!["hotSongs"] as! [[String: Any]]
                    let songsJSONModel = hotSongsDictArray.map{$0.toData!.toModel(SongJSONModel.self)!}
                    
                    let artist = artistJSONModel.toArtistEntity(context: context)
                    let songsIds = songsJSONModel.map{$0.id}
                    artist.songsId = songsIds
                    for songModel in songsJSONModel {
                        let song = songModel.toSongEntity(context: context)
                        artist.addToSongs(song)
                        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Album")
                        fetchRequest.predicate = NSPredicate(format: "%K == \(songModel.album.id)", "id")
                        if let album = try context.fetch(fetchRequest).first as? Album {
                            album.addToSongs(song)
                        }else {
                            let album = songModel.album.toAlbumEntity(context: context)
                            album.addToSongs(song)
                        }
                    }
                    try context.save()
                    store.dispatch(.artistDone(result: .success(artistJSONModel)))
                }catch let err {
                    print("\(#function) \(err)")
                }
            }else {
                let code = data?["code"] as? Int ?? -1
                let message = data?["message"] as? String ?? "错误信息解码错误"
                store.dispatch(.artistDone(result: .failure(.comment(code: code, message: message))))
            }
        }
    }
}

struct ArtistDoneCommand: AppCommand {
    let artist: ArtistJSONModel
    
    func execute(in store: Store) {
        let id = artist.id
        store.dispatch(.artistAlbum(id: id))
        store.dispatch(.artistIntroduction(id: id))
        store.dispatch(.artistMV(id: id))
    }
}

struct ArtistAlbumCommand: AppCommand {
    let id: Int64
    let limit: Int
    let offset: Int
    
    init(id: Int64, limit: Int = 30, offset: Int = 0) {
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
                do {
                    let context = DataManager.shared.Context()
                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Artist")
                    fetchRequest.predicate = NSPredicate(format: "%K == \(id)", "id")
                    if let artist = try context.fetch(fetchRequest).first as? Artist {
                        //clean albums relationship
//                        if let albums = artist.albums {
//                            artist.removeFromAlbums(albums)
//                            try context.save()
//                        }
                        let albumsDict = data!["hotAlbums"] as! [[String: Any]]
                        let albumsJSONModel = albumsDict.map{$0.toData!.toModel(AlbumJSONModel.self)!}
                        for albumModel in albumsJSONModel {
                            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Album")
                            fetchRequest.predicate = NSPredicate(format: "%K == \(albumModel.id)", "id")
                            if let album = try context.fetch(fetchRequest).first as? Album {
                                artist.addToAlbums(album)
                            }else {
                                let album = albumModel.toAlbumEntity(context: context)
                                artist.addToAlbums(album)
                            }
                        }
                        try context.save()
                        store.dispatch(.artistAlbumDone(result: .success(albumsJSONModel)))
                    }
                }catch let err {
                    print("\(#function) \(err)")
                }
            }else {
                let code = data?["code"] as? Int ?? -1
                let message = data?["message"] as? String ?? "错误信息解码错误"
                store.dispatch(.artistAlbumDone(result: .failure(.artistAlbum(code: code, message: message))))
            }
        }
    }
}

struct ArtistIntroductionCommand: AppCommand {
    let id: Int64
    
    func execute(in store: Store) {
        NeteaseCloudMusicApi.shared.artistIntroduction(id: id) { (data, error) in
            guard error == nil else {
                store.dispatch(.artistIntroductionDone(result: .failure(error!)))
                return
            }
            if data?["code"] as? Int == 200 {
                do {
                    var introduction: String?
                    let context = DataManager.shared.Context()
                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Artist")
                    fetchRequest.predicate = NSPredicate(format: "%K == \(id)", "id")
                    if let aritst = try context.fetch(fetchRequest).first as? Artist {
                        introduction = data!["briefDesc"] as? String ?? nil
                        aritst.introduction = introduction
                        try context.save()
                        store.dispatch(.artistIntroductionDone(result: .success(introduction)))
                    }
                }catch let err {
                    print("\(#function) \(err)")
                }
            }else {
                let code = data?["code"] as? Int ?? -1
                let message = data?["message"] as? String ?? "错误信息解码错误"
                store.dispatch(.artistIntroductionDone(result: .failure(.comment(code: code, message: message))))
            }
        }
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
        NeteaseCloudMusicApi.shared.artistMV(id: id, limit: limit, offset: offset) { (data, error) in
            guard error == nil else {
                store.dispatch(.artistMVDone(result: .failure(error!)))
                return
            }
            if data?["code"] as? Int == 200 {
                do {
                    let context = DataManager.shared.Context()
                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Artist")
                    fetchRequest.predicate = NSPredicate(format: "%K == \(id)", "id")
                    if let artist = try context.fetch(fetchRequest).first as? Artist {
                        //clean albums relationship
//                        if let albums = artist.albums {
//                            artist.removeFromAlbums(albums)
//                            try context.save()
//                        }
                        let mvsDict = data!["mvs"] as! [[String: Any]]
                        let mvsJSONModel = mvsDict.map{$0.toData!.toModel(MVJSONModel.self)!}
                        for mvModel in mvsJSONModel {
                            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MV")
                            fetchRequest.predicate = NSPredicate(format: "%K == \(mvModel.id)", "id")
                            if let mv = try context.fetch(fetchRequest).first as? MV {
                                artist.addToMvs(mv)
                            }else {
                                let mv = mvModel.toMVEntity(context: context)
                                artist.addToMvs(mv)
                            }
                        }
                        try context.save()
                        store.dispatch(.artistMVDone(result: .success(mvsJSONModel)))
                    }
                }catch let err {
                    print("\(#function) \(err)")
                }
            }else {
                let code = data?["code"] as? Int ?? -1
                let message = data?["message"] as? String ?? "错误信息解码错误"
                store.dispatch(.artistMVDone(result: .failure(.artistMV(code: code, message: message))))
            }
        }
    }
}

struct ArtistSubCommand: AppCommand {
    let id: Int64
    let sub: Bool
    
    func execute(in store: Store) {
        NeteaseCloudMusicApi.shared.artistSub(id: id, sub: sub) { (data, error) in
            guard error == nil else {
                store.dispatch(.artistSubDone(result: .failure(error!)))
                return
            }
            if data?["code"] as? Int == 200 {
                store.dispatch(.artistSubDone(result: .success(true)))
            }else {
                let code = data?["code"] as? Int ?? -1
                let message = data?["message"] as? String ?? "错误信息解码错误"
                store.dispatch(.artistSubDone(result: .failure(.artistSub(code: code, message: message))))
            }
        }
    }
}

struct ArtistSubDoneCommand: AppCommand {
    
    func execute(in store: Store) {
        store.dispatch(.artistSublist())
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
                let artistSublist = artistSublistDict.map{$0.toData!.toModel(ArtistSubModel.self)!}
                do {
                    let data = try JSONEncoder().encode(artistSublist)
                    let objects = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [[String: Any]]
                    DataManager.shared.batchInsertAfterDeleteAll(entityName: "ArtistSub", objects: objects)
                    store.dispatch(.artistSublistDone(result: .success(artistSublist.map{$0.id})))
                }catch let err {
                    print("\(#function) \(err)")
                }
            }else {
                let code = data?["code"] as? Int ?? -1
                let message = data?["message"] as? String ?? "错误信息解码错误"
                store.dispatch(.artistSublistDone(result: .failure(.artistSublist(code: code, message: message))))
            }
        }
    }
}

struct CommentCommand: AppCommand {
    let id: Int64
    let cid: Int64
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
                if let code = data?["code"] as? Int {
                    if let message = data?["message"] as? String {
                        store.dispatch(.commentDone(result: .failure(.comment(code: code, message: message))))
                    }
                }
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
                store.dispatch(.commentMusic(id: id))
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
        NeteaseCloudMusicApi.shared.commentMusic(id: id, limit: limit, offset: offset, beforeTime: beforeTime) { (data, error) in
            guard error == nil else {
                store.dispatch(.commentMusicDone(result: .failure(error!)))
                return
            }
            if data!["code"] as! Int == 200 {
                var hotComments = [CommentJSONModel]()
                var comments = [CommentJSONModel]()
               
                if let hotCommentsArray = data?["hotComments"] as? [NeteaseCloudMusicApi.ResponseData] {
                    hotComments = hotCommentsArray.map({$0.toData!.toModel(CommentJSONModel.self)!})
                }
                if let commentsArray = data?["comments"] as? [NeteaseCloudMusicApi.ResponseData] {
                    comments = commentsArray.map({$0.toData!.toModel(CommentJSONModel.self)!})
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
        store.appState.initRequestingCount += 1
        store.dispatch(.albumSublist())
        
        store.appState.initRequestingCount += 1
        store.dispatch(.artistSublist())
        
        store.appState.initRequestingCount += 1
        store.dispatch(.likelist())
        
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

struct LikeCommand: AppCommand {
    let id: Int64
    let like: Bool
    
    func execute(in store: Store) {
        NeteaseCloudMusicApi.shared.like(id: id, like: like) { (data, error) in
            guard error == nil else {
                store.dispatch(.likeDone(result: .failure(error!)))
                return
            }
            if data!["code"] as! Int == 200 {
                store.dispatch(.likeDone(result: .success(like)))
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
    let uid: Int64
    
    func execute(in store: Store) {
        NeteaseCloudMusicApi.shared.likeList(uid: uid) { (data, error) in
            guard error == nil else {
                store.dispatch(.likelistDone(result: .failure(error!)))
                return
            }
            if data!["code"] as! Int == 200 {
                let likelist = data!["ids"] as! [Int64]
                
                store.dispatch(.likelistDone(result: .success(likelist)))
            }else {
                store.dispatch(.likelistDone(result: .failure(.likelist)))
            }
        }
    }
}

struct LyricCommand: AppCommand {
    let id: Int64
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
                }else {
                    store.dispatch(.lyricDone(result: .success(nil)))
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
                    user.uid = profile["userId"] as! Int64
                }
                store.dispatch(.loginDone(result: .success(user)))
            }else {
                store.dispatch(.loginDone(result: .failure(.loginError(code: data!["code"] as! Int, message: data!["message"] as! String))))
            }
        }
    }
}

struct LoginDoneCommand: AppCommand {
    let user: User
    
    func execute(in store: Store) {
        DataManager.shared.userLogin(user)
        store.dispatch(.initAction)
    }
}

struct LoginRefreshCommand: AppCommand {

    func execute(in store: Store) {
        NeteaseCloudMusicApi.shared.loginRefresh{ (data, error) in
            guard error == nil else {
                store.dispatch(.loginRefreshDone(result: .failure(error!)))
                return
            }
            if data?["code"] as? Int == 200 {
                store.dispatch(.loginRefreshDone(result: .success(true)))
            }else {
                store.dispatch(.loginRefreshDone(result: .success(false)))
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
            store.dispatch(.logout)
        }
    }
}

struct LogoutCommand: AppCommand {

    func execute(in store: Store) {
        NeteaseCloudMusicApi.shared.logout { (data, error) in
            
        }
        DataManager.shared.userLogout()
        
//        if let cookies = HTTPCookieStorage.shared.cookies {
//            for cookie in cookies {
//                if cookie.name != "os" {
//                    HTTPCookieStorage.shared.deleteCookie(cookie)
//                }
//            }
//        }
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
            store.dispatch(.PlayerPlayByIndex(index: index))
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
            store.dispatch(.PlayerPlayByIndex(index: index))
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
        NeteaseCloudMusicApi.shared.songsURL([id]) { data, error in
            guard error == nil else {
                store.dispatch(.PlayerPlayRequestDone(result: .failure(error!)))
                return
            }
            if let songsURLDict = data?["data"] as? [NeteaseCloudMusicApi.ResponseData] {
                if songsURLDict.count > 0 {
                    store.dispatch(.PlayerPlayRequestDone(result: .success(songsURLDict[0].toData!.toModel(SongURLJSONModel.self)!)))
                }
            }else {
                store.dispatch(.PlayerPlayRequestDone(result: .failure(.songsURLError)))
            }
        }
    }
}

struct PlayerPlayRequestDoneCommand: AppCommand {
    let url: String
    
    func execute(in store: Store) {
        let index = store.appState.playing.index
        let songId = store.appState.playing.playinglist[index]
        Player.shared.playWithURL(url: url)
        store.dispatch(.lyric(id: songId))
    }
}

struct PlayerPlayToEndActionCommand: AppCommand {
    
    func execute(in store: Store) {
        switch store.appState.settings.playMode {
        case .playlist:
            store.dispatch(.PlayerPlayForward)
        case .relplay:
            store.dispatch(.playerReplay)
            break
        }
    }
}

struct PlayinglistInsertCommand: AppCommand {
    let index: Int
    
    func execute(in store: Store) {
        store.dispatch(.PlayerPlayByIndex(index: index))
    }
}

struct PlaylistCommand: AppCommand {
    let cat: String
    let hot: Bool
    let limit: Int
    let offset: Int
    
    func execute(in store: Store) {
        NeteaseCloudMusicApi.shared.playlist(cat: cat, hot: hot, limit: limit, offset: offset) { (data, error) in
            guard error == nil else {
                store.dispatch(.playlistDone(result: .failure(error!)))
                return
            }
            if data!["code"] as! Int == 200 {
                let playlistDicts = data!["playlists"]! as! [NeteaseCloudMusicApi.ResponseData]
                let playlists = playlistDicts.map{$0.toData!.toModel(PlaylistJSONModel.self)!}.map{PlaylistViewModel($0)}
                let category = data!["cat"]! as! String
                let more = data!["more"]! as! Bool
                let total = data!["total"] as! Int
                let result = (playlists: playlists, category: category, total: total , more: more)
                store.dispatch(.playlistDone(result: .success(result)))
            }else {
                let code = data?["code"] as? Int ?? -1
                let message = data?["message"] as? String ?? "PlaylistCommandError"
                store.dispatch(.playlistDone(result: .failure(.playlistCategories(code: code, message: message))))
            }
        }
    }
}

struct PlaylistCategoriesCommand: AppCommand {
    func execute(in store: Store) {
        NeteaseCloudMusicApi.shared.playlistCategories { (data, error) in
            guard error == nil else {
                store.dispatch(.playlistCategoriesDone(result: .failure(error!)))
                return
            }
            if data!["code"] as! Int == 200 {
                let alldict = data!["all"] as! NeteaseCloudMusicApi.ResponseData
                let all = alldict.toData!.toModel(PlaylistSubCategory.self)!
                
                let categoriesdict = data!["categories"] as! [String: Any]
                let categoriesModel = categoriesdict.toData!.toModel(PlaylistCategoryJSONModel.self)!

                let subcategoriesdict = data!["sub"] as! [[String: Any]]
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
            }else {
                let code = data?["code"] as? Int ?? -1
                let message = data?["message"] as? String ?? "PlaylistCatlistCommandError"
                store.dispatch(.playlistCategoriesDone(result: .failure(.playlistCategories(code: code, message: message))))
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
        store.dispatch(.userPlaylist())
    }
}

struct PlaylistDeleteCommand: AppCommand {
    let pid: Int64
    
    func execute(in store: Store) {
        NeteaseCloudMusicApi.shared.playlistDelete(pid: pid) { (data, error) in
            guard error == nil else {
                store.dispatch(.playlistDeleteDone(result: .failure(error!)))
                return
            }
            if data!["code"] as! Int == 200 {
                store.dispatch(.playlistDeleteDone(result: .success(data!["id"] as! Int64)))
            }else {
                store.dispatch(.playlistDeleteDone(result: .failure(.playlistDeleteError)))
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
        NeteaseCloudMusicApi.shared.playlistDetail(id: id) { (data, error) in
            guard error == nil else {
                store.dispatch(.playlistDetailDone(result: .failure(error!)))
                return
            }
            if data!["code"] as! Int == 200 {
                if let playlistDict = data?["playlist"] as? NeteaseCloudMusicApi.ResponseData {
                    let playlistJSONModel = playlistDict.toData!.toModel(PlaylistJSONModel.self)!
                    store.dispatch(.playlistDetailDone(result: .success(playlistJSONModel)))
                }
            }else {
                store.dispatch(.playlistDetailDone(result: .failure(.playlistDetailError)))
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
            NeteaseCloudMusicApi.shared.songsDetail(ids: ids) { data, error in
                guard error == nil else {
                    store.dispatch(.playlistDetailSongsDone(result: .failure(error!)))
                    return
                }
                if let songsDict = data?["songs"] as? [[String: Any]] {
                    do {
                        let context = DataManager.shared.Context()
                        //clean relationship
//                        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Playlist")
//                        fetchRequest.predicate = NSPredicate(format: "%K == \(playlistJSONModel.id)", "id")
//                        if let saved = try context.fetch(fetchRequest).first as? Playlist {
//                            if let songs = saved.songs {
//                                saved.removeFromSongs(songs)
//                                try context.save()
//                            }
//                        }
                        let songsDetailJSONModel = songsDict.map{$0.toData!.toModel(SongDetailJSONModel.self)!}
                        let songsId = songsDetailJSONModel.map{$0.id}
                        let playlist = playlistJSONModel.toPlaylistEntity(context: context)
                        playlist.songsId = songsId
                        for songModel in songsDetailJSONModel {
                            let song = songModel.toSongEntity(context: context)
                            playlist.addToSongs(song)
                            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Album")
                            fetchRequest.predicate = NSPredicate(format: "%K == \(songModel.al.id)", "id")
                            if let album = try context.fetch(fetchRequest).first as? Album {
                                album.addToSongs(song)
                            } else {
                                let album = songModel.al.toAlbumEntity(context: context)
                                album.addToSongs(song)
                            }
                            for ar in songModel.ar {
                                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Artist")
                                fetchRequest.predicate = NSPredicate(format: "%K == \(ar.id)", "id")
                                if let artist = try context.fetch(fetchRequest).first as? Artist {
                                    artist.addToSongs(song)
                                } else {
                                    let artist = ar.toArtistEntity(context: context)
                                    artist.addToSongs(song)
                                }
                            }
                        }
                        try context.save()
                        store.dispatch(.playlistDetailSongsDone(result: .success(songsId)))
                    }catch let err {
                        print("\(#function) \(err)")
                    }

                }else {
                    store.dispatch(.playlistDetailSongsDone(result: .failure(.songsDetailError)))
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
        store.dispatch(.userPlaylist())
    }
}

struct PlaylisSubscribeCommand: AppCommand {
    let id: Int64
    let sub: Bool
    
    func execute(in store: Store) {
        NeteaseCloudMusicApi.shared.playlistSubscribe(id: id, sub: sub) { (data, error) in
            guard error == nil else {
                store.dispatch(.playlistSubscibeDone(result: .failure(error!)))
                return
            }
            if data!["code"] as! Int == 200 {
                store.dispatch(.playlistSubscibeDone(result: .success(sub)))
            }else {
                store.dispatch(.playlistSubscibeDone(result: .failure(.playlistSubscribeError)))
            }
        }
    }
}

struct PlaylisSubscribeDoneCommand: AppCommand {

    func execute(in store: Store) {
        store.dispatch(.userPlaylist())
    }
}

struct PlaylistTracksCommand: AppCommand {
    let pid: Int64
    let op: Bool
    let ids: [Int64]
    
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
        store.dispatch(.userPlaylist())
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
                if let playlistDicts = data?["recommend"] as? [NeteaseCloudMusicApi.ResponseData] {

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
        }
    }
}

struct RecommendPlaylistDoneCommand: AppCommand {
    func execute(in store: Store) {
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
                if let recommendSongDicts = data?["data"] as? NeteaseCloudMusicApi.ResponseData {
                    do {
                        let context = DataManager.shared.Context()
//                        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Playlist")
//                        fetchRequest.predicate = NSPredicate(format: "%K == 0", "id")
//                        if let saved = try context.fetch(fetchRequest).first as? Playlist {
//                            if let songs = saved.songs {
//                                saved.removeFromSongs(songs)
//                                try context.save()
//                            }
//                        }
                        let recommendSongsJSONModel = recommendSongDicts.toData!.toModel(RecommendSongsJSONModel.self)!
                        let playlist = Playlist(context: context)
                        playlist.id = 0
                        playlist.name = "每日推荐"
                        playlist.introduction = "它聪明、熟悉每个用户的喜好，从海量音乐中挑选出你可能喜欢的音乐。\n它通过你每一次操作来记录你的口味"
                        playlist.songsId = recommendSongsJSONModel.dailySongs.map{$0.id}
                        for songModel in recommendSongsJSONModel.dailySongs {
                            let song = songModel.toSongEntity(context: context)
                            playlist.addToSongs(song)
                            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Album")
                            fetchRequest.predicate = NSPredicate(format: "%K == \(songModel.al.id)", "id")
                            if let album = try context.fetch(fetchRequest).first as? Album {
                                album.addToSongs(song)
                            } else {
                                let album = songModel.al.toAlbumEntity(context: context)
                                album.addToSongs(song)
                            }
                            for ar in songModel.ar {
                                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Artist")
                                fetchRequest.predicate = NSPredicate(format: "%K == \(ar.id)", "id")
                                if let artist = try context.fetch(fetchRequest).first as? Artist {
                                    artist.addToSongs(song)
                                } else {
                                    let artist = ar.toArtistEntity(context: context)
                                    artist.addToSongs(song)
                                }
                            }
                        }
                        try context.save()
                        store.dispatch(.recommendSongsDone(result: .success(recommendSongsJSONModel)))
                    } catch let err {
                        print("\(#function) \(err)")
                    }
                }
            }else {
                store.dispatch(.recommendSongsDone(result: .failure(.playlistDetailError)))
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
        NeteaseCloudMusicApi.shared.search(keyword: keyword, type: type, limit: limit, offset: offset) { data, error in
            guard error == nil else {
                store.dispatch(.searchSongDone(result: .failure(error!)))
                return
            }
            if let result = data?["result"] as? [String: Any] {
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
        NeteaseCloudMusicApi.shared.songsDetail(ids: ids) { data, error in
            guard error == nil else {
                store.dispatch(.songsDetailDone(result: .failure(error!)))
                return
            }
            if let songsDict = data?["songs"] as? [[String: Any]] {
                let songs = songsDict.map{$0.toData!.toModel(SongDetailJSONModel.self)!}
                store.dispatch(.songsDetailDone(result: .success(songs)))
            }else {
                store.dispatch(.songsDetailDone(result: .failure(.songsDetailError)))
            }
        }
    }
}

struct SongsDetailDoneCommand: AppCommand {
    let songs: [SongDetailJSONModel]
    
    func execute(in store: Store) {
        DataManager.shared.updateSongs(songs: songs)
//        store.dispatch(.songsURL(ids: songs.map{$0.id}))
    }
}

struct SongsOrderUpdateCommand: AppCommand {
    let pid: Int64
    let ids: [Int64]
    
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
    let pid: Int64
    
    func execute(in store: Store) {
        store.dispatch(.playlistDelete(pid: pid))
    }
}

struct SongsURLCommand: AppCommand {
    let ids: [Int64]
    
    func execute(in store: Store) {
        NeteaseCloudMusicApi.shared.songsURL(ids) { data, error in
            guard error == nil else {
                store.dispatch(.songsURLDone(result: .failure(error!)))
                return
            }
            if let songsURLDict = data?["data"] as? [NeteaseCloudMusicApi.ResponseData] {
                if songsURLDict.count > 0 {
                    store.dispatch(.songsURLDone(result: .success(songsURLDict.map{$0.toData!.toModel(SongURLJSONModel.self)!})))
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
    let time: Double
    
    func execute(in store: Store) {
        Player.shared.seek(seconds: time)
    }
}

struct TooglePlayCommand: AppCommand {

    func execute(in store: Store) {
        guard store.appState.playing.songUrl != nil else {
            store.dispatch(.PlayerPlayByIndex(index: store.appState.playing.index))
            return
        }
        if Player.shared.isPlaying {
            store.dispatch(.PlayerPause)
        }else {
            store.dispatch(.PlayerPlay)
        }
    }
}

struct UserPlayListCommand: AppCommand {
    let uid: Int64
    
    func execute(in store: Store) {
        NeteaseCloudMusicApi.shared.userPlayList(uid) { (data, error) in
            guard error == nil else {
                store.dispatch(.userPlaylistDone(result: .failure(error!)))
                return
            }
            if data!["code"] as! Int == 200 {
                if let playlistDicts = data?["playlist"] as? [NeteaseCloudMusicApi.ResponseData] {
                    let playlistModels = playlistDicts.map{$0.toData!.toModel(UserPlaylistModel.self)!}
                    do {
                        let data = try JSONEncoder().encode(playlistModels)
                        let objects = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)  as! [[String: Any]]
                        print(objects)
                        DataManager.shared.batchInsertAfterDeleteAll(entityName: "UserPlaylist", objects: objects)
                        store.dispatch(.userPlaylistDone(result: .success(playlistModels.map{$0.id})))
                    }catch let error {
                        print("\(#function) \(error)")
                    }
                }
            }else {
                store.dispatch(.userPlaylistDone(result: .failure(.userPlaylistError)))
            }
        }
    }
}
