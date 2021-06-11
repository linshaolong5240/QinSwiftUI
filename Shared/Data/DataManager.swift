//
//  DataManager.swift
//  Qin
//
//  Created by 林少龙 on 2020/6/15.
//  Copyright © 2020 teenloong. All rights reserved.
//

import Foundation
import CoreData

protocol CoreDataManged {
    associatedtype Entity: NSManagedObject
    func entity(context: NSManagedObjectContext) -> Entity
}

protocol CoreDataOrdered {
    var orderNumber: Int64 { get set }
}

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
//        container.viewContext.automaticallyMergesChangesFromParent = true
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
    public func batchDelete<T: NSManagedObject>(type: T.Type, predicate: NSPredicate? = nil) {
        #if DEBUG
        print("\(#function): \(type)")
        #endif
        defer { save() }
        let context = context()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        fetchRequest.entity = type.entity()
        fetchRequest.predicate = predicate
        let result = try? context.fetch(fetchRequest) as? [NSManagedObject]
        result?.forEach(context.delete)
    }
    public func batchDelete(entityName: String, predicate: NSPredicate? = nil) {
        #if DEBUG
        print("\(#function): \(entityName)")
        #endif
        defer { save() }
        do {
            let context = context()
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            request.predicate = predicate
            let batchDelete = NSBatchDeleteRequest(fetchRequest: request)
            let deleteResult = try context.execute(batchDelete)
            print("\(#function) \(deleteResult.description)")
        }catch let error {
            print("\(#function):\(error)")
        }
    }
    public func batchInsert<T: NSManagedObject, Element: CoreDataManged>(type: T.Type, models: [Element]) {
        #if DEBUG
        print("\(#function): \(type)")
        #endif
        defer { save() }
        models.forEach { item in
            _ = item.entity(context: context())
        }
    }
    public func batchOrderInsert<T: NSManagedObject, Element: CoreDataManged>(type: T.Type, models: [Element]) where T: CoreDataOrdered {
        #if DEBUG
        print("\(#function): \(type)")
        #endif
        defer { save() }
        models.enumerated().forEach({ index, item in
            var entity = item.entity(context: context()) as? T
            entity?.orderNumber = Int64(index)
        })
    }
    public func batchInsert(entityName: String, objects: [[String: Any]]) {
        defer { save() }
        do {
            let context = context()
            let batchInsert = NSBatchInsertRequest(entityName: entityName, objects: objects)
            let insertResult = try context.execute(batchInsert) as! NSBatchInsertResult
            print("\(#function) \(insertResult.description)")
        }catch let error {
            print("\(#function):\(error)")
        }
    }
    public func batchInsertAfterDeleteAll(entityName: String, objects: [[String: Any]]) {
        batchDelete(entityName: entityName)
        batchInsert(entityName: entityName, objects: objects)
    }
    public func batchUpdate(entityName: String, propertiesToUpdate: [AnyHashable : Any], predicate: NSPredicate? = nil) {
        defer { save() }
        do {
            let context = context()
            let updateRequest = NSBatchUpdateRequest(entityName: entityName)
            updateRequest.propertiesToUpdate = propertiesToUpdate
            updateRequest.predicate = predicate
            
            let updateResult = try context.execute(updateRequest) as! NSBatchUpdateResult
            print("\(#function)",updateResult)
        }catch let error {
            print("\(#function):\(error)")
        }
    }
    public func update<T: CoreDataManged>(model: T) {
        #if DEBUG
        print("\(#function): \(type(of: model))")
        #endif
        defer { save() }
        _ = model.entity(context: context())
    }
    public func getAlbum(id: Int) -> Album? {
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
    public func getArtist(id: Int) -> Artist? {
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
    public func getMV(id: Int64) -> MV? {
        var mv: MV? = nil
        let context = self.context()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MV")
        fetchRequest.predicate = NSPredicate(format: "%K == \(id)", "id")
        do {
            mv = try context.fetch(fetchRequest).first as? MV
        }catch let error {
            print("\(#function):\(error)")
        }
        return mv
    }
    public func getMVs(ids: [Int64]) -> [MV]? {
        var mvs: [MV]? = nil
        let context = self.context()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MV")
        fetchRequest.predicate = NSPredicate(format: "%K IN %@", "id", ids)
        do {
            mvs = try context.fetch(fetchRequest) as? [MV]
        }catch let error {
            print("\(#function):\(error)")
        }
        return mvs
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
    public func getSong(id: Int) -> Song? {
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
    public func getSongs(ids: [Int]) -> [Song]? {
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
    public func save() {
        do {
            try context().save()
        }catch let error {
            #if DEBUG
            print("\(type(of: self)) \(#function) \(error)")
            #endif
        }
    }
    public func updateAlbum(model: AlbumDetailResponse) {
        defer { save() }
        
        let album = model.album.entity(context: context())
        album.songsId = model.songs.map({ Int64($0.id) })
        model.album.artists.forEach { item in
            if let artist = getArtist(id: item.id) {
                album.addToArtists(artist)
            }else {
                let artist = item.entity(context: context())
                album.addToArtists(artist)
            }
        }
        model.songs.forEach { item in
            let song = item.entity(context: context())
            album.addToSongs(song)
            item.ar.forEach { item in
                if let artist = getArtist(id: item.id) {
                    song.addToArtists(artist)
                }else {
                    let artist = item.entity(context: context())
                    song.addToArtists(artist)
                }
            }
        }
    }
    public func updateAlbumSongs(id: Int, songsId: [Int]) {
        if let album = self.getAlbum(id: id) {
            if let songs = album.songs {
                album.removeFromSongs(songs)
            }
            album.songsId = songsId.map({ Int64($0) })
            if let songs = self.getSongs(ids: songsId) {
                album.addToSongs(NSSet(array: songs))
            }
            self.save()
        }
    }
    public func updateArtist(model: ArtistResponse) {
        defer { save() }
        _ = model.entity(context: context())
    }
    public func updateArtist(artistModel: ArtistResponse, introduction: String) {
        defer { save() }
        let artist = artistModel.entity(context: context())
        artist.introduction = introduction
    }
    public func updateArtistAlbums(id: Int, model: ArtistAlbumsResponse) {
        defer { save() }
        if let artist = getArtist(id: id) {
            if let albums = artist.albums {
                artist.removeFromAlbums(albums)
            }
            model.hotAlbums.forEach { item in
                if let album = getAlbum(id: item.id) {
                    album.addToArtists(artist)
                }else {
                    let album = item.entity(context: context())
                    album.addToArtists(artist)
                }
            }
        }
    }
    public func updateArtistMVs(id: Int64, mvIds: [Int64]) {
        if let artist = self.getArtist(id: Int(id)) {
            if let mvs = artist.mvs {
                artist.removeFromMvs(mvs)
            }
            if let mvs = self.getMVs(ids: mvIds) {
                artist.addToMvs(NSSet(array: mvs))
            }
            self.save()
        }
    }
    public func updateArtistHotSongs(to id: Int, songsId: [Int]) {
        defer { save() }
        guard let artist = getArtist(id: id) else { return }
        if let songs = artist.hotSongs {
            artist.removeFromHotSongs(songs)
        }
        artist.hotSongsId = songsId.map({ Int64($0) })
        if let songs = getSongs(ids: songsId) {
            artist.addToHotSongs(NSSet(array: songs))
        }
    }
    
    public func updateMV(model: ArtistMVResponse) {
        defer { save() }
        model.mvs.forEach { item in
            let mv = item.entity(context: context())
            if let artist = getArtist(id: item.artist.id) {
                artist.addToMvs(mv)
            }else {
                let artist = item.artist.entity(context: context())
                artist.addToMvs(mv)
            }
        }
    }
    public func updatePlaylistSongs(id: Int, songsId: [Int]) {
        defer { save() }

        if let playlist = getPlaylist(id: Int64(id)) {
            if let songs = playlist.songs {
                playlist.removeFromSongs(songs)
            }
            playlist.songsId = songsId.map({Int64($0)})
            if let songs = getSongs(ids: songsId) {
                playlist.addToSongs(NSSet(array: songs))
            }
        }
    }
    
    public func updateRecommendSongsPlaylistSongs(ids: [Int]) {
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
    
    public func updateSongs(model: ArtistHotSongsResponse) {
        defer { save() }
        model.hotSongs.forEach { item in
            let song = item.entity(context: self.context())
            if let album = getAlbum(id: item.album.id) {
                album.addToSongs(song)
            }else {
                let album = item.album.entity(context: self.context())
                album.addToSongs(song)
            }
            for ar in item.artists {
                if let artist = getArtist(id: Int(ar.id)) {
                    artist.addToSongs(song)
                }else {
                    let artist = ar.entity(context: context())
                    artist.addToSongs(song)
                }
            }
        }
    }
    
    public func updateSongs(model: [SongResponse]) {
        defer { save() }
        model.forEach { item in
            let song = item.entity(context: context())
            if let album = getAlbum(id: item.al.id) {
                album.addToSongs(song)
            }else {
                let album = item.al.entity(context: context())
                album.addToSongs(song)
            }
            item.ar.forEach { item in
                if let artist = getArtist(id: Int(item.id)) {
                    artist.addToSongs(song)
                }else {
                    let artist = item.entity(context: context())
                    artist.addToSongs(song)
                }
            }
        }
    }
    
    public func updateUserPlaylist(model: UserPlaylistResponse) {
        defer { save() }
        model.playlist.forEach { item in
            _ = item.entity(context: context())
        }
    }
}
