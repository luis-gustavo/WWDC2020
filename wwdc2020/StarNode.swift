//
//  StarNode.swift
//  wwdc2020
//
//  Created by Luis Gustavo Avelino de Lima Jacinto on 08/05/20.
//  Copyright © 2020 Luis Gustavo Avelino de Lima Jacinto. All rights reserved.
//

import SpriteKit

class StarNode: SKShapeNode {

    let lineTrailDuration: TimeInterval = 2.5
    var lastPosition: CGPoint?
    var isActive = true

    func setup() {
        fillColor = .red
        physicsBody = SKPhysicsBody(circleOfRadius: PlanetsType.star.radius)
        physicsBody?.affectedByGravity = false
        physicsBody?.fieldBitMask = PlanetsType.star.fieldMask
    }
    
    // MARK: - Update
    func update(_ currentTime: TimeInterval) {
        
    }
}
