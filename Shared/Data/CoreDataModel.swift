//
//  CoreDataModel.swift
//  Qin
//
//  Created by 林少龙 on 2021/5/26.
//

import Foundation
import CoreData

extension AlbumSublistResponse.Album {
    struct AlbumSubDataModel: Codable, Identifiable {
        var id: Int64
        var name: String
        var picUrl: String
    }
    var dataModel: AlbumSubDataModel { AlbumSubDataModel(id: Int64(id), name: name, picUrl: picUrl) }
}

extension ArtistSublistResponse.Artist {
    struct ArtistSubDataModel: Codable, Identifiable {
        var id: Int64
        var name: String
        var img1v1Url: String?
    }
    var dataModel: ArtistSubDataModel { ArtistSubDataModel(id: Int64(id), name: name, img1v1Url: img1v1Url) }
}

extension CommonArtist {
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

extension AlbumResponse.AlbumDetail {
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

extension AlbumResponse.AlbumSong {
    func entity(context: NSManagedObjectContext) -> Song {
        let entity = Song(context: context)
        entity.durationTime = Int64(dt)
        entity.id = Int64(id)
        entity.name = name
        return entity
    }
}

extension AlbumResponse.AlbumSong.AlbumSongArtist {
    func entity(context: NSManagedObjectContext) -> Artist {
        let entity = Artist(context: context)
        entity.id = Int64(id)
        entity.name = name
        return entity
    }
}

extension ArtistAlbumsResponse.ArtistAlbum {
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
