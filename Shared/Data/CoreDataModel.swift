//
//  CoreDataModel.swift
//  Qin
//
//  Created by 林少龙 on 2021/5/26.
//

import Foundation
import CoreData

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

extension SongResponse.Al: CoreDataManged {
    func entity(context: NSManagedObjectContext) -> Album {
        let entity = Album(context: context)
        entity.id = Int64(id)
        entity.introduction = nil
        entity.name = name
        entity.picUrl = picUrl
//        entity.publishTime = Int64(publishTime)
        return entity
    }
}

extension SongResponse.Ar: CoreDataManged {
    func entity(context: NSManagedObjectContext) -> Artist {
        let entity = Artist(context: context)
//        entity.followed = followed
        entity.id = Int64(id)
        entity.img1v1Url = nil
        entity.introduction = nil
        entity.name = name
        return entity
    }
}

extension AlbumResponse: CoreDataManged {
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

extension ArtistResponse: CoreDataManged {
    func entity(context: NSManagedObjectContext) -> Artist {
        let entity = Artist(context: context)
        entity.id = Int64(id)
        entity.img1v1Url = img1v1Url
        entity.introduction = briefDesc
        entity.name = name
        return entity
    }
}

extension AlbumDetailResponse.AlbumSong: CoreDataManged {
    func entity(context: NSManagedObjectContext) -> Song {
        let entity = Song(context: context)
        entity.durationTime = Int64(dt)
        entity.id = Int64(id)
        entity.name = name
        return entity
    }
}

extension AlbumDetailResponse.AlbumSong.AlbumSongArtist: CoreDataManged {
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

extension RecommendSongsResponse: CoreDataManged {
    func entity(context: NSManagedObjectContext) -> Playlist {
        let entity = Playlist(context: context)
        entity.id = 0
        entity.name = "每日推荐"
        entity.introduction = "它聪明、熟悉每个用户的喜好，从海量音乐中挑选出你可能喜欢的音乐。\n它通过你每一次操作来记录你的口味"
        entity.songsId = data.dailySongs.map{ Int64($0.id) }
        return entity
    }
}
