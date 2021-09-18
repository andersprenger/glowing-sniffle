//
//  MusicPlayer.swift
//  RunningX
//
//  Created by Anderson Renan Paniz Sprenger on 18/09/21.
//

import Foundation
import AVFoundation

class MediaPlayer {
    var audioPlayer: AVAudioPlayer! = nil
    var videoURL: URL! = nil
    var videoPlayer: AVPlayer! = nil
    
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
        
        audioPlayer.play()
    }
    
    func playVideo() {
        self.videoURL = Bundle.main.url(forResource: "sky_animation_2", withExtension: "mov")!
        self.videoPlayer = AVPlayer(url: videoURL)
        
        videoPlayer.play()
        
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.videoPlayer.currentItem, queue: .main) { [weak self] _ in
            self?.videoPlayer?.seek(to: CMTime.zero)
            self?.videoPlayer?.play()
        }
    }
}
