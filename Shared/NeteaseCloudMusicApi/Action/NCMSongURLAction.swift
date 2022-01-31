//
//  NCMSongURLAction.swift
//  Qin
//
//  Created by 林少龙 on 2021/6/6.
//  Copyright © 2022 com.teenloong. All rights reserved.
//

import Foundation
//歌曲链接
public struct NCMSongURLAction: NCMAction {
    public struct SongURLParameters: Encodable {
        public var ids: String
        public var br: Int
        init(ids: [Int], br: Int = 999000) {
            self.ids = "[" + ids.map(String.init).joined(separator: ",") + "]"
            self.br = br
        }
    }
    public typealias Parameters = SongURLParameters
    public typealias Response = NCMSongURLResponse

    public var uri: String { "/weapi/song/enhance/player/url" }
    public var parameters: Parameters
    public var responseType = Response.self
    
    public init(ids: [Int], br: Int = 999000) {
        self.parameters = Parameters(ids: ids, br: br)
    }
}

public struct NCMSongURLResponse: NCMResponse {
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
