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

    var inCustscene = false
    var planetsCollected = 0

    private init () {
        NotificationCenter.default.addObserver(self, selector: #selector(planetCollected(_:)), name: .planetCollected, object: nil)
    }

    @objc private func planetCollected(_ notification: Notification) {
        planetsCollected += 1
        if planetsCollected == 8 {
            NotificationCenter.default.post(name: .collectedAllPlanets, object: nil)
            NotificationCenter.default.removeObserver(self, name: .planetCollected, object: nil)
        }
    }
}
