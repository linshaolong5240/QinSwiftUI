//
//  MVURLJSONModel.swift
//  Qin
//
//  Created by 林少龙 on 2020/12/24.
//

import Foundation

struct MVURLJSONModel: Codable, Identifiable {
    var code: Int
    var expi: Int
    var fee: Int
    var id: Int64
    var md5: String
    var msg: String
    var mvFee: Int
//    var promotionVo: Any?
    var r: Int//分辨率
    var size: Int
    var st: Int
    var url: String
}
