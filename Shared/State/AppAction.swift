//
//  AppAction.swift
//  Qin
//
//  Created by 林少龙 on 2020/6/15.
//  Copyright © 2020 teenloong. All rights reserved.
//

import Foundation

enum AppAction {
    case albumRequest(id: Int)
    case albumRequestDone(result: Result<[Int], AppError>)
    case albumSubRequest(id: Int64, sub: Bool)
    case albumSubRequestDone(result: Result<Bool, AppError>)
    case albumSublistRequest(limit: Int = 100, offset: Int = 0)
    case albumSublistRequestDone(result: Result<[Int64], AppError>)
    case artistRequest(id: Int64)
    case artistRequestDone(result: Result<[Int], AppError>)
    case artistAlbumRequest(id: Int64,limit: Int = 999, offset: Int = 0)
    case artistAlbumRequestDone(result: Result<[Int], AppError>)
    case artistMvRequest(id: Int, limit: Int = 999, offset: Int = 0, total: Bool = true)
    case artistMvRequestDone(result: Result<[Int], AppError>)
    case artistSubRequest(id: Int, sub: Bool)
    case artistSubRequestDone(result: Result<Bool, AppError>)
    case artistSublistRequest(limit: Int = 30, offset: Int = 0)
    case artistSublistRequestDone(result: Result<[Int64], AppError>)
    case commentRequest(id: Int64 = 0, cid: Int64 = 0, content: String = "", type: NeteaseCloudMusicApi.CommentType, action: NeteaseCloudMusicApi.CommentAction)
    case commentDoneRequest(result: Result<(id: Int64, cid: Int64, type: NeteaseCloudMusicApi.CommentType, action: NeteaseCloudMusicApi.CommentAction), AppError>)
    case commentLikeRequest(id: Int64, cid: Int64, like: Bool, type: NeteaseCloudMusicApi.CommentType)
    case commentMusicRequest(id: Int64, limit: Int = 20, offset: Int = 0, beforeTime: Int = 0)
    case commentMusicRequestDone(result: Result<([CommentJSONModel],[CommentJSONModel],Int), AppError>)
    case commentMusicLoadMore
    case coverShape
    case error(AppError)
    case initAction
    case loginRequest(email: String, password: String)
    case loginRequestDone(result: Result<LoginResponse, AppError>)
    case loginRefreshRequest
    case loginRefreshRequestDone(result: Result<Bool, AppError>)
    case logoutRequest
    case logoutRequestDone(result: Result<Int, AppError>)
    case mvDetailRequest(id: Int)
    case mvDetaillRequestDone(result: Result<Int, AppError>)
    case mvUrl(id: Int)
//    case mvUrlDone(result: Result<String, AppError>)
    case playerPause
    case playerPlay
    case playerPlayBackward
    case playerPlayByIndex(index: Int)
    case playerPlayForward
    case playerPlayMode
    case playerPlayRequest(id: Int64)
    case playerPlayRequestDone(result: Result<String?, AppError>)
    case playerPlayOrPause
    case PlayerPlayToendAction
    case playerReplay
    case playerSeek(isSeeking: Bool, time: Double)
    case playinglistInsert(id: Int64)
    case PlayinglistSet(playinglist: [Int64], index: Int)
    case playlistCatalogueRequest
    case playlistCatalogueRequestsDone(result: Result<[PlaylistCatalogue], AppError>)
    case playlistCreateRequest(name: String, privacy: PlaylistCreateAction.Privacy = .common)
    case playlistCreateRequestDone(result: Result<Int, AppError>)
    case playlistDelete(pid: Int)
    case playlistDeleteDone(result: Result<Int, AppError>)
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
    case recommendPlaylistRequest
    case recommendPlaylistDone(result: Result<[Int64], AppError>)
    case recommendSongsRequest
    case recommendSongsDone(result: Result<RecommendSongsJSONModel, AppError>)
    case search(keyword: String, type: NeteaseCloudMusicApi.SearchType = .song, limit: Int = 30, offset: Int = 0)
    case searchSongDone(result: Result<[Int64], AppError>)
    case searchPlaylistDone(result: Result<[PlaylistViewModel], AppError>)
    case songLikeRequest(id: Int, like: Bool)
    case songLikeRequestDone(result: Result<Bool, AppError>)
    case songLikeListRequest(uid: Int? = nil)
    case songLikeListRequestDone(result: Result<[Int], AppError>)
    case songsDetail(ids: [Int64])
    case songsDetailDone(result: Result<[SongDetailJSONModel], AppError>)
    case songLyricRequest(id: Int)
    case songLyricRequestDone(result: Result<String?, AppError>)
    case songsOrderUpdate(pid: Int64, ids: [Int64])
    case songsOrderUpdateDone(result: Result<Int64, AppError>)
    case songsURLRequest(ids: [Int])
    case songsURLRequestDone(result: Result<[SongURLJSONModel], AppError>)
    case userPlaylistRequest(uid: Int? = nil, limit: Int = 999, offset: Int = 0)
    case userPlaylistDone(result: Result<(createdPlaylistId: [Int], subedPlaylistIds: [Int], userPlaylistIds: [Int]), AppError>)
}
