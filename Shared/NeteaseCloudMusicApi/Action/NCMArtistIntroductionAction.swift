//
//  NCMArtistIntroductionAction.swift
//  Qin
//
//  Created by 林少龙 on 2021/6/11.
//  Copyright © 2022 com.teenloong. All rights reserved.
//

import Foundation
//歌手介绍
public struct NCMArtistIntroductionAction: NCMAction {
    public struct ArtisIntroductionParameters: Encodable {
        public var id: Int
    }
    public typealias Parameters = ArtisIntroductionParameters
    public typealias Response = NCMArtistIntroductionResponse

    public var uri: String { "/weapi/artist/introduction" }
    public var parameters: Parameters?
    public var responseType = Response.self
    
    public init(id: Int) {
        self.parameters = Parameters(id: id)
    }
}

public struct NCMArtistIntroductionResponse: NCMResponse {
    public struct Introduction: Codable {
        public var ti: String
        public var txt: String
    }
    public struct TopicData: Codable {
        
    }
    public var briefDesc: String
    public var code: Int
    public var count: Int
    public var introduction: [Introduction]
    public var topicData: [TopicData]?
    public var message: String?
}

extension NCMArtistIntroductionResponse {
    var desc: String {
        let introduction = introduction.map { item in
            "\(item.ti)\n\(item.txt)"
        }.joined(separator: "\n")
        return "\(briefDesc)\n\(introduction)"
    }
}
