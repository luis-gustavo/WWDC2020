//
//  Earth.swift
//  wwdc2020
//
//  Created by Luis Gustavo Avelino de Lima Jacinto on 11/05/20.
//  Copyright © 2020 Luis Gustavo Avelino de Lima Jacinto. All rights reserved.
//

import SpriteKit

class Earth: SKShapeNode, Planet {
    var removed: Bool = false
    var orbitRadius: CGPoint = CGPoint(x: 260, y: 260)
    var period: CGFloat = 3

    var isActive: Bool = false {
        didSet {
            changeState(active: isActive)
        }
    }

    var lightNode: SKLightNode = SKLightNode()

    func changeState(active: Bool) {
        if active {
            fillColor = .blue
            physicsBody = SKPhysicsBody(circleOfRadius: PlanetsType.planet.radius)
            physicsBody?.affectedByGravity = false
            physicsBody?.fieldBitMask = PlanetsType.planet.fieldMask

            // SKLight node
            lightNode.falloff = 3
            lightNode.position = .zero
            lightNode.lightColor = .blue
            lightNode.categoryBitMask = PlanetsType.background.fieldMask
            addChild(lightNode)
        } else {
            physicsBody = nil
        }
    }
}
