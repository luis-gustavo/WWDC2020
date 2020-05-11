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
    var isActive = false {
        didSet {
            changeState(active: isActive)
        }
    }
    var lightNode = SKLightNode()

    func setup(_ musicName: String) {
        fillColor = .gray
    }

    private func changeState(active: Bool) {
        if active {
            fillColor = .orange

            // SKLight node
            lightNode.falloff = 3
            lightNode.position = .zero
            lightNode.lightColor = .orange
            lightNode.categoryBitMask = PlanetsType.background.fieldMask | PlanetsType.planet.fieldMask | PlanetsType.shootingStar.fieldMask | PlanetsType.sun.fieldMask
            addChild(lightNode)
        } else {
            physicsBody = nil
        }
    }
}
