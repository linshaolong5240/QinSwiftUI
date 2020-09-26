//
//  LyricViewModel.swift
//  Qin
//
//  Created by 林少龙 on 2020/9/24.
//

import SwiftUI
import Combine

class LyricViewModel: ObservableObject {
    let lyricParser: LyricParser
    private var cancell: Cancellable = AnyCancellable({})

    @Published var index: Int = 0
    @Published var lyric: String = ""
    
    init(lyric: String) {
        self.lyricParser = LyricParser(lyric)
    }
    
    func setTimer(every: Double, offset: Double = 0.0) {
        if lyricParser.lyrics.count > 1 {
            cancell = Timer.publish(every: every, on: .main, in: .default)
                .autoconnect()
                .sink(receiveValue: { (value) in
                    let result =  self.lyricParser.lyricByTime(Player.shared.currentTime().seconds, offset: offset)
                    self.lyric = result.0
                    self.index = result.1
    //                print(result.0)
                })
        }
    }
    
    func stopTimer() {
        cancell.cancel()
    }
}
