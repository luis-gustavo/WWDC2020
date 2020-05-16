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
    case intro
    case gameplay

    var resource: String {
        switch self {
        case .flash: return "flash"
        case .explosion: return "explosion"
        case .blackHole: return "black-hole"
        case .planet: return "planet"
        case .intro: return "intro"
        case .gameplay: return "gameplay"
        }
    }

    var resourceExtension: String {
        switch self {
        case .flash: return "mp3"
        case .explosion: return "wav"
        case .blackHole: return "wav"
        case .planet: return "wav"
        case .intro: return "mp3"
        case .gameplay: return "mp3"
        }
    }
}

class SoundManager {

    private init() {
        // Intro
        self.introPlayer = try! AVAudioPlayer(contentsOf: Bundle.main.url(forResource: Sound.intro.resource, withExtension: Sound.intro.resourceExtension)!)
        self.introPlayer.numberOfLoops = -1
        self.introPlayer.prepareToPlay()

        // Gameplay
        self.gameplayPlayer = try! AVAudioPlayer(contentsOf: Bundle.main.url(forResource: Sound.gameplay.resource, withExtension: Sound.gameplay.resourceExtension)!)
        self.gameplayPlayer.numberOfLoops = -1
        self.gameplayPlayer.prepareToPlay()

        // Flash
        self.flashPlayer = try! AVAudioPlayer(contentsOf: Bundle.main.url(forResource: Sound.flash.resource, withExtension: Sound.flash.resourceExtension)!)
        self.flashPlayer.prepareToPlay()

        // Black hole
        self.blackHolePlayers = [try! AVAudioPlayer(contentsOf: Bundle.main.url(forResource: Sound.blackHole.resource, withExtension: Sound.blackHole.resourceExtension)!), try! AVAudioPlayer(contentsOf: Bundle.main.url(forResource: Sound.blackHole.resource, withExtension: Sound.blackHole.resourceExtension)!), try! AVAudioPlayer(contentsOf: Bundle.main.url(forResource: Sound.blackHole.resource, withExtension: Sound.blackHole.resourceExtension)!)]
        self.blackHolePlayers.forEach({ $0.prepareToPlay() })

        // Planet
        self.planetPlayers = [try! AVAudioPlayer(contentsOf: Bundle.main.url(forResource: Sound.planet.resource, withExtension: Sound.planet.resourceExtension)!), try! AVAudioPlayer(contentsOf: Bundle.main.url(forResource: Sound.planet.resource, withExtension: Sound.planet.resourceExtension)!), try! AVAudioPlayer(contentsOf: Bundle.main.url(forResource: Sound.planet.resource, withExtension: Sound.planet.resourceExtension)!)]
        self.planetPlayers.forEach({ $0.prepareToPlay() })

        // Explosion
        self.explosionPlayers = [try! AVAudioPlayer(contentsOf: Bundle.main.url(forResource: Sound.explosion.resource, withExtension: Sound.explosion.resourceExtension)!), try! AVAudioPlayer(contentsOf: Bundle.main.url(forResource: Sound.explosion.resource, withExtension: Sound.explosion.resourceExtension)!), try! AVAudioPlayer(contentsOf: Bundle.main.url(forResource: Sound.explosion.resource, withExtension: Sound.explosion.resourceExtension)!)]
        self.explosionPlayers.forEach({ $0.prepareToPlay() })
    }

    static let shared = SoundManager()
    var introPlayer: AVAudioPlayer
    var gameplayPlayer: AVAudioPlayer
    private var flashPlayer: AVAudioPlayer
    private var blackHolePlayers: [AVAudioPlayer]
    private var planetPlayers: [AVAudioPlayer]
    private var explosionPlayers: [AVAudioPlayer]

    func playSound(_ sound: Sound) {

        switch sound {
        case .intro:
            DispatchQueue.global(qos: .background).async {
                self.introPlayer.play()
            }
        case .gameplay:
            DispatchQueue.global(qos: .background).async {
                self.gameplayPlayer.play()
            }
        case .flash:
            DispatchQueue.global(qos: .background).async {
                self.flashPlayer.play()
            }
        case .blackHole:
            if let player = blackHolePlayers.first(where: { !$0.isPlaying } ) {
                DispatchQueue.global(qos: .background).async {
                    player.play()
                }
            }
        case .planet:
            if let player = planetPlayers.first(where: { !$0.isPlaying } ) {
                DispatchQueue.global(qos: .background).async {
                    player.play()
                }
            }
        case .explosion:
            if let player = explosionPlayers.first(where: { !$0.isPlaying } ) {
                DispatchQueue.global(qos: .background).async {
                    player.play()
                }
            }
        }
    }
}
