//
//  SoundManager.swift
//  Match_Game
//
//  Created by Thien Tung on 7/9/20.
//  Copyright © 2020 Thien Tung. All rights reserved.
//

import Foundation
import AVFoundation

class SoundManager {
    
    static var audioPlayer: AVAudioPlayer?
    
    enum SoundEffect {
        
        case flip
        case shuffle
        case match
        case nomatch
    }
    
    static func playSound(effect: SoundEffect) {
        
        var soundFilename = ""
        
        switch effect {
        case .flip:
            soundFilename = "cardflip"
            
        case .shuffle:
            soundFilename = "shuffle"
            
        case .match:
            soundFilename = "dingcorrect"
            
        case .nomatch:
            soundFilename = "dingwrong"
        }
        
        // Lay duong dan den file am thanh trong Bundle
        let bundlePath = Bundle.main.path(forResource: soundFilename, ofType: "wav")
        
        guard bundlePath != nil else {
            print("Couldn't file sound file: \(soundFilename) in the bundle")
            return
        }
        
        // Tao mot url tu bundlePath
        let soundURL = URL(fileURLWithPath: bundlePath!)
        
        do {
            // Tao player
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            
            // Play the sound
            audioPlayer?.play()
            
        } catch {
            // Couldn't create audio object
            print("Couldn't create audio object for sound file: \(soundFilename)")
        }
    }
}

