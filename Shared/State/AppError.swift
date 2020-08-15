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
    case commentMusic
    case like
    case likelist
    case lyricError
    case playlistCreateError
    case playlistDeleteError
    case playlistDetailError
    case playlistSubscribeError
    case playlistTracksError(code: Int?, message: String?)
    case searchError
    case songsDetailError
    case songsURLError
    case getUserPlayListError
    case httpRequestError(error: URLError)
    case loginError(code: Int, message: String)
    case playingError(message: String)
}

extension AppError {
    var localizedDescription: String {
        switch self {
        case .commentMusic:
            return "获取评论错误"
        case .like:
            return "喜欢或取消喜欢歌曲错误"
        case .likelist:
            return "获取喜欢的音乐列表错误"
        case .lyricError:
            return "获取歌词错误"
        case .playlistCreateError:
            return "新建歌单错误"
        case .playlistDeleteError:
            return "删除歌单错误"
        case .playlistDetailError:
            return "获取歌单详情错误"
        case .playlistSubscribeError:
            return "歌单订阅错误"
        case .playlistTracksError(let code, let message):
            if message != nil && code != nil {
                return "code: \(code!)\n\(message!)"
            }else {
                return "歌单添加或删除歌曲错误"
            }
        case .searchError:
            return "搜索错误"
        case .songsDetailError:
            return "获取歌曲详情错误"
        case .songsURLError:
            return "获取歌曲链接错误"
        case .getUserPlayListError:
            return "获取用户歌单错误"
        case .httpRequestError(let error):
            return error.localizedDescription
        case .loginError(let code, let message):
            return "账号或密码错误 code:\(code) message:\(message)"
        case .playingError(let message):
            return "播放错误： \(message)"
        }
    }
}
