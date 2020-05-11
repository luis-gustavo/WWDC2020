//
//  BlackHoleNode.swift
//  wwdc2020
//
//  Created by Luis Gustavo Avelino de Lima Jacinto on 11/05/20.
//  Copyright © 2020 Luis Gustavo Avelino de Lima Jacinto. All rights reserved.
//

import SpriteKit

class BlackHoleNode: SKShapeNode {

    func suckPlanet(_ planet: Planet) {
        planet.removeFromParent()
        addChild(planet)
        suckAction(planet)
    }

    private func suckAction(_ planet: Planet) {
        planet.position = .zero
        let spiral = SKAction.spiral(startRadius: frame.size.width/2, endRadius: 0, angle: .pi * 8, centerPoint: planet.position, duration: 5.0)
        let scaleDown = SKAction.scale(by: 0.5, duration: 5.0)
        let fadeOut = SKAction.fadeOut(withDuration: 5.0)
        let group = SKAction.group([spiral, scaleDown, fadeOut])
        planet.run(group) {
            planet.removeFromParent()
        }
    }
}
