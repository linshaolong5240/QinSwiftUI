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
    
    //playingStatus
    @Published var isPlaying: Bool = false
    @Published var loadTime: Double = 0.0
    @Published var totalTime: Double = 0.0
    @Published var loadPercent: Double = 0.0

    override init() {
        super.init()
        self.addObserver(self, forKeyPath: #keyPath(AVPlayer.rate), options: [.old, .new], context: nil)
        self.notificatioCancellAble = NotificationCenter.default.publisher(for: .AVPlayerItemDidPlayToEndTime).sink { (Notification) in
            print("end play")
            Store.shared.dispatch(.PlayerPlayToendAction)
        }
        #if !os(macOS)
        initAudioSession()
        #endif
        initMPRemoteCommand()
    }
    
    override func pause() {
        super.pause()
        self.removePeriodicTimeObserver()
        self.updateMPNowPlayingInfo()
    }
    
    override func play() {
        super.play()
        self.addPeriodicTimeObserver()
        self.updateMPNowPlayingInfo()
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
        if let title = Store.shared.appState.playing.song?.name {
            info[MPMediaItemPropertyTitle] = title//歌名
        }
        if let album = Store.shared.appState.playing.song?.album {
            info[MPMediaItemPropertyAlbumTitle] = album.name//专辑名
//                     info[MPMediaItemPropertyAlbumArtist] = mainChannels.first?.value.soundMeta?.artist//专辑作者
        }

        if let artists = Store.shared.appState.playing.song?.artists as? Set<Artist> {
            info[MPMediaItemPropertyArtist] = artists.map{($0.name ?? "")}.joined(separator: " ")
        }
        info[MPNowPlayingInfoPropertyElapsedPlaybackTime] =  Player.shared.currentItem?.currentTime().seconds
        info[MPMediaItemPropertyPlaybackDuration] = Player.shared.currentItem?.duration.seconds//总时长
//        info[MPNowPlayingInfoPropertyIsLiveStream] = 1.0
        info[MPNowPlayingInfoPropertyPlaybackRate] = Player.shared.rate//播放速率
        MPNowPlayingInfoCenter.default().nowPlayingInfo = info
        if let url = URL(string: Store.shared.appState.playing.song?.album?.picUrl ?? "") {
            let _ = KingfisherManager.shared.retrieveImage(with: .network(url), options: [.processor(DownsamplingImageProcessor(size: CGSize(width: 130, height: 130)))]) { (result) in
                switch result {
                case .success(let value):
                            info[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: value.image.size, requestHandler: { (size) -> UIImage in
                                    return value.image
                                })//显示的图片
                    MPNowPlayingInfoCenter.default().nowPlayingInfo = info
                case .failure(_):
                    break
                }
            }
        }
        MPNowPlayingInfoCenter.default().nowPlayingInfo = info
        #endif
//        #if os(macOS)
//        MPNowPlayingInfoCenter.default().playbackState = Player.shared.isPlaying ? .playing : .paused
//        #endif
    }
    func initMPRemoteCommand() {
        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.playCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
            Store.shared.dispatch(.PlayerPlay)
            return .success
        }
        commandCenter.pauseCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
            Store.shared.dispatch(.PlayerPause)
            return .success
        }
        commandCenter.nextTrackCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
            Store.shared.dispatch(.PlayerPlayForward)
            return .success
        }
        commandCenter.previousTrackCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
            Store.shared.dispatch(.PlayerPlayBackward)
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
