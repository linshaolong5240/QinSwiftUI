//
//  AppError.swift
//  Qin
//
//  Created by 林少龙 on 2020/6/17.
//  Copyright © 2020 teenloong. All rights reserved.
//

import Foundation

enum AppError: Error, Identifiable {
    var id: String { localizedDescription }
    case albumSub
    case artist(code: Int, message: String)
    case artistAlbum(code: Int, message: String)
    case artistIntroduction(code: Int, message: String)
    case artistMV(code: Int, message: String)
    case artistSub(code: Int, message: String)
    case comment(code: Int, message: String)
    case commentMusic
    case httpRequest
    case jsonObject(message: String? = nil)
    case like
    case likelist
    case loginError(code: Int, message: String)
    case loginRefresh(code: Int, message: String)
    case lyricError
    case mvDetailError(code: Int, message: String)
    case neteaseCloudMusic(error: Error)
    case playlistCategories(code: Int, message: String)
    case playlistCreateError
    case playlistDeleteError
    case playlistDetailError
    case playlistOrderUpdateError(code: Int, message: String)
    case playlistSubscribeError
    case playlistTracksError(code: Int, message: String)
    case recommendSongsError
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
        case .albumSub: return "Album sub or unsub failure"
        case .artist(let code, let message): return errorFormat(error: "获取歌手信息错误", code: code, message: message)
        case .artistAlbum(let code, let message): return errorFormat(error: "获取歌手专辑错误", code: code, message: message)
        case .artistIntroduction(let code, let message): return errorFormat(error: "获取歌手描述错误", code: code, message: message)
        case .artistMV(let code, let message): return errorFormat(error: "获取歌手MV错误", code: code, message: message)
        case .artistSub(let code, let message): return errorFormat(error: "收藏或取消收藏歌手错误", code: code, message: message)
        case .comment(let code, let message): return errorFormat(error: "发送评论错误", code: code, message: message)
        case .commentMusic: return "获取评论错误"
        case .httpRequest: return "网络请求错误"
        case .jsonObject(let message): return "jsonObject error: \(message ?? "")"
        case .like: return "喜欢或取消喜欢歌曲错误"
        case .likelist: return "获取喜欢的音乐列表错误"
        case .loginError(let code, let message): return errorFormat(error: "账号或密码错误", code: code, message: message)
        case .loginRefresh(let code, let message): return errorFormat(error: "刷新登录状态错误", code: code, message: message)
        case .lyricError: return "获取歌词错误"
        case .mvDetailError(let code, let message): return errorFormat(error: "获取MV详情错误", code: code, message: message)
        case .neteaseCloudMusic(let error): return "NeteaseCloudMusic:\n\(error)"
        case .playlistCategories(let code, let message): return errorFormat(error: "获取歌单分类错误", code: code, message: message)
        case .playlistCreateError: return "新建歌单错误"
        case .playlistDeleteError: return "删除歌单错误"
        case .playlistDetailError: return "获取歌单详情错误"
        case .playlistOrderUpdateError(let code, let message): return errorFormat(error: "歌单排序错误", code: code, message: message)
        case .playlistSubscribeError: return "歌单订阅错误"
        case .playlistTracksError(let code, let message): return errorFormat(error: "歌单添加或删除歌曲错误", code: code, message: message)
        case .recommendSongsError: return "获取每日推荐歌曲错误"
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
