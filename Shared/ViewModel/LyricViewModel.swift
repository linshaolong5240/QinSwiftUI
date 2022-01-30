//
//  LyricViewModel.swift
//  Qin
//
//  Created by 林少龙 on 2020/9/24.
//

import SwiftUI
import Combine

class LyricViewModel: ObservableObject {
    private var timerCancell = AnyCancellable({ })
    private var cancells = Set<AnyCancellable>()
    @Published var isRequesting: Bool = false

    private(set) var lyricParser: LyricParser
    @Published var index: Int = 0
    
    init(lyric: String) {
        self.lyricParser = LyricParser(lyric: lyric)
    }
    
    func setTimer(every interval: TimeInterval, offset: Double = 0.0) {
        timerCancell = Timer.publish(every: interval, on: .main, in: .default)
            .autoconnect()
            .sink(receiveValue: { [weak self] (value) in
                guard let weakSelf = self else {
                    return
                }
                
                let result =  weakSelf.lyricParser.lyricByTime(Player.shared.currentTime().seconds, offset: offset)
//                if weakSelf.lyric != result.0 {
//                    weakSelf.lyric = result.0
//                }
                if weakSelf.index != result.1 {
                    weakSelf.index = result.1
                }
            })
    }
    
    func stopTimer() {
        timerCancell.cancel()
    }
}
