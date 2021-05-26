//
//  AppAction.swift
//  Qin
//
//  Created by 林少龙 on 2020/6/15.
//  Copyright © 2020 teenloong. All rights reserved.
//

import Foundation

enum AppAction {
    case album(id: Int64)
    case albumDone(result: Result<[Int64], AppError>)
    case albumSub(id: Int64, sub: Bool)
    case albumSubDone(result: Result<Bool, AppError>)
    case albumSublistRequest(limit: Int = 100, offset: Int = 0)
    case albumSublistRequestDone(result: Result<[Int64], AppError>)
    case artist(id: Int64)
    case artistDone(result: Result<ArtistJSONModel, AppError>)
    case artistAlbum(id: Int64,limit: Int = 100, offset: Int = 0)
    case artistAlbumDone(result: Result<[AlbumJSONModel], AppError>)
    case artistIntroduction(id: Int64)
    case artistIntroductionDone(result: Result<String?, AppError>)
    case artistMV(id: Int64,limit: Int = 100, offset: Int = 0)
    case artistMVDone(result: Result<[ArtistMVJSONModel], AppError>)
    case artistSub(id: Int64, sub: Bool)
    case artistSubDone(result: Result<Bool, AppError>)
    case artistSublistRequest(limit: Int = 30, offset: Int = 0)
    case artistSublistRequestDone(result: Result<[Int64], AppError>)
    case comment(id: Int64 = 0, cid: Int64 = 0, content: String = "", type: NeteaseCloudMusicApi.CommentType, action: NeteaseCloudMusicApi.CommentAction)
    case commentDone(result: Result<(id: Int64, cid: Int64, type: NeteaseCloudMusicApi.CommentType, action: NeteaseCloudMusicApi.CommentAction), AppError>)
    case commentLike(id: Int64, cid: Int64, like: Bool, type: NeteaseCloudMusicApi.CommentType)
    case commentMusic(id: Int64, limit: Int = 20, offset: Int = 0, beforeTime: Int = 0)
    case commentMusicDone(result: Result<([CommentJSONModel],[CommentJSONModel],Int), AppError>)
    case commentMusicLoadMore
    case coverShape
    case initAction
    case likeRequest(id: Int64, like: Bool)
    case likeRequestDone(result: Result<Bool, AppError>)
    case likelistRequest(uid: Int64? = nil)
    case likelistRequestDone(result: Result<[Int64], AppError>)
    case loginRequest(email: String, password: String)
    case loginRequestDone(result: Result<User, AppError>)
    case loginRefreshRequest
    case loginRefreshRequestDone(result: Result<Bool, AppError>)
    case logout
    case lyricRequest(id: Int64)
    case lyricRequestDone(result: Result<String?, AppError>)
    case mvDetailRequest(id: Int64)
    case mvDetaillRequestDone(result: Result<MVJSONModel, AppError>)
    case mvUrl(id: Int64)
//    case mvUrlDone(result: Result<String, AppError>)
    case playerPause
    case playerPlay
    case playerPlayBackward
    case playerPlayByIndex(index: Int)
    case playerPlayForward
    case playerPlayMode
    case playerPlayRequest(id: Int64)
    case playerPlayRequestDone(result: Result<SongURLJSONModel, AppError>)
    case playerPlayOrPause
    case PlayerPlayToendAction
    case playerReplay
    case playerSeek(isSeeking: Bool, time: Double)
    case playinglistInsert(id: Int64)
    case PlayinglistSet(playinglist: [Int64], index: Int)
    case playlist(category: String, hot: Bool = true, limit: Int = 30, offset: Int = 0)
    case playlistDone(result: Result<(playlists: [PlaylistViewModel], category: String, total: Int , more: Bool), AppError>)
    case playlistCategories
    case playlistCategoriesDone(result: Result<[PlaylistCategoryViewModel], AppError>)
    case playlistCreate(name: String, privacy: Int = 0)
    case playlistCreateDone(result: Result<Bool, AppError>)
    case playlistDelete(pid: Int64)
    case playlistDeleteDone(result: Result<Int64, AppError>)
    case playlistDetail(id: Int64)
    case playlistDetailDone(result: Result<PlaylistJSONModel, AppError>)
    case playlistDetailSongs(playlistJSONModel: PlaylistJSONModel)
    case playlistDetailSongsDone(result: Result<[Int64], AppError>)
    case playlistOrderUpdate(ids: [Int64])
    case playlistOrderUpdateDone(result: Result<Bool, AppError>)
    case playlistSubscibe(id: Int64, sub: Bool)
    case playlistSubscibeDone(result: Result<Int64, AppError>)
    case playlistTracks(pid: Int64, op: Bool, ids: [Int64])
    case playlistTracksDone(result: Result<Int64, AppError>)
    case recommendPlaylist
    case recommendPlaylistDone(result: Result<[Int64], AppError>)
    case recommendSongs
    case recommendSongsDone(result: Result<RecommendSongsJSONModel, AppError>)
    case search(keyword: String, type: NeteaseCloudMusicApi.SearchType = .song, limit: Int = 30, offset: Int = 0)
    case searchSongDone(result: Result<[Int64], AppError>)
    case searchPlaylistDone(result: Result<[PlaylistViewModel], AppError>)
    case songsDetail(ids: [Int64])
    case songsDetailDone(result: Result<[SongDetailJSONModel], AppError>)
    case songsOrderUpdate(pid: Int64, ids: [Int64])
    case songsOrderUpdateDone(result: Result<Int64, AppError>)
    case songsURL(ids: [Int64])
    case songsURLDone(result: Result<[SongURLJSONModel], AppError>)
    case userPlaylist(uid: Int64? = nil)
    case userPlaylistDone(result: Result<(createdPlaylistId: [Int64], subedPlaylistIds: [Int64], userPlaylistIds: [Int64]), AppError>)
}
