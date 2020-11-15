//
//  SongURLJSONModel.swift
//  Qin
//
//  Created by 林少龙 on 2020/10/7.
//

import Foundation

struct SongURLJSONModel: Codable {
    var br: Int
    var canExtend: Bool
    var code: Int
    var encodeType: String?
    var expi: Int
    var fee: Int
    var flag: Int
//    var freeTrialInfo: Any?
    var gain: Int
    var id: Int64
    var level: String?//standard, exhigh
    var md5: String?
    var payed: Int// 0 未购买 ， 3 已购买
    var size: Int
    var type: String?
//    var uf: Any?
    var url: String?
}
