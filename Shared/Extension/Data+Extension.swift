//
//  Data+Extension.swift
//  Qin
//
//  Created by 林少龙 on 2020/6/17.
//  Copyright © 2020 teenloong. All rights reserved.
//

import Foundation

extension Data {
    func toModel<T: Decodable>(_ type: T.Type) -> T? {
        do {
            return try JSONDecoder().decode(type, from: self)
        }catch let error{
            print("data decode \(error)")
        }
        return nil
    }
}
