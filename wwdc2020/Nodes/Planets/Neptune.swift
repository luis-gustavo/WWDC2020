//
//  Neptune.swift
//  wwdc2020
//
//  Created by Luis Gustavo Avelino de Lima Jacinto on 11/05/20.
//  Copyright © 2020 Luis Gustavo Avelino de Lima Jacinto. All rights reserved.
//

import SpriteKit

class Neptune: SKSpriteNode, Planet {
    var solarSystemPlanet: SolarSystemPlanet {
        return SolarSystemPlanet.neptune
    }
    var sprite: SKTexture = SKTexture(imageNamed: "Neptune")
    var lightColor: UIColor = UIColor(red: 160/255, green: 118/255, blue: 148/255, alpha: 1.0)
    var removed: Bool = false
    var orbitRadius: CGPoint = PlanetType.planet(.neptune).orbitRadius
    var period: CGFloat = PlanetType.planet(.neptune).period
    var isActive: Bool = false {
        didSet {
            changeState(active: isActive)
        }
    }
    var lightNode: SKLightNode = SKLightNode()

    // MARK: - Inits
    init() {
        let diameter = PlanetType.planet(.neptune).radius * 2
        super.init(texture: sprite, color: .clear, size: CGSize(width: diameter, height: diameter))
        name = PlanetType.planet(.neptune).name
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func changeState(active: Bool) {
        if active {
            color = .clear
            colorBlendFactor = 0
            physicsBody = SKPhysicsBody(circleOfRadius: PlanetType.planet(.neptune).radius)
            physicsBody?.affectedByGravity = false
            physicsBody?.fieldBitMask = PlanetType.planet(.neptune).fieldMask
            physicsBody?.allowsRotation = false

            // SKLight node
            lightNode.falloff = 2.5
            lightNode.position = .zero
            lightNode.lightColor = lightColor
            lightNode.categoryBitMask = PlanetType.background.fieldMask
            addChild(lightNode)
        } else {
            physicsBody = nil
        }
    }
}
