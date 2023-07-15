//
//  MusicPlayer.swift
//  MediaPlayerX
//
//  Created by Lzzzt on 2023/7/15.
//

import AVFoundation
import SwiftUI

class MusicPlayer: ObservableObject {
    var player: AVAudioPlayer?

    @Published var timer: Timer? = nil

    func play(url: URL) {
        setupPlayer(url: url)
        player?.play()
    }

    func pause() {
        if let player = player {
            player.pause()
            timer?.invalidate()
            timer = nil
        }
    }

    private func setupPlayer(url: URL) {
        do {
            try player = AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
        } catch let err {
            print("[ERROR]: \(err)")
        }
    }
}
