//
//  NeteaseCloudMusicApi.swift
//  Qin
//
//  Created by 林少龙 on 2020/5/1.
//  Copyright © 2020 teenloong. All rights reserved.
//
import Foundation
import CryptoSwift
import Security
import Combine

class NeteaseCloudMusicApi {
    static let shared = NeteaseCloudMusicApi()
    
    //    var cancel = AnyCancellable({})
    var cancelDict = [String: AnyCancellable]()
    //crypto
    let nonce = "0CoJUm6Qyw8W8jud"
    let iv = "0102030405060708"
    let pubKey = "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDgtQn2JZ34ZC28NWYpAUd98iZ37BUrX/aKzmFbt7clFSs6sXqHauqKWqdtLkF2KexO40H1YTX8z2lSgBBOAxLsvaklV8k4cBFK9snQXE9/DDaFt6Rr7iVZMldczhC0JNgTz+SHXT6CBHuX3e9SdB1Ua44oncaTWz7OBGLbCiK45wIDAQAB"
    init() {
        let cookie = HTTPCookie(properties: [.name : "os",
                                             .value: "pc",
                                             .domain: ".music.163.com",
                                             .path: "/"])
        HTTPCookieStorage.shared.setCookie(cookie!)
    }
}

extension String {
    func plusSymbolToPercent() -> String {
        return self.replacingOccurrences(of: "+", with: "%2B")
    }
}


extension NeteaseCloudMusicApi {
    enum SearchType: Int {
        case song = 1
        case album = 10
        case artist = 100
        case playlist = 1000
        case user = 1002
        case mv = 1004
        case lyric = 1006
        case fm = 1009
        case vedio = 1014
    }
    enum CommentType: String {
        case song = "R_SO_4_"//  歌曲
        case mv = "R_MV_5_"//  MV
        case playlist = "A_PL_0_"//  歌单
        case album = "R_AL_3_"//  专辑
        case dj = "A_DJ_1_"//  电台
        case vedio = "R_VI_62_"//  视频
        case event = "A_EV_2_"//  动态
    }
    enum CommentAction: String {
        case add = "add"
        case delete = "delete"
        case reply = "reply"
    }
}

extension NeteaseCloudMusicApi {
    public static func parseErrorMessage(_ data: [String: Any]) -> (code: Int, message: String) {
        var code: Int = -1
        var message: String = "no message"
        if let c = data["code"] as? Int {
            code = c
        }
        if let m = data["message"] as? String {
            message = m
        }
        return (code,message)
    }
}

