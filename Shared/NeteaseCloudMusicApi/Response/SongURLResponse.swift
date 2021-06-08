//
//  SongURLResponse.swift
//  Qin
//
//  Created by 林少龙 on 2021/6/6.
//

import Foundation

public struct SongURLResponse: NeteaseCloudMusicResponse {
    public struct SongData: Codable {
        public let br: Int
        public let canExtend: Bool
        public let code: Int
//        public let encodeType: Any?
        public let expi, fee, flag: Int
//        public let freeTimeTrialPrivilege: FreeTimeTrialPrivilege
//        public let freeTrialInfo: FreeTrialInfo
//        public let freeTrialPrivilege: FreeTrialPrivilege
        public let gain, id: Int
//        public let level: Any?
        public let md5: String?
        public let payed, size: Int
        public let type: String
//        public let uf: Any?
        public let url: String?
        public let urlSource: Int
    }
    public let code: Int
    public let data: [SongData]
}
