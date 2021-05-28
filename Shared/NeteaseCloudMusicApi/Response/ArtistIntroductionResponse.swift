//
//  ArtistIntroductionResponse.swift
//  Qin
//
//  Created by 林少龙 on 2021/5/28.
//

import Foundation

public struct ArtistIntroductionResponse: NeteaseCloudMusicResponse {
    public struct Introduction: Codable {
        public let ti: String
        public let txt: String
    }
    public struct TopicData: Codable {
        
    }
    public let briefDesc: String
    public let code: Int
    public let count: Int
    public let introduction: [Introduction]
    public let topicData: [TopicData]?
}

extension ArtistIntroductionResponse {
    var desc: String {
        let introduction = introduction.map { item in
            "\(item.ti)\n\(item.txt)"
        }.joined(separator: "\n")
        return "\(briefDesc)\n\(introduction)"
    }
}
