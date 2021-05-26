//
//  String+Extension.swift
//  Qin
//
//  Created by qfdev on 2021/5/26.
//

import Foundation

extension String {
    /**
        Returns a percent-escaped string following RFC 3986 for a query string key or value.

        RFC 3986 states that the following characters are "reserved" characters.

        - General Delimiters: ":", "#", "[", "]", "@", "?", "/"
        - Sub-Delimiters: "!", "$", "&", "'", "(", ")", "*", "+", ",", ";", "="

        In RFC 3986 - Section 3.4, it states that the "?" and "/" characters should not be escaped to allow
        query strings to include a URL. Therefore, all "reserved" characters with the exception of "?" and "/"
        should be percent-escaped in the query string.

        - parameter string: The string to be percent-escaped.

        - returns: The percent-escaped string.
    */
    func escape() -> String {//网址特殊符号处理
        var result = ""
        let kCharactersGeneralDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let kCharactersSubDelimitersToEncode = "!$&'()*+,;="
        
        var allowedCharacterSet = CharacterSet.urlQueryAllowed
        
        allowedCharacterSet.remove(charactersIn: kCharactersGeneralDelimitersToEncode + kCharactersSubDelimitersToEncode)
        result = self.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? ""
        return result
    }
}
