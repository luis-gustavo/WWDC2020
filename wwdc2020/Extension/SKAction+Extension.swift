//
//  SKAction+Extension.swift
//  wwdc2020
//
//  Created by Luis Gustavo Avelino de Lima Jacinto on 11/05/20.
//  Copyright © 2020 Luis Gustavo Avelino de Lima Jacinto. All rights reserved.
//

import SpriteKit

fileprivate func pointOnCircle(angle: CGFloat, radius: CGFloat, center: CGPoint) -> CGPoint {
    return CGPoint(x: center.x + radius * cos(angle),
                   y: center.y + radius * sin(angle))
}

extension SKAction {
    static func spiral(startRadius: CGFloat, endRadius: CGFloat, angle
         totalAngle: CGFloat, centerPoint: CGPoint, duration: TimeInterval) -> SKAction {

        // The distance tbhe node will travel away from/towards the
        // center point, per revolution.
        let radiusPerRevolution = (endRadius - startRadius) / totalAngle

        let action = SKAction.customAction(withDuration: duration) { node, time in
            // The current angle the node is at.
            let θ = totalAngle * time / CGFloat(duration)

            // The equation, r = a + bθ
            let radius = startRadius + radiusPerRevolution * θ

            node.position = pointOnCircle(angle: θ, radius: radius, center: centerPoint)
        }

        return action
    }
}
