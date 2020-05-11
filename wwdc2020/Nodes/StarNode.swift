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
    var lightNode = SKLightNode()
    var removed = false

    func setup() {
        fillColor = .orange
        lightNode.falloff = 4
        lightNode.position = .zero
        lightNode.lightColor = .orange
        lightNode.categoryBitMask = PlanetsType.background.fieldMask
        addChild(lightNode)
    }

    func contactWithSunDidHappen() {
        NotificationCenter.default.post(name: .collisionWithStar, object: nil)
        removed = true
        let fadeOut = SKAction.fadeOut(withDuration: 0.3)
        self.run(fadeOut) { [weak self] in
            self?.removeFromParent()
        }
    }
}
