//
//  Album.swift
//  Qin
//
//  Created by 林少龙 on 2020/10/5.
//

import Foundation

struct Album: Codable, Identifiable {
    var alias: [String]
    var artist: Artist
    var artists: [Artist]
    var blurPicUrl: String
    var briefDesc: String
    var commentThreadId: String
    var company: String?
    var companyId: Int
    var copyrightId: Int
    var description: String
    var id: Int
    var isSub: Bool?
    var mark: Int
    var name: String
    var onSale: Bool
    var paid: Bool
    var pic: Int
    var picId: Int
    var picId_str: String?
    var picUrl: String
    var publishTime: Int
    var size: Int
//    var songs: Any
    var status: Int
    var subType: String?
    var tags: String
    var type: String?
}
