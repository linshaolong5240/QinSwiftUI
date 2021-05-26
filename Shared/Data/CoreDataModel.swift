//
//  CoreDataModel.swift
//  Qin
//
//  Created by 林少龙 on 2021/5/26.
//

import Foundation
extension AlbumSublistResponse.Album {
    struct AlbumSubModel: Codable, Identifiable {
        var id: Int64
        var name: String
        var picUrl: String
    }
    var dataModel: AlbumSubModel {
        AlbumSubModel(id: Int64(id), name: name, picUrl: picUrl)
    }
}