extension NeteaseCloudMusicApi {
    // 专辑内容
    func album(id: Int64, complete: @escaping CompletionBlock) {
        let url = "https://music.163.com/weapi/v1/album/\(id)"
        let data = [String: Any]()
        cancelDict["\(#function)"] = httpRequest(method: .POST, url: url, data: encrypt(text: data.json), complete: complete)
    }
    // 数字专辑详情
    func albumDetail(id: Int64, complete: @escaping CompletionBlock) {
        let url = "https://music.163.com/weapi/vipmall/albumproduct/detail"
        let data = ["id": id]
        cancelDict["\(#function)"] = httpRequest(method: .POST, url: url, data: encrypt(text: data.json), complete: complete)
    }
    // 收藏与取消收藏专辑
    func albumSub(id: Int64, sub: Bool, complete: @escaping CompletionBlock) {
        let action = sub ? "sub" : "unsub"
        let url = "https://music.163.com/weapi/album/\(action)"
        let data = [
            "id": id,
        ] as [String : Any]
        cancelDict["\(#function)"] = httpRequest(method: .POST, url: url, data: encrypt(text: data.json), complete: complete)
    }
    // 专辑收藏列表
    func albumSublist(limit: Int, offset: Int, complete: @escaping CompletionBlock) {
        let url = "https://music.163.com/weapi/album/sublist"
        let data = [
            "limit": limit,
            "offset": offset * limit,
            "total": true
        ] as [String : Any]
        cancelDict["\(#function)"] = httpRequest(method: .POST, url: url, data: encrypt(text: data.json), complete: complete)
    }
    // 歌手专辑
    func artistAlbum(id: Int64, limit: Int = 30, offset: Int = 0, complete: @escaping CompletionBlock) {
        let url = "https://music.163.com/weapi/artist/albums/\(id)"
        let data = [
            "limit": limit,
            "offset": offset * limit,
            "total": true
        ] as [String : Any]
        cancelDict["\(#function)"] = httpRequest(method: .POST, url: url, data: encrypt(text: data.json), complete: complete)
    }
    // 歌手MV
    func artistMV(id: Int64, limit: Int = 30, offset: Int = 0, complete: @escaping CompletionBlock) {
        let url = "https://music.163.com/weapi/artist/mvs"
        let data = [
            "artistId": id,
            "limit": limit,
            "offset": offset * limit,
            "total": true
        ] as [String : Any]
        cancelDict["\(#function)"] = httpRequest(method: .POST, url: url, data: encrypt(text: data.json), complete: complete)
    }
    // 收藏与取消收藏歌手
    func artistSub(id: Int64, sub: Bool, complete: @escaping CompletionBlock) {
        let action = sub ? "sub" : "unsub"
        let url = "https://music.163.com/weapi/artist/\(action)"
        let data = [
            "artistId": id,
            "artistIds": "[\(id)]"
        ] as [String : Any]
        cancelDict["\(#function)"] = httpRequest(method: .POST, url: url, data: encrypt(text: data.json), complete: complete)
    }
    // 歌手收藏列表
    func artistSublist(limit: Int = 30, offset: Int = 0, complete: @escaping CompletionBlock) {
        let url = "https://music.163.com/weapi/artist/sublist"
        let data = [
            "limit": limit,
            "offset": offset * limit,
            "total": true
        ] as [String : Any]
        cancelDict["\(#function)"] = httpRequest(method: .POST, url: url, data: encrypt(text: data.json), complete: complete)
    }
    // 歌手单曲
    func artists(id: Int64, complete: @escaping CompletionBlock) {
        let url = "https://music.163.com/weapi/artist/\(id)"
        let data = ResponseData()
        cancelDict["\(#function)"] = httpRequest(method: .POST, url: url, data: encrypt(text: data.json), complete: complete)
    }
    //歌手介绍
    func artistIntroduction(id: Int64, complete: @escaping CompletionBlock) {
        let url = "https://music.163.com/weapi/artist/introduction"
        let data = ["id": id]
        cancelDict["\(#function)"] = httpRequest(method: .POST, url: url, data: encrypt(text: data.json), complete: complete)
    }
    // 发送与删除评论
    func comment(id: Int64, cid: Int64, content: String = "", type: CommentType, action: CommentAction, complete: @escaping CompletionBlock) {
        let url = "https://music.163.com/weapi/resource/comments/\(action.rawValue)"
        var data:[String : Any] = ["threadId": type.rawValue + String(id)]
        if type == .event {
            data["threadId"] = id
        }
        switch action {
        case .add:
            data["content"] = content
        case .delete:
            data["commentId"] = cid
        case .reply:
            data["commentId"] = cid
            data["content"] = content
        }
        cancelDict["\(#function)"] = httpRequest(method: .POST, url: url, data: encrypt(text: data.json), complete: complete)
    }
    // 点赞与取消点赞评论
    // 动态点赞不需要传入 id 参数，需要传入动态的 threadId 参数
    func commentLike(id: Int64, cid: Int64, like: Bool, type: CommentType, complete: @escaping CompletionBlock) {
        let like = like ? "like" : "unlike"
        let url = "https://music.163.com/weapi/v1/comment/\(like)"
        var data = ["threadId": type.rawValue + String(id),
                    "commentId": cid
        ] as [String : Any]
        if type == .event {
            data["threadId"] = id
        }
        cancelDict["\(#function)"] = httpRequest(method: .POST, url: url, data: encrypt(text: data.json), complete: complete)
    }
    //歌曲评论
//    说明 : 调用此接口 , 传入音乐 id 和 limit 参数 , 可获得该音乐的所有评论 ( 不需要 登录 )
//    必选参数 : id: 音乐 id
//    可选参数 : limit: 取出评论数量 , 默认为 20
//    offset: 偏移数量 , 用于分页 , 如 :( 评论页数 -1)*20, 其中 20 为 limit 的值
//    before: 分页参数,取上一页最后一项的 time 获取下一页数据(获取超过5000条评论的时候需要用到)
    func commentMusic(id: Int64, limit: Int = 20, offset: Int = 0, beforeTime: Int = 0, complete: @escaping CompletionBlock) {
        let url = "https://music.163.com/weapi/v1/resource/comments/R_SO_4_\(id)"
        let data = ["rid": id,
                    "limit": limit,
                    "offset": offset * limit,
                    "beforeTime": beforeTime
        ] as [String : Any]
        cancelDict["\(#function)"] = httpRequest(method: .POST, url: url, data: encrypt(text: data.json), complete: complete)
    }
    //喜欢或取消喜欢歌曲
    func like(id: Int64, like: Bool, complete: @escaping CompletionBlock) {
        let url = "https://music.163.com/weapi/radio/like?alg=itembased&trackId=\(id)&time=25"
        
        let data = ["trackId": id,
                    "like": like] as [String : Any]
        cancelDict["\(#function)"] = httpRequest(method: .POST, url: url, data: encrypt(text: data.json), complete: complete)
    }
    //喜欢音乐列表
    func likeList(uid: Int64, complete: @escaping CompletionBlock) {
        let url = "https://music.163.com/weapi/song/like/get"
        
        let data = ["uid": uid] as [String : Any]
        cancelDict["\(#function)"] = httpRequest(method: .POST, url: url, data: encrypt(text: data.json), complete: complete)
    }
    //登陆
    func login(email: String, password: String, complete: @escaping CompletionBlock) {
        let url = "https://music.163.com/weapi/login"
        
        let data = ["username": email,
                    "password": password.md5(),
                    "rememberLogin": "true"
        ]
        cancelDict["\(#function)"] = httpRequest(method: .POST, url: url, data: encrypt(text: data.json), complete: complete)
    }
    func loginRefresh(complete: @escaping CompletionBlock) {
        let url = "https://music.163.com/weapi/login/token/refresh"
        
        let data = [String: Any]()
        cancelDict["\(#function)"] = httpRequest(method: .POST, url: url, data: encrypt(text: data.json), complete: complete)
    }
    func logout(_ complete: @escaping CompletionBlock) {
        let url = "https://music.163.com/weapi/logout"
        
        let data = ResponseData()
        cancelDict["\(#function)"] = httpRequest(method: .POST, url: url, data: encrypt(text: data.json), complete: complete)
    }
    func lyric(id: Int64 ,complete: @escaping CompletionBlock) {
        let url = "https://music.163.com/weapi/song/lyric"
        
        let data = ["id": id,
                    "lv": -1,
                    "kv": -1,
                    "tv": -1,
        ]
        cancelDict["\(#function)"] = httpRequest(method: .POST, url: url, data: encrypt(text: data.json), complete: complete)
    }
    //MV详情
    func mvDetail(id: Int64 ,complete: @escaping CompletionBlock) {
        let url = "https://music.163.com/weapi/v1/mv/detail"
        
        let data = ["id": id]
        cancelDict["\(#function)"] = httpRequest(method: .POST, url: url, data: encrypt(text: data.json), complete: complete)
    }
    //MV链接
    func mvUrl(id: Int64 ,complete: @escaping CompletionBlock) {
        let url = "https://music.163.com/weapi/song/enhance/play/mv/url"
        
        let data:[String: Any] = ["id": id,
                                  "r": 1080]
        cancelDict["\(#function)"] = httpRequest(method: .POST, url: url, data: encrypt(text: data.json), complete: complete)
    }
    //获取分类歌单
    func playlist(cat: String, hot: Bool, limit: Int, offset: Int, complete: @escaping CompletionBlock) {
        let url = "https://music.163.com/weapi/playlist/list"
        let order = hot ? "hot" : "new"
        
        let data = [
            "cat": cat,
            "order": order,
            "limit": limit,
            "offset": limit * offset,
            "total": true,
          ] as [String : Any]
        cancelDict["\(#function)"] = httpRequest(method: .POST, url: url, data: encrypt(text: data.json), complete: complete)
    }
    //歌单分类
    func playlistCategories(complete: @escaping CompletionBlock) {
        let url = "https://music.163.com/weapi/playlist/catalogue"
        let data = [String : Any]()
        cancelDict["\(#function)"] = httpRequest(method: .POST, url: url, data: encrypt(text: data.json), complete: complete)
    }
    //新建歌单
    func playlistCreate(name: String, privacy: Int = 0, complete: @escaping CompletionBlock) {
        let url = "https://music.163.com/weapi/playlist/create"
        let data = [
            "name": name,
            "privacy": privacy,//0 为普通歌单，10 为隐私歌单
            ] as [String : Any]
        cancelDict["\(#function)"] = httpRequest(method: .POST, url: url, data: encrypt(text: data.json), complete: complete)
    }
    //删除歌单
    func playlistDelete(pid: Int64, complete: @escaping CompletionBlock) {
        let url = "https://music.163.com/weapi/playlist/delete"
        let data = [
            "pid": pid,
            ] as [String : Any]
        cancelDict["\(#function)"] = httpRequest(method: .POST, url: url, data: encrypt(text: data.json), complete: complete)
    }
    //歌单详情
    func playlistDetail(id: Int64, complete: @escaping CompletionBlock) {
        let url = "https://music.163.com/weapi/v3/playlist/detail"
        let data = [
            "id": id,
            "n": 100000,
            "s": 8
        ]
        cancelDict["\(#function)"] = httpRequest(method: .POST, url: url, data: encrypt(text: data.json), complete: complete)
    }
    //歌单顺序
    func playlistOrderUpdate(ids: [Int64], complete: @escaping CompletionBlock) {
        let url = "https://music.163.com/weapi/playlist/order/update"
        let data = [
            "ids": ids
        ]
        cancelDict["\(#function)"] = httpRequest(method: .POST, url: url, data: encrypt(text: data.json), complete: complete)
    }
    //歌单收藏
    func playlistSubscribe(id: Int64, sub: Bool, complete: @escaping CompletionBlock) {
        let t = sub ? "subscribe" : "unsubscribe"
        let url = "https://music.163.com/weapi/playlist/\(t)"
        let data = [
            "id": id
        ]
        cancelDict["\(#function)"] = httpRequest(method: .POST, url: url, data: encrypt(text: data.json), complete: complete)
    }
    //对歌单添加或删除歌曲
    func playlistTracks(pid: Int64, op: Bool, ids: [Int64], complete: @escaping CompletionBlock) {
        let op = op ? "add" : "del"
        let data = [
            "op": op,
            "pid": pid,
            "trackIds": "[" + ids.map(String.init).joined(separator: ",") + "]"
            ] as [String : Any]
        let url = "https://music.163.com/weapi/playlist/manipulate/tracks"
        cancelDict["\(#function)"] = httpRequest(method: .POST, url: url, data: encrypt(text: data.json), complete: complete)
    }
    //推荐歌单( 需要登录 )
    func recommendResource(complete: @escaping CompletionBlock) {
        let url = "https://music.163.com/weapi/v1/discovery/recommend/resource"
        let data = ResponseData()
        cancelDict["\(#function)"] = httpRequest(method: .POST, url: url, data: encrypt(text: data.json), complete: complete)
    }
    //推荐歌曲( 需要登录 )
    func recommendSongs(complete: @escaping CompletionBlock) {
        let url = "https://music.163.com/weapi/v3/discovery/recommend/songs"
        let data = ResponseData()
        cancelDict["\(#function)"] = httpRequest(method: .POST, url: url, data: encrypt(text: data.json), complete: complete)
    }
    //歌曲链接 // 1: 单曲, 10: 专辑, 100: 歌手, 1000: 歌单, 1002: 用户, 1004: MV, 1006: 歌词, 1009: 电台, 1014: 视频
    func search(keyword: String, type: SearchType = .song, limit: Int = 30, offset: Int = 0, complete: @escaping CompletionBlock) {
        let url = "https://music.163.com/weapi/search/get"
        let data = [
            "s": keyword,
            "type": type.rawValue,
            "limit": limit,
            "offset": offset
        ] as [String : Any]
        cancelDict["\(#function)"] = httpRequest(method: .POST, url: url, data: encrypt(text: data.json), complete: complete)
    }
    //歌曲顺序
    func songsOrderUpdate(pid: Int64, ids: [Int64], complete: @escaping CompletionBlock) {
        let url = "http://interface.music.163.com/weapi/playlist/manipulate/tracks"
        let data = [
            "pid": pid,
            "trackIds": ids,
            "op": "update"
            ] as [String : Any]
        cancelDict["\(#function)"] = httpRequest(method: .POST, url: url, data: encrypt(text: data.json), complete: complete)
    }
    //歌曲详情
    func songsDetail(ids: [Int64], complete: @escaping CompletionBlock) {
        let url = "https://music.163.com/weapi/v3/song/detail"
        let c = ids.map{"{" + "id:" + String($0) + "}"}.joined(separator: ",")
        let data = [
            "c": "[" + c + "]",
            "ids": "[" + ids.map(String.init).joined(separator: ",") + "]"
        ]
        cancelDict["\(#function)"] = httpRequest(method: .POST, url: url, data: encrypt(text: data.json), complete: complete)
    }
    //歌曲链接
    func songsURL(_ ids: [Int64], complete: @escaping CompletionBlock) {
        let url = "https://music.163.com/weapi/song/enhance/player/url"
        let data = [
            "ids": "[" + ids.map(String.init).joined(separator: ",") + "]",
            "br": 999000
            ] as [String : Any]
        cancelDict["\(#function)"] = httpRequest(method: .POST, url: url, data: encrypt(text: data.json), complete: complete)
    }
    //用户歌单
    func userPlayList(_ uid: Int64, complete: @escaping CompletionBlock) {
        let url = "https://music.163.com/weapi/user/playlist"
        let data = [
            "uid": uid,
            "limit": 1000,
            "offset": 0
        ]
        cancelDict["\(#function)"] = httpRequest(method: .POST, url: url, data: encrypt(text: data.json), complete: complete)
    }
}

