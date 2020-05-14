//
//  SoundManager.swift
//  wwdc2020
//
//  Created by Luis Gustavo Avelino de Lima Jacinto on 11/05/20.
//  Copyright © 2020 Luis Gustavo Avelino de Lima Jacinto. All rights reserved.
//

import AVFoundation

class SoundManager: NSObject {

    private lazy var player: AVAudioPlayer = {
        let player = try! AVAudioPlayer(contentsOf: Bundle.main.url(forResource: "WWDC-Song", withExtension: "mp3")!)
        player.volume = 1
        player.numberOfLoops = -1
        return player
    }()

    static let shared = SoundManager()

    func start(with delay: TimeInterval) {
        let time = player.deviceCurrentTime + delay
            player.currentTime = 0
            player.play(atTime: time)
    }

    func changeVolume(_ volume: Float) {
        player.volume = volume
    }

}
