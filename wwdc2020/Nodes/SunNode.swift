//
//  SunNode.swift
//  wwdc2020
//
//  Created by Luis Gustavo Avelino de Lima Jacinto on 08/05/20.
//  Copyright © 2020 Luis Gustavo Avelino de Lima Jacinto. All rights reserved.
//

import SpriteKit
import AVFoundation

final class SunNode: SKShapeNode {

    // MARK: - Properties
    var lightNode = SKLightNode()

    override var position: CGPoint {
        didSet {
            NotificationCenter.default.post(name: .sunPositionChanged, object: nil, userInfo: ["position": position])
        }
    }

    func setup() {
        physicsBody = SKPhysicsBody(circleOfRadius: PlanetType.sun.radius)
        physicsBody?.affectedByGravity = false
        physicsBody?.isDynamic = false
        physicsBody?.fieldBitMask = PlanetType.sun.fieldMask

        fillColor = .yellow

        // SKLight node
        lightNode.falloff = 2.0//3.0
        lightNode.position = .zero
        lightNode.lightColor = .yellow
        lightNode.categoryBitMask = PlanetType.background.fieldMask
        addChild(lightNode)
    }


}
