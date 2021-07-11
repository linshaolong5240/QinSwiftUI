//
//  AppAction.swift
//  Qin
//
//  Created by 林少龙 on 2020/6/15.
//  Copyright © 2020 teenloong. All rights reserved.
//

import Foundation

enum AppAction {
    case albumDetailRequest(id: Int)
    case albumDetailRequestDone(result: Result<[Int], AppError>)
    case albumSubRequest(id: Int, sub: Bool)
    case albumSubRequestDone(result: Result<Bool, AppError>)
    case albumSublistRequest(limit: Int = 999, offset: Int = 0)
    case albumSublistRequestDone(result: Result<AlbumSublistResponse, AppError>)
    case artistDetailRequest(id: Int)
    case artistDetailRequestDone(result: Result<[Int], AppError>)
    case artistAlbumsRequest(id: Int, limit: Int = 999, offset: Int = 0)
    case artistAlbumsRequestDone(result: Result<[Int], AppError>)
    case artistMVsRequest(id: Int, limit: Int = 999, offset: Int = 0, total: Bool = true)
    case artistMVsRequestDone(result: Result<ArtistMVResponse, AppError>)
    case artistSubRequest(id: Int, sub: Bool)
    case artistSubRequestDone(result: Result<Bool, AppError>)
    case artistSublistRequest(limit: Int = 999, offset: Int = 0)
    case cloudUploadRequest(objectKey: String, token: String, md5: String, size: Int, data: Data)
    case cloudUploadCheckRequest(fileURL: URL)
    case cloudUploadTokenRequest(filename: String, md5: String)
    case artistSublistRequestDone(result: Result<ArtistSublistResponse, AppError>)
    case commentRequest(id: Int = 0, commentId: Int? = nil, content: String? = nil, type: CommentType, action: CommentAction)
    case commentDoneRequest(result: Result<(id: Int, type: CommentType, action: CommentAction), AppError>)
    case commentLikeRequest(id: Int, cid: Int, like: Bool, type: CommentType)
    case commentLikeDone(result: Result<Int, AppError>)
    case commentMusicRequest(rid: Int, limit: Int = 20, offset: Int = 0, beforeTime: Int = 0)
    case commentMusicRequestDone(result: Result<CommentSongResponse, AppError>)
    case commentMusicLoadMoreRequest
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
    case mvURLRequest(id: Int)
//    case mvUrlDone(result: Result<String, AppError>)
    case playerPause
    case playerPlay
    case playerPlayBackward
    case playerPlayBy(index: Int)
    case playerPlayForward
    case playerPlayMode
    case playerPlayRequest(id: Int)
    case playerPlayRequestDone(result: Result<String?, AppError>)
    case playerPlayOrPause
    case PlayerPlayToendAction
    case playerReplay
    case playerSeek(isSeeking: Bool, time: Double)
    case playinglistInsert(id: Int)
    case PlayinglistSet(playinglist: [Int], index: Int)
    case playlistCatalogueRequest
    case playlistCatalogueRequestsDone(result: Result<[PlaylistCatalogue], AppError>)
    case playlistCreateRequest(name: String, privacy: PlaylistCreateAction.Privacy = .common)
    case playlistCreateRequestDone(result: Result<Int, AppError>)
    case playlistDeleteRequest(pid: Int)
    case playlistDeleteRequestDone(result: Result<Int, AppError>)
    case playlistDetailRequest(id: Int)
    case playlistDetailRequestDone(result: Result<PlaylistResponse, AppError>)
    case playlistDetailSongsRequest(playlist: PlaylistResponse)
    case playlistDetailSongsRequestDone(result: Result<[Int], AppError>)
    case playlistOrderUpdateRequesting(ids: [Int])
    case playlistOrderUpdateDone(result: Result<Bool, AppError>)
    case playlistSubscibeRequest(id: Int, sub: Bool)
    case playlistSubscibeRequestDone(result: Result<Int, AppError>)
    case playlistTracksRequest(pid: Int, ids: [Int], op: Bool)
    case playlistTracksRequestDone(result: Result<Int, AppError>)
    case recommendPlaylistRequest
    case recommendPlaylistRequestDone(result: Result<RecommendPlaylistResponse, AppError>)
    case recommendSongsRequest
    case recommendSongsRequestDone(result: Result<[Int], AppError>)
    case searchRequest(keyword: String, type: SearchType = .song, limit: Int = 10, offset: Int = 0)
    case searchSongRequestDone(result: Result<[Int], AppError>)
    case searchPlaylistRequestDone(result: Result<SearchPlaylistResponse, AppError>)
    case songLikeRequest(id: Int, like: Bool)
    case songLikeRequestDone(result: Result<Bool, AppError>)
    case songLikeListRequest(uid: Int? = nil)
    case songLikeListRequestDone(result: Result<[Int], AppError>)
    case songsDetailRequest(ids: [Int])
    case songsDetailRequestDone(result: Result<[Int], AppError>)
    case songLyricRequest(id: Int)
    case songLyricRequestDone(result: Result<String?, AppError>)
    case songsOrderUpdateRequesting(pid: Int, ids: [Int])
    case songsOrderUpdateRequestDone(result: Result<Int, AppError>)
    case songsURLRequest(ids: [Int])
    case songsURLRequestDone(result: Result<SongURLResponse, AppError>)
    case userCloudRequest
    case userPlaylistRequest(uid: Int? = nil, limit: Int = 999, offset: Int = 0)
    case userPlaylistRequestDone(result: Result<[PlaylistResponse], AppError>)
}
