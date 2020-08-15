//
//  Lyric.swift
//  Qin
//
//  Created by 林少龙 on 2020/8/3.
//  Copyright © 2020 teenloong. All rights reserved.
//

import Foundation

class LyricParser {
    private var lyric: String = ""
    private var times = [Double]()
    private var lyrics = [String]()
    init() {
    }
    init(_ lyric: String) {
        self.lyric = lyric
        if lyric.count > 0 {
            parseLyric()
        }
    }
    
    private func parseLyric() {
        let data = lyric.split(separator: "\n")
            .filter({ (subStr) -> Bool in
                do {
                    let str = String(subStr)
                    let pattern = "\\[\\d+:\\d+.\\d+\\]"
                    let Regular = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
                    let result = Regular.matches(in: str, options: [], range: NSRange(location: 0, length: str.count))
//                    print("reslut: \(result)")
                    return result.count > 0 ? true : false
                }
                catch let error{
                    print(error)
                }
                return false
            })
            .map { (subStr) -> (Double, String) in
                let i = subStr.firstIndex(of: "[")
                let j = subStr.firstIndex(of: "]")
                let t1 = subStr.index(after: i!)
                let t2 = subStr.index(before: j!)
                let l = subStr.index(after: j!)
                let timeStr = String(subStr[t1...t2])
                let times = timeStr.split(separator: ":")
                return (Double(times[0])! * 60 + Double(times[1])!, String(subStr.suffix(from: l)))
            }
        times = data.map{$0.0}
        lyrics = data.map{$0.1}
        print(times)
        print(lyrics)
    }
    func lyricByTime(_ time: Double) -> String {
        guard time > 0 && times.count > 0 else {
            return ""
        }
        if  time > times.last! {
            return lyrics.last!
        }
        if time < times.first! {
            return ""
        }
        var index: Int = 0
        for t in times {
            if time >= t {
                index += 1
            }else {
                return lyrics[index - 1]
            }
        }
        return ""
    }
}
