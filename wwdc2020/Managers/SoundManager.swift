//
//  SoundManager.swift
//  wwdc2020
//
//  Created by Luis Gustavo Avelino de Lima Jacinto on 11/05/20.
//  Copyright © 2020 Luis Gustavo Avelino de Lima Jacinto. All rights reserved.
//

import AVFoundation

class SoundManager {

    static let shared = SoundManager()

    func start() {
        let delay: TimeInterval = 10.0
        let time = players.first!.deviceCurrentTime + delay
        players.forEach({ player in
            player.play(atTime: time)
        })
    }

    private var players = [AVAudioPlayer]()

    private init() {
        players.append(try! AVAudioPlayer(contentsOf: Bundle.main.url(forResource: "HeavySynthBass", withExtension: "mp3")!))
        players.append(try! AVAudioPlayer(contentsOf: Bundle.main.url(forResource: "HeavySynthBass2", withExtension: "mp3")!))
        players.append(try! AVAudioPlayer(contentsOf: Bundle.main.url(forResource: "ClassicElectricPiano", withExtension: "mp3")!))
        players.append(try! AVAudioPlayer(contentsOf: Bundle.main.url(forResource: "BigSawBass", withExtension: "mp3")!))
        players.append(try! AVAudioPlayer(contentsOf: Bundle.main.url(forResource: "JumpUpBass", withExtension: "mp3")!))
        players.append(try! AVAudioPlayer(contentsOf: Bundle.main.url(forResource: "TauregMoonBass", withExtension: "mp3")!))
    }
}
