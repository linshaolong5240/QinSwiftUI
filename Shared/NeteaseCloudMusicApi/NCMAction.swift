//
//  NCMAction.swift
//  Qin
//
//  Created by teenloong on 2022/1/31.
//  Copyright © 2022 com.teenloong. All rights reserved.
//

import Foundation

public struct NCMEmptyParameters: Encodable {

}

public protocol NCMAction {
    associatedtype Parameters: Encodable
    associatedtype Response: Decodable
    var method: NCMHttpMethod { get }
    var host: String { get }
    var uri: String { get }
    var headers: [String: String]? { get }
    var timeoutInterval: TimeInterval { get }
    var parameters: Parameters? { get }
    var responseType: Response.Type { get }
}

extension NCMAction {
    public var method: NCMHttpMethod { .post }
    public var headers: [String: String]? { nil }
    public var timeoutInterval: TimeInterval { 20 }
    public var parameters: NCMEmptyParameters? { nil }
}

extension NCMAction {
    public var host: String { Self.defaultHost }
    public static var defaultHost: String { "https://music.163.com" }
    public var cloudHost: String { "https://interface.music.163.com" }
    public var cloudUploadHost: String { "http://45.127.129.8" }
}
