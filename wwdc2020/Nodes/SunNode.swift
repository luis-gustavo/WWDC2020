//
//  SunNode.swift
//  wwdc2020
//
//  Created by Luis Gustavo Avelino de Lima Jacinto on 08/05/20.
//  Copyright © 2020 Luis Gustavo Avelino de Lima Jacinto. All rights reserved.
//

import SpriteKit
import AVFoundation

final class SunNode: SKSpriteNode {

    // MARK: - Properties
    var lightNode = SKLightNode()
    let sprite = SKTexture(imageNamed: "Sun")
    let lightColor = UIColor(red: 241/255, green: 192/255, blue: 47/255, alpha: 1.0)
    override var position: CGPoint {
        didSet {
            NotificationCenter.default.post(name: .sunPositionChanged, object: nil, userInfo: ["position": position])
        }
    }
    var orbitPaths = [(SKShapeNode, CGPoint)]()

    // MARK: - Inits
    init() {
        super.init(texture: sprite, color: .clear, size: sprite.size())
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
        physicsBody = SKPhysicsBody(circleOfRadius: PlanetType.sun.radius)
        physicsBody?.affectedByGravity = false
        physicsBody?.isDynamic = false
        physicsBody?.fieldBitMask = PlanetType.sun.fieldMask

        // SKLight node
        lightNode.falloff = 1.0
        lightNode.position = .zero
        lightNode.lightColor = lightColor
        lightNode.categoryBitMask = PlanetType.background.fieldMask
        addChild(lightNode)
    }

    func addOrbitPath(orbitRadius: CGPoint) {
        let radius = orbitRadius.x
        let orbitPath = SKShapeNode(circleOfRadius: radius)
        orbitPath.strokeColor = .white
        orbitPath.glowWidth = 1.0
        orbitPath.fillColor = .clear
        orbitPath.alpha = 0.1
        addChild(orbitPath)
        self.orbitPaths.append((orbitPath, orbitRadius))
    }

    func removeOrbitPath(orbitRadius: CGPoint) {
        if let index = self.orbitPaths.firstIndex(where: { $0.1 == orbitRadius }) {
            let orbitPath = orbitPaths[index].0
            orbitPath.removeFromParent()
            self.orbitPaths.remove(at: index)
        }
    }

}
