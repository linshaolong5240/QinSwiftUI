//
//  Dictionary+Extension.swift
//  Qin
//
//  Created by 林少龙 on 2020/6/15.
//  Copyright © 2020 teenloong. All rights reserved.
//

import Foundation

extension Dictionary {
    var json: String {
        let invalidJson = "Not a valid JSON"
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            let json = String(data: jsonData, encoding: .utf8) ?? invalidJson
            print("json:\(json)")
            return json
        } catch {
            return "Not a valid JSON"
        }
    }
    var toData: Data? {
        do {
            let data = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return data
        }
        catch let error{
            print("dict encode \(error)")
            return nil
        }
    }
}
