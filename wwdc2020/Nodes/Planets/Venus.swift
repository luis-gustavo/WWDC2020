//
//  Venus.swift
//  wwdc2020
//
//  Created by Luis Gustavo Avelino de Lima Jacinto on 11/05/20.
//  Copyright © 2020 Luis Gustavo Avelino de Lima Jacinto. All rights reserved.
//

import SpriteKit

class Venus: SKSpriteNode, Planet {
    var solarSystemPlanet: SolarSystemPlanet {
        return SolarSystemPlanet.venus
    }
    var sprite: SKTexture = SKTexture(imageNamed: "Venus")
    var lightColor: UIColor = .white
    var removed: Bool = false
    var orbitRadius: CGPoint = PlanetType.planet(.venus).orbitRadius
    var period: CGFloat = PlanetType.planet(.venus).period
    var isActive: Bool = false {
        didSet {
            changeState(active: isActive)
        }
    }
    var lightNode: SKLightNode = SKLightNode()

    // MARK: - Inits
    init() {
        let diameter = PlanetType.planet(.venus).radius * 2
        super.init(texture: sprite, color: .clear, size: CGSize(width: diameter, height: diameter))
        name = PlanetType.planet(.venus).name
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func changeState(active: Bool) {
        if active {
            color = .clear
            colorBlendFactor = 0
            physicsBody = SKPhysicsBody(circleOfRadius: PlanetType.planet(.venus).radius)
            physicsBody?.affectedByGravity = false
            physicsBody?.fieldBitMask = PlanetType.planet(.venus).fieldMask
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
