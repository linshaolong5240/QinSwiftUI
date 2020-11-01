//
//  SongModel.swift
//  Qin
//
//  Created by 林少龙 on 2020/10/28.
//

import Foundation
import CoreData

struct SongModel: Codable {
    var al: AlbumModel
    var ar: [ArtistModel]
    var id: Int64
    var name: String
//    private enum CodingKeys: String, CodingKey {
//        case album = "al"
//        case artists = "ar"
//        case id = "id"
//        case name = "name"
//    }
}
