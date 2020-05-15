//
//  FlashWhiteNode.swift
//  wwdc2020
//
//  Created by Luis Gustavo Avelino de Lima Jacinto on 14/05/20.
//  Copyright © 2020 Luis Gustavo Avelino de Lima Jacinto. All rights reserved.
//

import SpriteKit

class FlashWhiteNode: SKShapeNode {

    func start() {
        fillColor = .white
        alpha = 0

        let fadeIn = SKAction.fadeIn(withDuration: 0.2)
        let wait = SKAction.wait(forDuration: 1.0)
        let block1 = SKAction.run {
            NotificationCenter.default.post(name: .explosionStarted, object: nil)
            SoundManager.shared.playSound(.flash)
        }
        let block2 = SKAction.run {
            NotificationCenter.default.post(name: .explosionEnded, object: nil)
        }
        let fadeOut = SKAction.fadeOut(withDuration: 1.0)
        let sequence = SKAction.sequence([block1, fadeIn, wait, fadeOut, block2])
        run(sequence)
    }
}
