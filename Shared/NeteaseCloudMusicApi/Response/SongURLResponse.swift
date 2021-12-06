//
//  SongURLResponse.swift
//  Qin
//
//  Created by 林少龙 on 2021/6/6.
//

import Foundation

public struct SongURLResponse: NeteaseCloudMusicResponse {
    public struct SongData: Codable {
        public var br: Int
        public var canExtend: Bool
        public var code: Int
//        public var encodeType: Any?
        public var expi, fee, flag: Int
//        public var freeTimeTrialPrivilege: FreeTimeTrialPrivilege
//        public var freeTrialInfo: FreeTrialInfo
//        public var freeTrialPrivilege: FreeTrialPrivilege
        public var gain, id: Int
//        public var level: Any?
        public var md5: String?
        public var payed, size: Int
        public var type: String?
//        public var uf: Any?
        public var url: String?
        public var urlSource: Int
    }
    public var code: Int
    public var data: [SongData]
    public var message: String?
}
