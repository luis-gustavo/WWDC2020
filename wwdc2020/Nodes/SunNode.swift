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
    var player: AVAudioPlayer?

    override var position: CGPoint {
        didSet {
            NotificationCenter.default.post(name: .sunPositionChanged, object: nil, userInfo: ["position": position])
        }
    }

    func setup() {
        player = try? AVAudioPlayer(contentsOf: Bundle.main.url(forResource: "ClassicElectricPiano4", withExtension: "mp3")!)
        player?.delegate = self
//        player?.numberOfLoops = -1
        player?.prepareToPlay()

        physicsBody = SKPhysicsBody(circleOfRadius: PlanetsType.sun.radius)
        physicsBody?.affectedByGravity = false
        physicsBody?.fieldBitMask = PlanetsType.sun.fieldMask

        gravityField = SKFieldNode.radialGravityField()
        fillColor = .yellow

        // Setup gravity field
        gravityField.falloff = 0
        gravityField.strength = 2
        gravityField.categoryBitMask = PlanetsType.shootingStar.fieldMask
        addChild(gravityField)

        // SKLight node
        lightNode.falloff = 2
        lightNode.position = .zero
        lightNode.lightColor = .yellow
        lightNode.categoryBitMask = PlanetsType.background.fieldMask | PlanetsType.planet.fieldMask | PlanetsType.shootingStar.fieldMask | PlanetsType.sun.fieldMask
        addChild(lightNode)
    }

}

extension SunNode: AVAudioPlayerDelegate {

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {

        NotificationCenter.default.post(name: .audioDidFinish, object: nil)
    }
}