//getCSRFToken
extension NeteaseCloudMusicApi {
    func getCSRFToken() -> String {
        if let cookies = HTTPCookieStorage.shared.cookies{
            for cookie in cookies {
                if cookie.name == "__csrf" {
                    return cookie.value
                }
            }
        }
        return ""
    }
}
//crypto
extension NeteaseCloudMusicApi {
    func encrypt(text: String) -> String {
        let secKey = generateSecretKey(size: 16)
        let encText = aesEncrypt(text: aesEncrypt(text: text, key: nonce, iv: iv)!, key: secKey, iv: iv)
        let encSecKey = rsaEncrypt(text: String(secKey.reversed()), pubKey: self.pubKey)
        return "params=\(encText!)&encSecKey=\(encSecKey)"
    }
    
    func aesEncrypt(text: String, key: String, iv: String) -> String? {
        do {
            let aes = try AES(key: Array<UInt8>(key.utf8), blockMode: CBC(iv: Array<UInt8>(iv.utf8)))
            let bytes = try aes.encrypt(Array(text.utf8))
            let data = Data(bytes: bytes, count: bytes.count)
            return data.base64EncodedString()
        }catch {
            print("erro: aesEncrypt")
        }
        return nil
    }
    
    func rsaEncrypt(text: String, pubKey: String) -> String {
        //        let keyString = pubKey.replacingOccurrences(of: "-----BEGIN RSA PUBLIC KEY-----\n", with: "").replacingOccurrences(of: "\n-----END RSA PUBLIC KEY-----", with: "")
        let keyData = Data(base64Encoded: pubKey)
        
        var attributes: CFDictionary {
            return [kSecAttrKeyType         : kSecAttrKeyTypeRSA,
                    kSecAttrKeyClass        : kSecAttrKeyClassPublic,
                    kSecAttrKeySizeInBits   : 1024,
                    kSecReturnPersistentRef : kCFBooleanTrue!] as CFDictionary
        }
        
        var error: Unmanaged<CFError>?
        let secKey = SecKeyCreateWithData(keyData! as CFData, attributes, &error)
        
        let encryptData = SecKeyCreateEncryptedData(secKey!,
                                                    SecKeyAlgorithm.rsaEncryptionRaw,
                                                    text.data(using: .utf8)! as CFData,
                                                    &error)
        if encryptData == nil {
            print("SecKeyCreateEncryptedData nil")
        }
        let data = encryptData! as Data
        
        if error != nil {
            print(error!)
        }
        return data.toHexString()
    }
    
