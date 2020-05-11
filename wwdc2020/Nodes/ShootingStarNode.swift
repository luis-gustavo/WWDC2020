//
//  StarNode.swift
//  wwdc2020
//
//  Created by Luis Gustavo Avelino de Lima Jacinto on 08/05/20.
//  Copyright © 2020 Luis Gustavo Avelino de Lima Jacinto. All rights reserved.
//

import SpriteKit
import AVFoundation

final class ShootingStarNode: SKShapeNode {

    // MARK: - Properties
    let lineTrailDuration: TimeInterval = 2.0
    var lastPosition: CGPoint?
    var lightNode = SKLightNode()

    func setup() {
        fillColor = .white
        strokeColor = .white
        lightNode.falloff = 3
        lightNode.position = .zero
        lightNode.lightColor = .white
        lightNode.categoryBitMask = PlanetsType.background.fieldMask
        addChild(lightNode)
    }
}
