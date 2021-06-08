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

public protocol NeteaseCloudMusicAction {
    associatedtype Parameters: Encodable
    associatedtype ResponseType: Decodable
    
    var uri: String { get }
    var parameters: Parameters { get }
    var responseType: ResponseType.Type { get }
}

class NeteaseCloudMusicApi {
    
    enum HttpMethod: String {
        case GET = "GET"
        case POST = "POST"
    }
    
    public static let shared = NeteaseCloudMusicApi()
    public var cancellableSet = Set<AnyCancellable>()
    
    private let host: String = "https://music.163.com"
    
    init() {
        let cookie = HTTPCookie(properties: [.name : "os",
                                             .value: "pc",
                                             .domain: ".music.163.com",
                                             .path: "/"])
        let cookie2 = HTTPCookie(properties: [.name : "appver",
                                             .value: "2.7.1.198277",
                                             .domain: ".music.163.com",
                                             .path: "/"])
        HTTPCookieStorage.shared.setCookie(cookie!)
        HTTPCookieStorage.shared.setCookie(cookie2!)
    }
    
    public func requestPublisher<Action: NeteaseCloudMusicAction>(method: HttpMethod = .POST, action: Action) -> AnyPublisher<Action.ResponseType, Error> {
        let url: String =  host + action.uri

        let httpHeader = [ //"Accept": "*/*",
            //"Accept-Encoding": "gzip,deflate,sdch",
            //"Connection": "keep-alive",
            "Content-Type": "application/x-www-form-urlencoded",
            "Host": "music.163.com",
            "Referer": "https://music.163.com",
            "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_6) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.1.2 Safari/605.1.15",
        ]
//        let cookies = HTTPCookieStorage.shared.cookies
//        let cookiesString = cookies!.map({ cookie in
//            cookie.name + "=" + cookie.value
//        }).joined(separator: "; ")
//        httpHeader["Cookie"] = cookiesString
//        print(httpHeader)
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = httpHeader
        request.timeoutInterval = 10
        if method == .POST {
            if let data = try? JSONEncoder().encode(action.parameters) {
                if let str = String(data: data, encoding: .utf8) {
                    request.httpBody = encrypto(text: str).data(using: .utf8)
                }
            }
        }
        #if false//DEBUG
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .map {
                print(String(data: $0.data, encoding: .utf8))
                return $0.data
            }
            .decode(type: action.responseType, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
        #else
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: action.responseType, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
        #endif
    }
    
    private func encrypto(text: String) -> String {
        func generateSecretKey(size: Int) -> String {
            let base62 = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
            
            var key = ""
            for _ in 1...size {
                key.append(base62.randomElement()!)
            }
            return key
        }
        func aesEncrypt(text: String, key: String, iv: String) -> String? {
            do {
                let aes = try AES(key: Array<UInt8>(key.utf8), blockMode: CBC(iv: Array<UInt8>(iv.utf8)))
                let bytes = try aes.encrypt(Array(text.utf8))
                let data = Data(bytes: bytes, count: bytes.count)
                return data.base64EncodedString()
            }catch {
                return nil
            }
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
            let data = encryptData! as Data
            #if DEBUG
            print(error ?? "")
            #endif
            return data.toHexString()
        }
        //crypto
        let pubKey = "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDgtQn2JZ34ZC28NWYpAUd98iZ37BUrX/aKzmFbt7clFSs6sXqHauqKWqdtLkF2KexO40H1YTX8z2lSgBBOAxLsvaklV8k4cBFK9snQXE9/DDaFt6Rr7iVZMldczhC0JNgTz+SHXT6CBHuX3e9SdB1Ua44oncaTWz7OBGLbCiK45wIDAQAB"

        let nonce = "0CoJUm6Qyw8W8jud"
        let iv = "0102030405060708"

        let secKey = generateSecretKey(size: 16)
        let encText = aesEncrypt(text: aesEncrypt(text: text, key: nonce, iv: iv)!, key: secKey, iv: iv)
        let encSecKey = rsaEncrypt(text: String(secKey.reversed()), pubKey: pubKey)
        return "params=\(encText!)&encSecKey=\(encSecKey)".plusSymbolToPercent()
    }
}

extension String {
    func plusSymbolToPercent() -> String {
        return self.replacingOccurrences(of: "+", with: "%2B")
    }
}


extension NeteaseCloudMusicApi {
    // 1: 单曲, 10: 专辑, 100: 歌手, 1000: 歌单, 1002: 用户, 1004: MV, 1006: 歌词, 1009: 电台, 1014: 视频

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
        httpRequest(method: .POST, url: url, data: encrypto(text: data.toJSONString), complete: complete)
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
        httpRequest(method: .POST, url: url, data: encrypto(text: data.toJSONString), complete: complete)
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
        httpRequest(method: .POST, url: url, data: encrypto(text: data.toJSONString), complete: complete)
    }
    //歌曲链接
    func search(keyword: String, type: SearchType = .song, limit: Int = 30, offset: Int = 0, complete: @escaping CompletionBlock) {
        let url = "https://music.163.com/weapi/search/get"
        let data = [
            "s": keyword,
            "type": type.rawValue,
            "limit": limit,
            "offset": offset
        ] as [String : Any]
        httpRequest(method: .POST, url: url, data: encrypto(text: data.toJSONString), complete: complete)
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

//httprequest
extension NeteaseCloudMusicApi {
    typealias ResponseData = Dictionary<String, Any>
    typealias CompletionBlock = (_ result: Result<ResponseData, AppError>) -> Void
    
    func httpRequest(method: HttpMethod, url: String, data: String?, complete: @escaping CompletionBlock) {
        
        var httpHeader = [ //"Accept": "*/*",
            //"Accept-Encoding": "gzip,deflate,sdch",
            //"Connection": "keep-alive",
            "Content-Type": "application/x-www-form-urlencoded",
//            "Host": "music.163.com",
            "Referer": "https://music.163.com",
            "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_6) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.1.2 Safari/605.1.15",
        ]
        let cookies = HTTPCookieStorage.shared.cookies
        let cookiesString = cookies!.map({ cookie in
            cookie.name + "=" + cookie.value
        }).joined(separator: "; ")
        httpHeader["Cookie"] = cookiesString
        print(httpHeader)
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = httpHeader
        request.timeoutInterval = 10
        if method == .POST {
            request.httpBody = data?.data(using: .utf8)
        }
        
        URLSession.shared
            .dataTaskPublisher(for: request)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { finished in
                if case .failure(let error) = finished {
                    complete(.failure(.httpRequestError(error: error)))
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
                        if let json = try? JSONSerialization.jsonObject(with: data) {
                            let jsonDict = json as! ResponseData
                            complete(.success(jsonDict))
                        }
                    }
                }
            }.store(in: &cancellableSet)
    }
}
