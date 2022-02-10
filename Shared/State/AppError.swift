//
//  AppError.swift
//  Qin
//
//  Created by teenloong on 2020/6/17.
//  Copyright © 2020 teenloong. All rights reserved.
//

import Foundation

extension Error {
    func asAppError() -> AppError {
        .error(self)
    }
}

enum AppError: Error, Identifiable {
    var id: String { localizedDescription }
    case error(Error)
    case albumDetailRequest
    case albumSubRequest
    case albumSublistRequest
    case artistAlbumsRequest
    case artistDetailRequest
    case artistIntroduction(code: Int, message: String)
    case artistMVsRequest
    case artistSubRequest
    case artistSublistRequest
    case cloudSongAddRequest
    case cloudUploadCheckRequest
    case cloudUploadInfoRequest
    case cloudUploadTokenRequest
    case comment
    case commentLikeRequest
    case commentMusic
    case httpRequest
    case jsonObject(message: String? = nil)
    case like
    case likelist
    case loginRequest
    case loginRefreshRequest
    case logoutRequest
    case lyricError
    case mvDetailRequest
    case neteaseCloudMusic(code: Int, message: String?)
    case playlistCategoriesRequest
    case playlistCreateRequest
    case playlistDeleteError
    case playlistDetailError
    case playlistOrderUpdateError(code: Int, message: String)
    case playlistSubscribeError
    case playlistTracksError(code: Int, message: String)
    case recommendSongsError
    case recommendPlaylistRequest
    case searchError
    case songsDetailError
    case songsOrderUpdate
    case songsURLError
    case userPlaylistError
    case httpRequestError(error: Error)
    case playingError(message: String)
}

extension AppError {
    var localizedDescription: String {
        switch self {
        case .error(let error):  return error.localizedDescription
        case .albumDetailRequest: return "Album detail request failure"
        case .albumSubRequest: return "Album sub or unsub failure"
        case .albumSublistRequest: return "Album sublist failure"
        case .artistAlbumsRequest: return "Artist album request failure"
        case .artistDetailRequest: return "Artist detail request failure"
        case .artistIntroduction(let code, let message): return errorFormat(error: "获取歌手描述错误", code: code, message: message)
        case .artistMVsRequest: return "Artist mvs request failure"
        case .artistSubRequest: return "Artist sub request failure"
        case .artistSublistRequest: return "Artist sublist request failure"
        case .cloudSongAddRequest: return "Cloud song add request failure"
        case .cloudUploadCheckRequest: return "Cloud upload check request failure"
        case .cloudUploadInfoRequest: return "Cloud info request failure"
        case .cloudUploadTokenRequest: return "Cloud upload token request failure"
        case .comment: return "发送评论错误"
        case .commentLikeRequest: return "评论点赞错误"
        case .commentMusic: return "获取评论错误"
        case .httpRequest: return "网络请求错误"
        case .jsonObject(let message): return "jsonObject error: \(message ?? "")"
        case .like: return "喜欢或取消喜欢歌曲错误"
        case .likelist: return "获取喜欢的音乐列表错误"
        case .loginRequest: return "Login request failure"
        case .loginRefreshRequest: return "Login refresh request failure"
        case .logoutRequest: return "Logout request failure"
        case .lyricError: return "获取歌词错误"
        case .mvDetailRequest: return "MV Detail request failure"
        case .neteaseCloudMusic(let code, let message): return "NeteaseCloudMusic:\ncode:\(code)\nmessage:\(message ?? "")"
        case .playlistCategoriesRequest: return "Playlist categories request failure"
        case .playlistCreateRequest: return "Playlist create request failure"
        case .playlistDeleteError: return "删除歌单错误"
        case .playlistDetailError: return "获取歌单详情错误"
        case .playlistOrderUpdateError(let code, let message): return errorFormat(error: "歌单排序错误", code: code, message: message)
        case .playlistSubscribeError: return "歌单订阅错误"
        case .playlistTracksError(let code, let message): return errorFormat(error: "歌单添加或删除歌曲错误", code: code, message: message)
        case .recommendSongsError: return "获取每日推荐歌曲错误"
        case .recommendPlaylistRequest: return "获取每日推荐歌单错误"
        case .searchError: return "搜索错误"
        case .songsDetailError: return "获取歌曲详情错误"
        case .songsOrderUpdate: return "歌曲排序错误"
        case .songsURLError: return "获取歌曲链接错误"
        case .userPlaylistError: return "获取用户歌单错误"
        case .httpRequestError(let error): return error.localizedDescription
        case .playingError(let message): return "播放错误： \(message)"
        }
    }
    private func errorFormat(error: String, code: Int, message: String) -> String {
        return "\(error)\n\(code)\n\(message)"
    }
}
