//
//  BlackHoleNode.swift
//  wwdc2020
//
//  Created by Luis Gustavo Avelino de Lima Jacinto on 11/05/20.
//  Copyright © 2020 Luis Gustavo Avelino de Lima Jacinto. All rights reserved.
//

import SpriteKit

class BlackHoleNode: SKSpriteNode {

    // MARK: - Properties
    let sprite = SKTexture(imageNamed: "Black Hole")
    let lightNode = SKLightNode()
    let lightColor = UIColor(red: 45/255, green: 21/255, blue: 89/255, alpha: 1.0)

    // MARK: - Inits
    init() {
        super.init(texture: sprite, color: .clear, size: sprite.size())

        // SKLight node
        lightNode.falloff = 1.0
        lightNode.position = .zero
        lightNode.lightColor = lightColor
        lightNode.categoryBitMask = PlanetType.background.fieldMask
        addChild(lightNode)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
