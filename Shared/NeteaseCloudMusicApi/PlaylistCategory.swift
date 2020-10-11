//
//  PlaylistCategory.swift
//  Qin
//
//  Created by 林少龙 on 2020/10/10.
//
extension NeteaseCloudMusicApi {
    //歌单分类
    func playlistCategories(complete: @escaping CompletionBlock) {
        let url = "https://music.163.com/weapi/playlist/catalogue"
        let data = [String : Any]()
        cancelDict["\(#function)"] = httpRequest(method: .POST, url: url, data: encrypt(text: data.json), complete: complete)
    }
    
    struct PlaylistCategory: Codable {
        var _0: String
        var _1: String
        var _2: String
        var _3: String
        var _4: String
        enum CodingKeys: String, CodingKey {
            case _0 = "0"
            case _1 = "1"
            case _2 = "2"
            case _3 = "3"
            case _4 = "4"
        }
    }

    struct PlaylistSubCategory: Codable {
        var activity: Bool
        var category: Int
        var hot: Bool
        var imgId: Int
        var imgUrl: String?
        var name: String
        var resourceCount: Int
        var resourceType: Int
        var type: Int
    }
}
