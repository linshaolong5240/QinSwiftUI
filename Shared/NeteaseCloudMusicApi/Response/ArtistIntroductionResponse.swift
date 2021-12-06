//
//  ArtistIntroductionResponse.swift
//  Qin
//
//  Created by 林少龙 on 2021/5/28.
//

import Foundation

public struct ArtistIntroductionResponse: NeteaseCloudMusicResponse {
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

extension ArtistIntroductionResponse {
    var desc: String {
        let introduction = introduction.map { item in
            "\(item.ti)\n\(item.txt)"
        }.joined(separator: "\n")
        return "\(briefDesc)\n\(introduction)"
    }
}