    func generateSecretKey(size: Int) -> String {
        let base62 = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        var key = ""
        for _ in 1...size {
            key.append(base62.randomElement()!)
        }
        return key
    }
}

//httprequest
extension NeteaseCloudMusicApi {
    typealias ResponseData = Dictionary<String, Any>
    typealias CompletionBlock = (_ data: ResponseData?, _ error: AppError?) -> Void
    
    enum HttpMethod: String {
        case GET = "GET"
        case POST = "POST"
    }
    func httpRequest(method: HttpMethod, url: String, data: String?, complete: @escaping CompletionBlock) -> AnyCancellable {
        
        let httpHeader = [ //"Accept": "*/*",
            //"Accept-Encoding": "gzip,deflate,sdch",
            //"Connection": "keep-alive",
            "Content-Type": "application/x-www-form-urlencoded",
            "Host": "music.163.com",
            "Referer": "https://music.163.com",
            "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_5) AppleWebKit/603.2.4 (KHTML, like Gecko) Version/10.1.1 Safari/603.2.4"
        ]
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = httpHeader
        request.timeoutInterval = 10
        if method == .POST {
            request.httpBody = data?.plusSymbolToPercent().data(using: .utf8)
        }
        
        let cancel = URLSession.shared
            .dataTaskPublisher(for: request)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { finished in
                if case .failure(let error) = finished {
                    print(error)
                    complete(nil, .httpRequestError(error: error))
                }
            }) { (data, response) in
                #if DEBUG
                let cookies = HTTPCookieStorage.shared.cookies
                for cookie in cookies! {
                    print("name: \(cookie.name) value: \(cookie.value)")
                }
                #endif
                if let httpURLResponse = response as? HTTPURLResponse {
                    #if DEBUG
                    print("statusCode: \(httpURLResponse.statusCode)")
                    #endif
                    if httpURLResponse.statusCode == 200 {
                        if let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) {
                            let jsonDict = json as! ResponseData
                            complete(jsonDict, nil)
                        }
                    }else {
                        complete(nil, nil)
                    }
                }
        }
        return cancel
    }
}
