//
//  NCMArtistAlbumsAction.swift
//  Qin
//
//  Created by 林少龙 on 2021/6/11.
//  Copyright © 2022 com.teenloong. All rights reserved.
//

import Foundation
//歌手专辑
public struct NCMArtistAlbumsAction: NCMAction {
    public struct ArtistAlbumsParameters: Encodable {
        public var limit: Int
        public var offset: Int
        public var total: Bool = true
    }
    public typealias Parameters = ArtistAlbumsParameters
    public typealias Response = NCMArtistAlbumsResponse

    public var id: Int
    public var uri: String { "/weapi/artist/albums/\(id)" }
    public var parameters: Parameters?
    public var responseType = Response.self
    
    public init(id: Int, limit: Int, offset: Int, total: Bool = true) {
        self.id = id
        self.parameters = .init(limit: limit, offset: offset, total: total)
    }
}

public struct NCMArtistAlbumsResponse: NCMResponse {
    public struct ArtistAlbum: Codable {
        public var alias: [String]
        public var artist: NCMArtistResponse
        public var artists: [NCMArtistResponse]
        public var blurPicUrl: String?
        public var briefDesc: String?
        public var commentThreadId: String
        public var company: String?
        public var companyId: Int
        public var description: String?
        public var id: Int
        public var isSub: Bool
        public var mark: Int
        public var name: String
        public var onSale: Bool
        public var paid: Bool
        public var pic: Int
        public var picId: Int
        public var picId_str: String?
        public var picUrl: String
        public var publishTime: Int
        public var size: Int
//        public var songs: [Any]
        public var status: Int
        public var subType: String?
        public var tags: String
        public var type: String
    }
    public var artist: NCMArtistResponse
    public var code: Int
    public var hotAlbums: [ArtistAlbum]
    public var more: Bool
    public var message: String?
}
