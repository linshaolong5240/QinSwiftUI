//
//  PlaylistCategory.swift
//  Qin
//
//  Created by 林少龙 on 2020/10/11.
//

import Foundation

struct PlaylistCategoryViewModel: Identifiable {
    var id: Int
    var name: String
    var subCategories: [String]
}
