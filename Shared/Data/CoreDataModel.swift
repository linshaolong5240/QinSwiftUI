//
//  CoreDataModel.swift
//  Qin
//
//  Created by 林少龙 on 2021/5/26.
//

import Foundation
import CoreData

extension AlbumSublistResponse.Album {
    struct AlbumSubDataModel: Codable {
        var id: Int64
        var name: String
        var picUrl: String
    }
    var dataModel: AlbumSubDataModel { AlbumSubDataModel(id: Int64(id), name: name, picUrl: picUrl) }
}

extension ArtistSublistResponse.Artist {
    struct ArtistSubDataModel: Codable {
        var id: Int64
        var name: String
        var img1v1Url: String?
    }
    var dataModel: ArtistSubDataModel { ArtistSubDataModel(id: Int64(id), name: name, img1v1Url: img1v1Url) }
}

extension PlaylistResponse: CoreDataManged {
    func entity(context: NSManagedObjectContext) -> Playlist {
        let entity = Playlist(context: context)
        entity.coverImgUrl = coverImgUrl
        entity.id = Int64(id)
        entity.name = name
        entity.subscribed = subscribed ?? false
        entity.trackCount = Int64(trackCount)
        return entity
    }
}

extension SongResponse: CoreDataManged {
    func entity(context: NSManagedObjectContext) -> Song {
        let entity = Song(context: context)
        entity.durationTime = Int64(dt)
        entity.id = Int64(id)
        entity.name = name
        return entity
    }
}

extension CommonAlbum: CoreDataManged {
    func entity(context: NSManagedObjectContext) -> Album {
        let entity = Album(context: context)
        entity.id = Int64(id)
        entity.introduction = description
        entity.name = name
        entity.picUrl = picUrl
        entity.publishTime = Int64(publishTime)
        return entity
    }
}

extension CommonArtistResponse: CoreDataManged {
    func entity(context: NSManagedObjectContext) -> Artist {
        let entity = Artist(context: context)
        entity.followed = followed
        entity.id = Int64(id)
        entity.img1v1Url = img1v1Url
        entity.introduction = briefDesc
        entity.name = name
        return entity
    }
}

extension AlbumResponse.AlbumSong: CoreDataManged {
    func entity(context: NSManagedObjectContext) -> Song {
        let entity = Song(context: context)
        entity.durationTime = Int64(dt)
        entity.id = Int64(id)
        entity.name = name
        return entity
    }
}

extension AlbumResponse.AlbumSong.AlbumSongArtist: CoreDataManged {
    func entity(context: NSManagedObjectContext) -> Artist {
        let entity = Artist(context: context)
        entity.id = Int64(id)
        entity.name = name
        return entity
    }
}

extension ArtistAlbumsResponse.ArtistAlbum: CoreDataManged {
    func entity(context: NSManagedObjectContext) -> Album {
        let entity = Album(context: context)
        entity.id = Int64(id)
        entity.introduction = description
        entity.name = name
        entity.picUrl = picUrl
        entity.publishTime = Int64(publishTime)
        return entity
    }
}

extension ArtistHotSongsResponse.HotSong: CoreDataManged {
    func entity(context: NSManagedObjectContext) -> Song {
        let entity = Song(context: context)
        entity.durationTime = Int64(duration)
        entity.id = Int64(id)
        entity.name = name
        return entity
    }
}

extension ArtistMVResponse.MV.Artist: CoreDataManged {
    func entity(context: NSManagedObjectContext) -> Artist {
        let entity = Artist(context: context)
        entity.followed = false
        entity.id = Int64(id)
        entity.img1v1Url = img1v1Url
        entity.introduction = briefDesc
        entity.name = name
        return entity
    }
}

extension ArtistMVResponse.MV: CoreDataManged {
    func entity(context: NSManagedObjectContext) -> MV {
        let entity = MV(context: context)
        entity.duration = Int64(duration)
        entity.id = Int64(id)
        entity.name = name
        return entity
    }
}
