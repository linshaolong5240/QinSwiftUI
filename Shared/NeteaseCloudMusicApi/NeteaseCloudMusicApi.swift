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

#if os(macOS)
import Alamofire
#endif

public protocol NeteaseCloudMusicAction {
    associatedtype Parameters: Encodable
    associatedtype Response: Decodable
    var headers: [String: String]? { get }
    var host: String { get }
    var uri: String { get }
    var parameters: Parameters { get }
    var responseType: Response.Type { get }
}

extension NeteaseCloudMusicAction {
    public var headers: [String: String]? { nil }
}

extension NeteaseCloudMusicAction {
    public var host: String { Self.defaultHost }
    public static var defaultHost: String { "https://music.163.com" }
    public var cloudHost: String { "https://interface.music.163.com" }
    public var cloudUploadHost: String { "http://45.127.129.8" }
}

public struct EmptyParameters: Encodable { }


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
    
    public func requestPublisher<Action: NeteaseCloudMusicAction>(method: HttpMethod = .POST, action: Action) -> AnyPublisher<Action.Response, Error> {
        let url: String =  action.host + action.uri

        let httpHeader = [ //"Accept": "*/*",
            //"Accept-Encoding": "gzip,deflate,sdch",
            //"Connection": "keep-alive",
            "Content-Type": "application/x-www-form-urlencoded",
            "Host": "music.163.com",
            "Referer": "https://music.163.com",
            "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_6) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.1.2 Safari/605.1.15"
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
        #if false
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .map {
                let str = String(data: $0.data, encoding: .utf8)?.jsonToDictionary?.toJSONString
                print(str)
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
    
    public func uploadPublisher(method: HttpMethod = .POST, action: CloudUploadAction) -> AnyPublisher<CloudUploadResponse, Error> {
        let url: String =  action.host + action.uri
        var request = URLRequest(url: URL(string: url)!, cachePolicy: .reloadIgnoringLocalCacheData)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = action.headers
        request.httpBody = action.data
        #if false
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .map {
                print(String(data: $0.data, encoding: .utf8)?.jsonToDictionary?.toJSONString)
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
