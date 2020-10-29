//
//  ArtistSub.swift
//  Qin
//
//  Created by 林少龙 on 2020/10/9.
//

import Foundation

struct ArtistSubJSONModel: Codable, Identifiable {
    var albumSize: Int
    var alias: [String]
    var id: Int
    var img1v1Url: String?
    var info: String
    var mvSize: Int
    var name: String
    var picId: Int
    var picUrl: String
    var trans: String?
}
