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

extension NeteaseCloudMusicApi {
    // 专辑内容
    func album(id: Int, complete: @escaping CompletionBlock) {
        let url = "https://music.163.com/weapi/v1/album/\(id)"
        let data = [String: Any]()
        cancelDict["\(#function)"] = httpRequest(method: .POST, url: url, data: encrypt(text: data.json), complete: complete)
    }
    // 数字专辑详情
    func albumDetail(id: Int, complete: @escaping CompletionBlock) {
        let url = "https://music.163.com/weapi/vipmall/albumproduct/detail"
        let data = ["id": id]
        cancelDict["\(#function)"] = httpRequest(method: .POST, url: url, data: encrypt(text: data.json), complete: complete)
    }
    // 收藏与取消收藏专辑
    func albumSub(id: Int, sub: Bool, complete: @escaping CompletionBlock) {
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
    func artistAlbum(id: Int, limit: Int = 30, offset: Int = 0, complete: @escaping CompletionBlock) {
        let url = "https://music.163.com/weapi/artist/albums/\(id)"
        let data = [
            "limit": limit,
            "offset": offset * limit,
            "total": true
        ] as [String : Any]
        cancelDict["\(#function)"] = httpRequest(method: .POST, url: url, data: encrypt(text: data.json), complete: complete)
    }
    // 歌手MV
    func artistMV(id: Int, limit: Int = 30, offset: Int = 0, complete: @escaping CompletionBlock) {
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
    func artistSub(id: Int, sub: Bool, complete: @escaping CompletionBlock) {
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
    func artists(id: Int, complete: @escaping CompletionBlock) {
        let url = "https://music.163.com/weapi/artist/\(id)"
        let data = ResponseData()
        cancelDict["\(#function)"] = httpRequest(method: .POST, url: url, data: encrypt(text: data.json), complete: complete)
    }
    //歌手介绍
    func artistIntroduction(id: Int, complete: @escaping CompletionBlock) {
        let url = "https://music.163.com/weapi/artist/introduction"
        let data = ["id": id]
        cancelDict["\(#function)"] = httpRequest(method: .POST, url: url, data: encrypt(text: data.json), complete: complete)
    }
    // 发送与删除评论
    func comment(id: Int, cid: Int, content: String = "", type: CommentType, action: CommentAction, complete: @escaping CompletionBlock) {
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
    func commentLike(id: Int, cid: Int, like: Bool, type: CommentType, complete: @escaping CompletionBlock) {
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
    func commentMusic(id: Int, limit: Int = 20, offset: Int = 0, beforeTime: Int = 0, complete: @escaping CompletionBlock) {
        let url = "https://music.163.com/weapi/v1/resource/comments/R_SO_4_\(id)"
        let data = ["rid": id,
                    "limit": limit,
                    "offset": offset * limit,
                    "beforeTime": beforeTime
        ]
        cancelDict["\(#function)"] = httpRequest(method: .POST, url: url, data: encrypt(text: data.json), complete: complete)
    }
    //喜欢或取消喜欢歌曲
    func like(id: Int, like: Bool, complete: @escaping CompletionBlock) {
        let url = "https://music.163.com/weapi/radio/like?alg=itembased&trackId=\(id)&time=25"
        
        let data = ["trackId": id,
                    "like": like] as [String : Any]
        cancelDict["\(#function)"] = httpRequest(method: .POST, url: url, data: encrypt(text: data.json), complete: complete)
    }
    //喜欢音乐列表
    func likeList(uid: Int, complete: @escaping CompletionBlock) {
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
    func logout(_ complete: @escaping CompletionBlock) {
        let url = "https://music.163.com/weapi/logout"
        
        let data = ResponseData()
        cancelDict["\(#function)"] = httpRequest(method: .POST, url: url, data: encrypt(text: data.json), complete: complete)
        
        if let cookies = HTTPCookieStorage.shared.cookies {
            for cookie in cookies {
                HTTPCookieStorage.shared.deleteCookie(cookie)
            }
        }
        DataManager.shared.userLogout()
    }
    func lyric(id: Int ,complete: @escaping CompletionBlock) {
        let url = "https://music.163.com/weapi/song/lyric"
        
        let data = ["id": id,
                    "lv": -1,
                    "kv": -1,
                    "tv": -1,
        ]
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
    func playlistDelete(pid: Int, complete: @escaping CompletionBlock) {
        let url = "https://music.163.com/weapi/playlist/delete"
        let data = [
            "pid": pid,
            ] as [String : Any]
        cancelDict["\(#function)"] = httpRequest(method: .POST, url: url, data: encrypt(text: data.json), complete: complete)
    }
    //歌单详情
    func playlistDetail(_ id: Int, complete: @escaping CompletionBlock) {
        let url = "https://music.163.com/weapi/v3/playlist/detail"
        let data = [
            "id": id,
            "n": 100000,
            "s": 8
        ]
        cancelDict["\(#function)"] = httpRequest(method: .POST, url: url, data: encrypt(text: data.json), complete: complete)
    }
    //歌单顺序
    func playlistOrderUpdate(ids: [Int], complete: @escaping CompletionBlock) {
        let url = "https://music.163.com/weapi/playlist/order/update"
        let data = [
            "ids": ids
        ]
        cancelDict["\(#function)"] = httpRequest(method: .POST, url: url, data: encrypt(text: data.json), complete: complete)
    }
    //歌单收藏
    func playlistSubscribe(id: Int, subscribe: Bool, complete: @escaping CompletionBlock) {
        let t = subscribe ? "subscribe" : "unsubscribe"
        let url = "https://music.163.com/weapi/playlist/\(t)"
        let data = [
            "id": id
        ]
        cancelDict["\(#function)"] = httpRequest(method: .POST, url: url, data: encrypt(text: data.json), complete: complete)
    }
    //对歌单添加或删除歌曲
    func playlistTracks(pid: Int, op: Bool, ids: [Int], complete: @escaping CompletionBlock) {
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
    func songsOrderUpdate(pid: Int, ids: [Int], complete: @escaping CompletionBlock) {
        let url = "http://interface.music.163.com/weapi/playlist/manipulate/tracks"
        let data = [
            "pid": pid,
            "trackIds": ids,
            "op": "update"
            ] as [String : Any]
        cancelDict["\(#function)"] = httpRequest(method: .POST, url: url, data: encrypt(text: data.json), complete: complete)
    }
    //歌曲链接
    func songsURL(_ ids: [Int], complete: @escaping CompletionBlock) {
        let url = "https://music.163.com/weapi/song/enhance/player/url"
        let data = [
            "ids": "[" + ids.map(String.init).joined(separator: ",") + "]",
            "br": 999000
            ] as [String : Any]
        cancelDict["\(#function)"] = httpRequest(method: .POST, url: url, data: encrypt(text: data.json), complete: complete)
    }
    //歌曲详情
    func songsDetail(_ ids: [Int], complete: @escaping CompletionBlock) {
        let url = "https://music.163.com/weapi/v3/song/detail"
        let c = ids.map{"{" + "id:" + String($0) + "}"}.joined(separator: ",")
        let data = [
            "c": "[" + c + "]",
            "ids": "[" + ids.map(String.init).joined(separator: ",") + "]"
        ]
        cancelDict["\(#function)"] = httpRequest(method: .POST, url: url, data: encrypt(text: data.json), complete: complete)
    }
    //用户歌单
    func userPlayList(_ uid: Int, complete: @escaping CompletionBlock) {
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
    func httpRequest(method: HttpMethod, url: String, data: String, complete: @escaping CompletionBlock) -> AnyCancellable {
        
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
        request.httpBody = data.plusSymbolToPercent().data(using: .utf8)
        
        let cancel = URLSession.shared
            .dataTaskPublisher(for: request)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { finished in
                if case .failure(let error) = finished {
                    print(error)
                    complete(nil, .httpRequestError(error: error))
                }
            }) { (data, response) in
                let cookies = HTTPCookieStorage.shared.cookies
                for cookie in cookies! {
                    print("name: \(cookie.name) value: \(cookie.value)")
                }
                if let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) {
                    let jsonDict = json as! ResponseData
                    complete(jsonDict, nil)
                }
        }
        return cancel
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
    //        func test() {
    //            album(id: 36693523) { (data, error) in
    //                print(data)
    //                if let albumDict = data?["album"] as? ResponseData{
    //                    let album = albumDict.toData?.toModel(Album.self)
    //                    print(album)
    //                }
    //            }
    //        }
    //    func test() {
    ////        12787752
    //        artist(id: 6452) { (data, error) in
    //            print(data)
    //            if let artistDict = data?["artist"] as? ResponseData{
    //                let artist = artistDict.toData?.toModel(Artist.self)
    //                print(artist)
    //            }
    ////            print(data!["artist"])
    //        }
    //    }
    //        func test() {
    ////            3191634
    //            let uid = DataManager.shared.getUser()?.uid
    //            getUserPlayList(uid!) { (data, error) in
    //                var playLists = [Playlist]()
    //                if let lists = data?["playlist"] as? [NeteaseCloudMusicApi.ResponseData] {
    //                    for list in lists {
    //    //                    print(list)
    //                        playLists.append((list.toData?.toModel(Playlist.self))!)
    //                    }
    //                }
    //                print(playLists)
    //            }
    //        }
    //    func test() {
    //        getPlaylistDetail(2722750905){jsonDict, error in
    //            print(jsonDict)
    //            print("###")
    //            if let playlistDict = jsonDict?["playlist"] as? ResponseData {
    //                let playlist = playlistDict.toData?.toModel(Playlist.self)
    //                print(playlist)
    //            }
    //        }
    //    }
    //        func test() {
    //            getSongsDetail([1351615757]){jsonDict, error in
    //               print(jsonDict)
    //                if let songs = jsonDict?["songs"] as? [ResponseData] {
    //                    if songs.count > 0 {
    //                        let song = songs[0].toData?.toModel(SongDetail.self)
    //                        print(song)
    //                    }
    //                }
    //            }
    //        }
    //        func test() {
    //            getSongsURL([1357425300,1352199795]){ jsonDict, error in
    //                if let songurls = jsonDict?["data"] as? [ResponseData] {
    //                    if songurls.count > 0 {
    //                        let songurl = songurls[0].toData?.toModel(SongURL.self)
    //                    }
    //                }
    //            }
    //        }
    func test() {
        //        commentMusic(id: 1464156421) { (data, error) in
        //            print(data as? ResponseData)
        //        }
        //        PlaylistSubscribe(id: 2216284341, subscribe: true) { (data, error) in
        //            for i in HTTPCookieStorage.shared.cookies! {
        //                print(i.name, i.value)
        //            }
        //                    print(data)
        //                }
        //        recommendResource() { (data, error) in
        //            print(data)
        //        }
        //        like(id: 1407551413, like: true) { (data, error) in
        //                                print(data)
        //        }
    }
    //        func test() {
    //            login(email: "linshaolong5240@163.com", password: "LOST74123") { (data, error) in
    //                guard error == nil else {
    ////                    store.dispatch(.loginDone(result: .failure(error!)))
    //                    return
    //                }
    //                print(data)
    //                if data!["code"] as! Int == 200 {
    //                    print("###1")
    //                    var user = User()
    //                    if let accountDict = data!["account"] as? NeteaseCloudMusicApi.ResponseData {
    //                        user.account = accountDict.toData!.toModel(Account.self)!
    //                    }
    //                    user.csrf = NeteaseCloudMusicApi.shared.getCSRFToken()
    //                    user.loginType = data!["loginType"] as! Int
    //                    if let profile = data!["profile"] as? NeteaseCloudMusicApi.ResponseData {
    //                        user.profile = profile.toData!.toModel(Profile.self)!
    //                    }
    //                    DataManager.shared.userLogin(user)
    ////                    store.dispatch(.loginDone(result: .success(user)))
    //                }else {
    //                    print("###2")
    ////                    store.dispatch(.loginDone(result: .failure(.loginError(code: data!["code"] as! Int, message: data!["message"] as! String))))
    //                }
    //
    //            }
    //        }
    //    func test() {
    //        let user = DataManager.shared.getUser()
    //        print(user)
    //    }
    //    func test() {
    //        logout { (data, error) in
    //            print(data)
    //        }
    //        print(getCSRFToken())
    //    }
    //    func test() -> Void {
    //        if let cookies = HTTPCookieStorage.shared.cookies{
    //            for cookie in cookies {
    //                print(cookie.name,cookie.value)
    //            }
    //        }
    //    }
}
