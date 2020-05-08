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
    var gravityField: SKFieldNode!
    var lightNode = SKLightNode()

    lazy var player: AVAudioPlayer? = try? AVAudioPlayer(contentsOf: Bundle.main.url(forResource: "loop", withExtension: "wav")!)

    override var position: CGPoint {
        didSet {
            NotificationCenter.default.post(name: .sunPositionChanged, object: nil, userInfo: ["position": position])
        }
    }

    func setup() {
        player?.numberOfLoops = -1
        player?.prepareToPlay()
        player?.play()

        physicsBody = SKPhysicsBody(circleOfRadius: PlanetsType.sun.radius)
        physicsBody?.affectedByGravity = false
        physicsBody?.fieldBitMask = PlanetsType.sun.fieldMask

        gravityField = SKFieldNode.radialGravityField()
        fillColor = .yellow

        // Setup gravity field
        gravityField.falloff = 0
        gravityField.strength = 2
        gravityField.categoryBitMask = PlanetsType.star.fieldMask
        addChild(gravityField)

        // SKLight node
        lightNode.falloff = 2
        lightNode.position = .zero
        lightNode.lightColor = .white
        lightNode.categoryBitMask = PlanetsType.background.fieldMask | PlanetsType.planet.fieldMask | PlanetsType.star.fieldMask | PlanetsType.sun.fieldMask
        addChild(lightNode)
    }

}

extension SunNode: AVAudioPlayerDelegate {

}
