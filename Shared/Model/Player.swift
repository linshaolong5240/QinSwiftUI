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
import MediaPlayer

class Player: AVPlayer, ObservableObject {
    static let shared = Player()
    private var timeObserverToken: Any?
    private var cancellAble = AnyCancellable({})
    private var notificatioCancellAble = AnyCancellable({})

    @Published var isPlaying: Bool = false
    override init() {
        super.init()
        self.addObserver(self, forKeyPath: #keyPath(AVPlayer.rate), options: [.old, .new], context: nil)
        self.notificatioCancellAble = NotificationCenter.default.publisher(for: .AVPlayerItemDidPlayToEndTime).sink { (Notification) in
            print("end play")
            Store.shared.dispatch(.playToendAction)
        }
        #if !os(macOS)
        initAudioSession()
        #endif
        initMPRemoteCommand()
    }
    
    override func pause() {
        super.pause()
        self.removePeriodicTimeObserver()
        updateMPNowPlayingInfo()
    }
    
    override func play() {
        super.play()
        self.addPeriodicTimeObserver()
        updateMPNowPlayingInfo()
}
    func playWithURL(url: String) {
        self.removePeriodicTimeObserver()
        prepareToPlay(urlStr: url)
    }
    func prepareToPlay(urlStr: String) {
        let url = URL(string: urlStr)!
        
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
            Player.shared.updateMPNowPlayingInfo()//seek 后 AVPlayer 的当前时间获取有延迟
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
            .sink(receiveValue: {_ in
                            let store = Store.shared
                            if !store.appState.playing.isSeeking{
                                let loadTime = Player.shared.currentTime().seconds
                                let lyric = store.appState.lyric.lyricParser.lyricByTime(loadTime, offset: -0.3)
                                if let totalTime = Player.shared.currentItem?.duration.seconds {
                                    if totalTime > 0 {
                                        store.appState.playing.totalTime = totalTime
                                        store.appState.playing.totalTimeLabel = String(format: "%02d:%02d", Int(totalTime/60),Int(totalTime)%60)
                                        store.appState.playing.loadPercent = loadTime / totalTime
                                    }
                                }
                                store.appState.playing.loadTime = loadTime
                                store.appState.playing.loadTimelabel = String(format: "%02d:%02d", Int(loadTime/60),Int(loadTime)%60)
                                store.appState.playing.lyric = lyric
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
                print("player readyToPlay")
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

    func updateMPNowPlayingInfo() {
        #if os(iOS)
        var info = [String : Any]()
        info[MPNowPlayingInfoPropertyMediaType] = MPNowPlayingInfoMediaType.audio.rawValue
        info[MPMediaItemPropertyTitle] = Store.shared.appState.playing.songDetail.name//歌名
        info[MPMediaItemPropertyArtist] = Store.shared.appState.playing.songDetail.artists
        //         [info setObject:self.model.filename forKey:MPMediaItemPropertyAlbumTitle];//专辑名
        //         info[MPMediaItemPropertyAlbumArtist] = mainChannels.first?.value.soundMeta?.artist//专辑作者
        if let url = URL(string: Store.shared.appState.playing.songDetail.albumPicURL) {
            let _ = KingfisherManager.shared.retrieveImage(with: .network(url)) { (result) in
                switch result {
                case .success(let value):
                            info[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: value.image.size, requestHandler: { (size) -> UIImage in
                                    return value.image
                                })//显示的图片
                case .failure(_):
                    break
                }
            }
        }
        info[MPNowPlayingInfoPropertyElapsedPlaybackTime] =  Player.shared.currentItem?.currentTime().seconds
        info[MPMediaItemPropertyPlaybackDuration] = Player.shared.currentItem?.duration.seconds//总时长
//        info[MPNowPlayingInfoPropertyIsLiveStream] = 1.0
        info[MPNowPlayingInfoPropertyPlaybackRate] = Player.shared.rate//播放速率
        MPNowPlayingInfoCenter.default().nowPlayingInfo = info
        #endif
//        #if os(macOS)
//        MPNowPlayingInfoCenter.default().playbackState = Player.shared.isPlaying ? .playing : .paused
//        #endif
    }
    func initMPRemoteCommand() {
        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.playCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
            Store.shared.dispatch(.play)
            return .success
        }
        commandCenter.pauseCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
            Store.shared.dispatch(.pause)
            return .success
        }
        commandCenter.nextTrackCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
            Store.shared.dispatch(.playForward)
            return .success
        }
        commandCenter.previousTrackCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
            Store.shared.dispatch(.playBackward)
            return .success
        }
    }
    #if !os(macOS)
    func initAudioSession() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playback)
            try audioSession.setActive(true)
        } catch let error {
            debugPrint("AVAudioSession: \(error)")
        }
        UIApplication.shared.beginReceivingRemoteControlEvents()
    }
    #endif
    deinit {
        self.removeObserver(self, forKeyPath: #keyPath(AVPlayer.rate))
    }
}
