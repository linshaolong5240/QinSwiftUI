//
//  UserPlaylist.swift
//  Qin
//
//  Created by 林少龙 on 2020/10/30.
//

import Foundation

struct UserPlaylistModel: Codable {
    var coverImgUrl: String?
    var id: Int64
    var name: String
    var subscribed: Bool
    var trackCount: Int64
    var userId: Int64
}
