//
//  JSONHelp.swift
//  Qin
//
//  Created by 林少龙 on 2021/4/19.
//

import Foundation

extension Data {
    func toString(encoding: String.Encoding = .utf8) -> String? { String(data: self, encoding: encoding) }
    func toModel<T: Decodable>(_ type: T.Type) -> T? { try? JSONDecoder().decode(type, from: self) }
}

extension Dictionary {
    var toJSONString: String {
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: [.prettyPrinted, .sortedKeys]) else {
            return ""
        }
        return String(data: data, encoding: .utf8) ?? ""
    }
    var toData: Data? { try? JSONSerialization.data(withJSONObject: self, options: [.prettyPrinted, .sortedKeys]) }
}

extension Encodable {
    var toData: Data? {
        return try? JSONEncoder().encode(self)
    }
    var toJSONString: String? {
        guard let data = try? JSONEncoder().encode(self) else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }
    subscript(key: String) -> Any? {
        return dictionary[key]
    }
    var dictionary: [String: Any] {
        return (try? JSONSerialization.jsonObject(with: JSONEncoder().encode(self))) as? [String: Any] ?? [:]
    }
    var asDictionary : [String:Any] {
      let mirror = Mirror(reflecting: self)
      let dict = Dictionary(uniqueKeysWithValues: mirror.children.lazy.map({ (label:String?, value:Any) -> (String, Any)? in
        guard let label = label else { return nil }
        return (label, value)
      }).compactMap { $0 })
      return dict
    }
}

extension String {
    func jsonToModel<T: Decodable>(_ type: T.Type) -> T? {
        guard let data =  self.data(using: .utf8) else {
            return nil
        }
        return try? JSONDecoder().decode(type, from: data)
    }
    var jsonToDictionary: [String: Any]? {
        guard let data = self.data(using: .utf8) else {
            return nil
        }
        return  try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String : Any]
    }
}
