//
//  AppAction.swift
//  Qin
//
//  Created by 林少龙 on 2020/6/15.
//  Copyright © 2020 teenloong. All rights reserved.
//

import Foundation

enum AppAction {
    case commentMusic(id: Int, limit: Int = 20, offset: Int = 0, beforeTime: Int = 0)
    case commentMusicDone(result: Result<([Comment],[Comment]), AppError>)
    case initAction
    case like(id: Int, like: Bool)
    case likelist(uid: Int)
    case likelistDone(result: Result<[Int], AppError>)
    case likeDone(result: Result<Bool, AppError>)
    case login(email: String, password: String)
    case loginDone(result: Result<User, AppError>)
    case logout
    case lyric(id: Int)
    case lyricDone(id: Int, result: Result<String, AppError>)
    case playlistCreate(name: String, privacy: Int = 0)
    case playlistCreateDone(result: Result<Bool, AppError>)
    case playlistDelete(pid: Int)
    case playlistDeleteDone(result: Result<Int, AppError>)
    case playlistDetail(id: Int)
    case playlistDetailDone(result: Result<Playlist, AppError>)
    case playlistOrderUpdate(ids: [Int], type: PlaylistType)
    case playlistOrderUpdateDone(result: Result<Bool, AppError>)
    case playlistSubscibe(id: Int, subscibe: Bool)
    case playlistSubscibeDone(result: Result<Bool, AppError>)
    case playlistTracks(pid: Int, op: Bool, ids: [Int])
    case playlistTracksDone(result: Result<Bool, AppError>)
    case recommendPlaylist
    case recommendPlaylistDone(result: Result<[RecommendPlaylist], AppError>)
    case recommendSongs
    case recommendSongsDone(result: Result<PlaylistViewModel, AppError>)
    case search(keyword: String, type: NeteaseCloudMusicApi.SearchType = .song, limit: Int = 30, offset: Int = 0)
    case searchClean
    case searchSongDone(result: Result<[SearchSongDetail], AppError>)
    case searchPlaylistDone(result: Result<[PlaylistViewModel], AppError>)
    case setPlayinglist(playinglist: [SongViewModel], index: Int)
    case songsDetail(ids: [Int])
    case songsDetailDone(result: Result<[SongDetail], AppError>)
    case songsOrderUpdate(pid: Int, ids: [Int])
    case songsOrderUpdateDone(result: Result<Int, AppError>)
    case songsURL(ids: [Int])
    case songsURLDone(result: Result<[SongURL], AppError>)
    case userPlaylist(uid: Int? = nil)
    case userPlaylistDone(uid: Int, result: Result<[PlaylistViewModel], AppError>)
    case showLoginView(show: Bool)
    case pause
    case play
    case playRequest(id: Int)
    case playRequestDone(result: Result<SongURL, AppError>)
    case playBackward
    case playByIndex(index: Int)
    case playForward
    case playModeToggle
    case playToendAction
    case replay
    case seek(isSeeking: Bool)
    case PlayerPlayOrPause
}
