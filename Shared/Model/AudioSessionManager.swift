//
//  AudioSessionManager.swift
//  Qin (iOS)
//
//  Created by 林少龙 on 2021/12/18.
//

import Foundation
import AVFoundation
import UIKit

class AudioSessionManager {
    static let shared: AudioSessionManager = AudioSessionManager()

    var audioSession: AVAudioSession { AVAudioSession.sharedInstance()}
    
    func configuration() {
        do {
            try audioSession.setCategory(.playback)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch let error {
#if DEBUG
            print("AVAudioSession: \(error)")
#endif
        }
        NotificationCenter.default.addObserver(self, selector: #selector(handleInterruption), name: .AVCaptureSessionWasInterrupted, object: AVAudioSession.sharedInstance())
        UIApplication.shared.beginReceivingRemoteControlEvents()
    }
    
    func active() {
        do {
            try audioSession.setActive(true)
        }catch let error{
#if DEBUG
            print("AVAudioSession: \(error)")
#endif
        }
    }
    
    func deactive() {
        do {
            try audioSession.setActive(false)
        }catch let error{
#if DEBUG
            print("AVAudioSession: \(error)")
#endif
        }
    }
        
    @objc func handleInterruption(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
              let type = AVAudioSession.InterruptionType(rawValue: typeValue) else {
                  return
              }
        
        // Switch over the interruption type.
        switch type {
            
        case .began:
            // An interruption began. Update the UI as necessary.
            Player.shared.pause()
        case .ended:
            // An interruption ended. Resume playback, if appropriate.
            do {
                try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
            }catch let error {
#if DEBUG
                print(error)
#endif
            }
            Player.shared.play()
            guard let optionsValue = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt else { return }
            let options = AVAudioSession.InterruptionOptions(rawValue: optionsValue)
            if options.contains(.shouldResume) {
                // An interruption ended. Resume playback.
            } else {
                // An interruption ended. Don't resume playback.
            }
            
        default: ()
        }
    }
}
