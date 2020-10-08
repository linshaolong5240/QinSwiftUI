//
//  SongURL.swift
//  Qin
//
//  Created by 林少龙 on 2020/10/7.
//

import Foundation

struct SongURL: Codable {
    var br: Int
    var id: Int
    var level: String?
    var payed: Int
    var size: Int
    var type: String?
    var url: String?
}
