//
//  GameManager.swift
//  wwdc2020
//
//  Created by Luis Gustavo Avelino de Lima Jacinto on 13/05/20.
//  Copyright © 2020 Luis Gustavo Avelino de Lima Jacinto. All rights reserved.
//

import Foundation

class GameManager {
    static let shared = GameManager()

    private var planetsCollected = 0

    @objc private func planetCollected(notification: Notification) {
        planetsCollected += 1
        let volume = planetsCollectedToVolume(amount: planetsCollected)
        SoundManager.shared.changeVolume(volume)
    }

    private func planetsCollectedToVolume(amount: Int) -> Float {
        switch amount {
        case 0: return 1
        case 1: return 3
        case 2: return 4
        case 3: return 5
        case 4: return 6
        case 5: return 7
        case 6: return 8
        case 7: return 9
        case 8: return 10
        default: fatalError("This should never happen")
        }
    }

    private init () {
        NotificationCenter.default.addObserver(self, selector: #selector(planetCollected(notification:)), name: .planetCollected, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: .planetCollected, object: nil)
    }
}
