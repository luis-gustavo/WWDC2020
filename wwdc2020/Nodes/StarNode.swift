//
//  StarNode.swift
//  wwdc2020
//
//  Created by Luis Gustavo Avelino de Lima Jacinto on 11/05/20.
//  Copyright © 2020 Luis Gustavo Avelino de Lima Jacinto. All rights reserved.
//

import SpriteKit

class StarNode: SKShapeNode {

    // MARK: - Properties

    func setup() {
        fillColor = .white

        blinkForeverAction()
    }

    private func blinkForeverAction() {
        let blinkDuration = TimeInterval.random(in: 0.5 ... 1.0)
        let fadeOutAction = SKAction.fadeOut(withDuration: blinkDuration)
        let wait = SKAction.wait(forDuration: TimeInterval.random(in: 0.5 ... 2.0))
        let fadeInAction = SKAction.fadeIn(withDuration: blinkDuration)
        let longWait = SKAction.wait(forDuration: TimeInterval.random(in: 2.5 ... 4.0))
        let sequence = SKAction.sequence([longWait, fadeOutAction, wait, fadeInAction, longWait])
        let repeatForever = SKAction.repeatForever(sequence)
        run(repeatForever)
    }
}
