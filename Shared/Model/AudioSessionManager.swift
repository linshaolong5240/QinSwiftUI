//
//  AudioSessionManager.swift
//  Qin (iOS)
//
//  Created by teenloong on 2021/12/18.
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
        } catch let error {
#if DEBUG
            print("AVAudioSession: \(error)")
#endif
        }
        NotificationCenter.default.addObserver(self, selector: #selector(handleInterruption), name: AVAudioSession.interruptionNotification, object: AVAudioSession.sharedInstance())
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
            try audioSession.setActive(false, options: .notifyOthersOnDeactivation)
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
            break
        case .ended:
            // An interruption ended. Resume playback, if appropriate.
            
            guard let optionsValue = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt else { return }
            let options = AVAudioSession.InterruptionOptions(rawValue: optionsValue)
            if options.contains(.shouldResume) {
                // An interruption ended. Resume playback.
                Player.shared.play()
            } else {
                // An interruption ended. Don't resume playback.
            }
            
        default: ()
        }
    }
}
