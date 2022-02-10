//
//  Published+Extension.swift
//  Qin
//
//  Created by teenloong on 2020/10/19.
//

import Foundation

//https://stackoverflow.com/questions/57444059/how-to-conform-an-observableobject-to-the-codable-protocols
extension Published: Encodable where Value: Encodable {
    public func encode(to encoder: Encoder) throws {
        guard
            let storageValue =
                Mirror(reflecting: self).descendant("storage")
                .map(Mirror.init)?.children.first?.value,
            let value =
                storageValue as? Value
                ??
                (storageValue as? Publisher).map(Mirror.init)?
                .descendant("subject", "currentValue")
                as? Value
        else { throw EncodingError.invalidValue(self, codingPath: encoder.codingPath) }
        
        try value.encode(to: encoder)
    }
}

extension Published: Decodable where Value: Decodable {
    public init(from decoder: Decoder) throws {
        self = Published(initialValue:try Value(from:decoder))
    }
}

extension EncodingError {
  /// `invalidValue` without having to pass a `Context` as an argument.
  static func invalidValue(
    _ value: Any,
    codingPath: [CodingKey],
    debugDescription: String = .init()
  ) -> Self {
    .invalidValue(
      value,
      .init(
        codingPath: codingPath,
        debugDescription: debugDescription
      )
    )
  }
}
