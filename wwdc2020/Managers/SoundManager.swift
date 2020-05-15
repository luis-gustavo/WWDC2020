//
//  SoundManager.swift
//  wwdc2020
//
//  Created by Luis Gustavo Avelino de Lima Jacinto on 11/05/20.
//  Copyright © 2020 Luis Gustavo Avelino de Lima Jacinto. All rights reserved.
//

import AVFoundation

enum Sound {
    case flash
    case explosion
    case blackHole
    case planet

    var resource: String {
        switch self {
        case .flash: return "flash"
        case .explosion: return "explosion2"
        case .blackHole: return "black-hole"
        case .planet: return "planet3"
        }
    }

    var resourceExtension: String {
        switch self {
        case .flash: return "mp3"
        case .explosion: return "wav"
        case .blackHole: return "wav"
        case .planet: return "wav"
        }
    }
}

class SoundManager {

    static let shared = SoundManager()

    func playSound(_ sound: Sound) {
        switch sound {
        case .flash, .explosion, .blackHole, .planet:
            sfxPlayer = try! AVAudioPlayer(contentsOf: Bundle.main.url(forResource: sound.resource, withExtension: sound.resourceExtension)!)
            sfxPlayer?.prepareToPlay()
            DispatchQueue.global().async {
                self.sfxPlayer?.play()
            }
        }
    }

    private var sfxPlayer: AVAudioPlayer?

    private init() {  }
}
