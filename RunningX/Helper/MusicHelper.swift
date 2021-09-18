//
//  MusicHelper.swift
//  RunningX
//
//  Created by Anderson Renan Paniz Sprenger on 17/09/21.
//

import Foundation
import AVFoundation

class MusicHelper {
    var audioPlayer: AVAudioPlayer! = nil

    func playMusic() {
        if let url = Bundle.main.url(forResource: "music", withExtension: "mp3") {
            do {
                try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default, options: [.duckOthers])
                try AVAudioSession.sharedInstance().setActive(true)
                
                self.audioPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.wav.rawValue)
                
                guard let player = self.audioPlayer else { return }
                player.volume = 0.2
                player.numberOfLoops = -1
                player.prepareToPlay()
                player.play()
                
            } catch _ { return }
        }
    }
}

