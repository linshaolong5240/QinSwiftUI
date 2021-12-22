//
//  Player.swift
//  Qin
//
//  Created by 林少龙 on 2020/7/2.
//  Copyright © 2020 teenloong. All rights reserved.
//

import Foundation
import AVFoundation
import Combine
import Kingfisher

class Player: AVPlayer, ObservableObject {
    let audioSession = AVAudioSession.sharedInstance()
    static let shared = Player()
    private var timeObserverToken: Any?
    private var cancellAble = AnyCancellable({})
    private var notificatioCancellAble = AnyCancellable({})
    
    //playingStatus
    @Published var isPlaying: Bool = false
    @Published var loadTime: Double = 0.0
    @Published var totalTime: Double = 0.0
    @Published var loadPercent: Double = 0.0

    override init() {
        super.init()
        self.addObserver(self, forKeyPath: #keyPath(AVPlayer.rate), options: [.old, .new], context: nil)
    }
    
    deinit {
        self.removeObserver(self, forKeyPath: #keyPath(AVPlayer.rate))
    }
    
    override func pause() {
        AudioSessionManager.shared.deactive()
        super.pause()
        self.removePeriodicTimeObserver()
    }
    
    override func play() {
        AudioSessionManager.shared.active()
        super.play()
        self.addPeriodicTimeObserver()
        Store.shared.dispatch(.updateMPNowPlayingInfo)
    }
    func playWithURL(url: URL) {
        self.removePeriodicTimeObserver()
        prepareToPlay(url: url)
    }
    func prepareToPlay(url: URL) {
        // Create asset to be played
        let asset = AVAsset(url: url)
        
        let assetKeys = [
            "playable",
            "hasProtectedContent"
        ]
        // Create a new AVPlayerItem with the asset and an
        // array of asset keys to be automatically loaded
        let playerItem = AVPlayerItem(asset: asset,
                                  automaticallyLoadedAssetKeys: assetKeys)
        
        // Register as an observer of the player item's status property
//        playerItem.addObserver(self,
//                               forKeyPath: #keyPath(AVPlayerItem.status),
//                               options: [.old, .new],
//                               context: nil)
        // Associate the player item with the player
        self.replaceCurrentItem(with: playerItem)
        self.addObserver(self, forKeyPath: #keyPath(AVPlayer.currentItem.status), options: [.old, .new], context: nil)
    }
    
    func seek(seconds: Double) {
        let cmtime = CMTime(seconds: seconds, preferredTimescale: 600)
        super.seek(to: cmtime)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {//在global 会出错,在main中更新UI状态
            Store.shared.dispatch(.updateMPNowPlayingInfo)//seek 后 AVPlayer 的当前时间获取有延迟
        }
    }
    
    func addPeriodicTimeObserver() {
        //        // Invoke callback every half second
        //        let interval = CMTime(seconds: 1, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        //        // Add time observer. Invoke closure on the main queue.
        //        timeObserverToken = self.addPeriodicTimeObserver(forInterval: interval, queue: .main) {
        //                /*[weak self]*/ time in
        //                // update player transport UI
        //                block()
        //        }
        cancellAble = Timer
            .publish(every: 1, on: .main, in: .default)
            .autoconnect()
            .sink(receiveValue: { _ in
                let store = Store.shared
                let player = Player.shared
                if !store.appState.playing.isSeeking {
                    let loadTime = player.currentTime().seconds
                    player.loadTime = loadTime.isNaN || loadTime.isInfinite ? 0 : loadTime
                    if let totalTime = player.currentItem?.duration.seconds {
                        player.totalTime = totalTime
                        player.loadPercent = player.loadTime / player.totalTime
                    }
                }
            })
    }
    
    func removePeriodicTimeObserver() {
//        if timeObserverToken != nil {
//            self.removeTimeObserver(timeObserverToken!)
//        }
        cancellAble.cancel()
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(AVPlayer.currentItem.status) {
            switch self.status {
            case .unknown:
                break
            case .readyToPlay:
                self.play()
                self.removeObserver(self, forKeyPath: #keyPath(AVPlayer.currentItem.status))
                #if DEBUG
                print("player readyToPlay")
                #endif
                break
            case .failed:
                break
            default:
                break
            }
        }
        if keyPath == #keyPath(AVPlayer.rate) {
            if rate == 0 {
                isPlaying = false
            }else {
                isPlaying = true
            }
        }
    }

}
