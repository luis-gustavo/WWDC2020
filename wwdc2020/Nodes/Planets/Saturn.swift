//
//  Saturn.swift
//  wwdc2020
//
//  Created by Luis Gustavo Avelino de Lima Jacinto on 11/05/20.
//  Copyright © 2020 Luis Gustavo Avelino de Lima Jacinto. All rights reserved.
//

import SpriteKit

class Saturn: SKSpriteNode, Planet {
    var solarSystemPlanet: SolarSystemPlanet {
        return SolarSystemPlanet.saturn
    }
    var sprite: SKTexture = SKTexture(imageNamed: "Saturn")
    var lightColor: UIColor = UIColor(red: 252/255, green: 193/255, blue: 134/255, alpha: 1.0)
    var removed: Bool = false
    var orbitRadius: CGPoint = PlanetType.planet(.saturn).orbitRadius
    var period: CGFloat = PlanetType.planet(.saturn).period
    var isActive: Bool = false {
        didSet {
            changeState(active: isActive)
        }
    }
    var lightNode: SKLightNode = SKLightNode()

    // MARK: - Inits
    init() {
        let diameter = PlanetType.planet(.saturn).radius * 2
        super.init(texture: sprite, color: .clear, size: CGSize(width: diameter * 1.5, height: diameter))
        name = PlanetType.planet(.saturn).name
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func changeState(active: Bool) {
        if active {
            color = .clear
            colorBlendFactor = 0
            physicsBody = SKPhysicsBody(circleOfRadius: PlanetType.planet(.saturn).radius)
            physicsBody?.affectedByGravity = false
            physicsBody?.fieldBitMask = PlanetType.planet(.saturn).fieldMask
            physicsBody?.allowsRotation = false

            // SKLight node
            lightNode.falloff = 2.5
            lightNode.position = .zero
            lightNode.lightColor = lightColor
            lightNode.categoryBitMask = PlanetType.background.fieldMask
            addChild(lightNode)
        } else {
            physicsBody = nil
            lightNode.removeFromParent()
        }
    }
}
