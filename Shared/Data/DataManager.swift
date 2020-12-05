//
//  DataManager.swift
//  Qin
//
//  Created by 林少龙 on 2020/6/15.
//  Copyright © 2020 teenloong. All rights reserved.
//

import Foundation
import CoreData

class DataManager {
    static let shared = DataManager()
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        /*add necessary support for migration*/
        let description = NSPersistentStoreDescription()
        description.shouldMigrateStoreAutomatically = true
        description.shouldInferMappingModelAutomatically = true
        container.persistentStoreDescriptions =  [description]
        /*add necessary support for migration*/
        //防止重复插入数据
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return container
    }()
    public func context() -> NSManagedObjectContext {
        return self.persistentContainer.viewContext
    }
    public func newBackgroundUniqueContext() -> NSManagedObjectContext {
        let context = persistentContainer.newBackgroundContext()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }
    public func batchDelete(entityName: String, predicate: NSPredicate? = nil) {
        do {
            let context = self.context()
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            request.predicate = predicate
            let batchDelete = NSBatchDeleteRequest(fetchRequest: request)
            let deleteResult = try context.execute(batchDelete)
            print("\(#function)", deleteResult)
        }catch let error {
            print("\(#function):\(error)")
        }
    }
    public func batchInsert(entityName: String, objects: [[String: Any]]) {
        do {
            let context = self.context()
            let batchInsert = NSBatchInsertRequest(entityName: entityName, objects: objects)
            var insertResult : NSBatchInsertResult
            insertResult = try context.execute(batchInsert) as! NSBatchInsertResult
            print("insertResult",insertResult)
        }catch let error {
            print("\(#function):\(error)")
        }
    }
    public func batchInsertAfterDeleteAll(entityName: String, objects: [[String: Any]]) {
        do {
            self.batchDelete(entityName: entityName)
            let context = self.context()
            let batchInsert = NSBatchInsertRequest(entityName: entityName, objects: objects)
            var insertResult : NSBatchInsertResult
            insertResult = try context.execute(batchInsert) as! NSBatchInsertResult
            print("insertResult",insertResult)
        }catch let error {
            print("\(#function):\(error)")
        }
    }
    public func batchUpdate(entityName: String, propertiesToUpdate: [AnyHashable : Any], predicate: NSPredicate? = nil) {
        do {
            let context = self.context()
            let updateRequest = NSBatchUpdateRequest(entityName: entityName)
            updateRequest.propertiesToUpdate = propertiesToUpdate
            updateRequest.predicate = predicate
            
            let updateResult = try context.execute(updateRequest) as! NSBatchUpdateResult
            print("\(#function)",updateResult)
        }catch let error {
            print("\(#function):\(error)")
        }
    }
    public func batchUpdateLike(ids: [Int]) {
        self.batchUpdate(entityName: "Song", propertiesToUpdate: ["like" : true], predicate: NSPredicate(format: "id IN %@", ids))
    }
    public func getAlbum(id: Int64) -> Album? {
        var album: Album? = nil
        do {
            let context = self.context()
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Album")
            fetchRequest.predicate = NSPredicate(format: "%K == \(id)", "id")
            album = try context.fetch(fetchRequest).first as? Album
        }catch let error {
            print("\(#function):\(error)")
        }
        return album
    }
    public func getArtist(id: Int64) -> Artist? {
        var artist: Artist? = nil
        let context = self.context()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Artist")
        fetchRequest.predicate = NSPredicate(format: "%K == \(id)", "id")
        do {
            artist = try context.fetch(fetchRequest).first as? Artist
        }catch let error {
            print("\(#function):\(error)")
        }
        return artist
    }
    public func getPlaylist(id: Int64) -> Playlist? {
        var playlist: Playlist? = nil
        let context = self.context()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Playlist")
        fetchRequest.predicate = NSPredicate(format: "%K == \(id)", "id")
        do {
            playlist = try context.fetch(fetchRequest).first as? Playlist
        }catch let error {
            print("\(#function):\(error)")
        }
        return playlist
    }
    public func getSong(id: Int64) -> Song? {
        var song: Song? = nil
        let context = self.context()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Song")
        fetchRequest.predicate = NSPredicate(format: "%K == \(id)", "id")
        do {
            song = try context.fetch(fetchRequest).first as? Song
        }catch let error {
            print("\(#function):\(error)")
        }
        return song
    }
    public func getSongs(ids: [Int64]) -> [Song]? {
        var songs: [Song]? = nil
        let context = self.context()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Song")
        fetchRequest.predicate = NSPredicate(format: "%K IN %@", "id", ids)
        do {
            songs = try context.fetch(fetchRequest) as? [Song]
        }catch let error {
            print("\(#function):\(error)")
        }
        return songs
    }
    public func getUser() -> User? {
        var user: User? = nil
        let context = self.context()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "AccountData")
        do {
            let accountDatas = try context.fetch(request)
            if accountDatas.count > 0 {
                user =  User(accountDatas[0] as! AccountData)
            }
        }catch let error {
            print("DataManager getUser \(error)")
        }
        return user
    }
    public func save() {
        do {
            try self.context().save()
        }catch let error {
            print("\(#function) \(error)")
        }
    }
    public func updateAlbum(albumJSONModel: AlbumJSONModel) {
        let album = albumJSONModel.toAlbumEntity(context: self.context())
        for ar in albumJSONModel.artists {
            if let artist = self.getArtist(id: ar.id) {
                album.addToArtists(artist)
            }else {
                let artist = ar.toArtistEntity(context: self.context())
                album.addToArtists(artist)
            }
        }
        self.save()
    }
    public func updateAlbumSongs(id: Int64, songsId: [Int64]) {
        if let album = self.getAlbum(id: id) {
            if let songs = album.songs {
                album.removeFromSongs(songs)
            }
            album.songsId = songsId
            if let songs = self.getSongs(ids: songsId) {
                album.addToSongs(NSSet(array: songs))
            }
            self.save()
        }
    }
    public func updateArtist(artistJSONModel: ArtistJSONModel) {
        _ = artistJSONModel.toArtistEntity(context: self.context())
        self.save()
    }
    public func updateArtistAlbums(id: Int64, albumsJSONModel: [AlbumJSONModel]) {
        if let artist = self.getArtist(id: id) {
            if let albums = artist.albums {
                artist.removeFromSongs(albums)
            }
            for albumModel in albumsJSONModel {
                if let album = self.getAlbum(id: albumModel.id) {
                    artist.addToAlbums(album)
                }else {
                    let album = albumModel.toAlbumEntity(context: self.context())
                    artist.addToAlbums(album)
                }
            }
            self.save()
        }
    }
    public func updateArtistIntroduction(id: Int64, introduction: String?) {
        if let artist = self.getArtist(id: id) {
            artist.introduction = introduction
            self.save()
        }
    }
    public func updateArtistSongs(id: Int64, songsId: [Int64]) {
        if let artist = self.getArtist(id: id) {
            if let songs = artist.songs {
                artist.removeFromSongs(songs)
            }
            artist.songsId = songsId
            if let songs = self.getSongs(ids: songsId) {
                artist.addToSongs(NSSet(array: songs))
            }
            self.save()
        }
    }
    public func updatePlaylist(playlistJSONModel: PlaylistJSONModel) {
        _ = playlistJSONModel.toPlaylistEntity(context: self.context())
        self.save()
    }
    public func updatePlaylistSongs(id: Int64, songsId: [Int64]) {
        if let playlist = self.getPlaylist(id: id) {
            if let songs = playlist.songs {
                playlist.removeFromSongs(songs)
            }
            playlist.songsId = songsId
            if let songs = self.getSongs(ids: songsId) {
                playlist.addToSongs(NSSet(array: songs))
            }
            self.save()
        }
    }
    public func updateRecommendSongsPlaylist(recommendSongsJSONModel: RecommendSongsJSONModel) {
        let playlist = Playlist(context: self.context())
        playlist.id = 0
        playlist.name = "每日推荐"
        playlist.introduction = "它聪明、熟悉每个用户的喜好，从海量音乐中挑选出你可能喜欢的音乐。\n它通过你每一次操作来记录你的口味"
        playlist.songsId = recommendSongsJSONModel.dailySongs.map{$0.id}
        self.save()
    }
    public func updateRecommendSongsPlaylistSongs(ids: [Int64]) {
        if let playlist = self.getPlaylist(id: 0) {
            if let songs = playlist.songs {
                playlist.removeFromSongs(songs)
            }
            if let songs = self.getSongs(ids: ids) {
                playlist.addToSongs(NSSet(array: songs))
            }
        }
        self.save()
    }
    public func updateSongs(songsJSONModel: [SongJSONModel]) {
        for songModel in songsJSONModel {
            let song = songModel.toSongEntity(context: self.context())
            if let album = self.getAlbum(id: songModel.album.id) {
                album.addToSongs(song)
            }else {
                let album = songModel.album.toAlbumEntity(context: self.context())
                album.addToSongs(song)
            }
            for ar in songModel.artists {
                if let artist = self.getArtist(id: ar.id) {
                    artist.addToSongs(song)
                }else {
                    let artist = ar.toArtistEntity(context: self.context())
                    artist.addToSongs(song)
                }
            }
        }
        self.save()
    }
    public func updateSongs(songsJSONModel: [SongDetailJSONModel]) {
        for songModel in songsJSONModel {
            let song = songModel.toSongEntity(context: self.context())
            if let album = self.getAlbum(id: songModel.al.id) {
                album.addToSongs(song)
            }else {
                let album = songModel.al.toAlbumEntity(context: self.context())
                album.addToSongs(song)
            }
            for ar in songModel.ar {
                if let artist = self.getArtist(id: ar.id) {
                    artist.addToSongs(song)
                }else {
                    let artist = ar.toArtistEntity(context: self.context())
                    artist.addToSongs(song)
                }
            }
        }
        self.save()
    }
    public func userLogin(_ user: User) {
        userLogout()
        let accountData = NSEntityDescription.insertNewObject(forEntityName: "AccountData", into: self.context()) as! AccountData
        do {
            accountData.userData = try JSONEncoder().encode(user)
        }catch let error {
            print(error)
        }
        self.save()
    }
    public func userLogout() {
        let context = self.context()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "AccountData")
        do {
            let accountDatas = try self.context().fetch(request)
            for accountData in accountDatas {
                persistentContainer.viewContext.delete(accountData as! NSManagedObject)
            }
            try context.save()
        }catch let error {
            print("DataManager userLogout \(error)")
        }
    }
}
