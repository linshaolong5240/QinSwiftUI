//
//  JSONHelp.swift
//  Qin
//
//  Created by 林少龙 on 2021/4/19.
//

import Foundation

extension Data {
    func toModel<T: Decodable>(_ type: T.Type) -> T? {
        do {
            return try JSONDecoder().decode(type, from: self)
        }catch let error {
            #if DEBUG
            fatalError("Data TO Model Error:\(error)")
            #else
            return nil
            #endif
        }
    }
}

extension Dictionary {
    var toJSONString: String {
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted) else {
            return ""
        }
        return String(data: data, encoding: .utf8) ?? ""
    }
    var toData: Data? {
        do {
            return try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
        }catch let error {
            #if DEBUG
            fatalError("Dictionary TO Data Error:\(error)")
            #else
            return nil
            #endif
        }
    }
}

extension Encodable {
    var toData: Data? {
        do {
            return try JSONEncoder().encode(self)
        }catch let error {
            #if DEBUG
            fatalError("Encodable TO Data Error:\(error)")
            #else
            return nil
            #endif
        }
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
    func toModel<T: Decodable>(_ type: T.Type) -> T? {
        guard let data =  self.data(using: .utf8) else {
            return nil
        }
        return try? JSONDecoder().decode(type, from: data)
    }
    var toDictionary: [String: Any]? {
        guard let data = self.data(using: .utf8) else {
            return nil
        }
        return  try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String : Any]
    }
}
