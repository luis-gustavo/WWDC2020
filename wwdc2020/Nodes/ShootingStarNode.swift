//
//  StarNode.swift
//  wwdc2020
//
//  Created by Luis Gustavo Avelino de Lima Jacinto on 08/05/20.
//  Copyright © 2020 Luis Gustavo Avelino de Lima Jacinto. All rights reserved.
//

import SpriteKit
import AVFoundation

final class ShootingStarNode: SKShapeNode {

    // MARK: - Properties
    let lineTrailDuration: TimeInterval = 2.5
    var lastPosition: CGPoint?
//    var isActive = false //{
//        didSet {
//            changeState(active: isActive)
//        }
//    }
    var lightNode = SKLightNode()
//    var player: AVAudioPlayer?

    func setup(/*_ musicName: String*/) {
//        player = try? AVAudioPlayer(contentsOf: Bundle.main.url(forResource: musicName, withExtension: "mp3")!)
//        player?.prepareToPlay()
        lightNode.falloff = 3
        lightNode.position = .zero
        lightNode.lightColor = .white
        lightNode.categoryBitMask = PlanetsType.background.fieldMask | PlanetsType.planet.fieldMask | PlanetsType.shootingStar.fieldMask | PlanetsType.sun.fieldMask
        addChild(lightNode)
        fillColor = .white
        strokeColor = .white
    }

//    private func changeState(active: Bool) {
//        if active {
//            fillColor = .white
//            strokeColor = .white
//            physicsBody = SKPhysicsBody(circleOfRadius: PlanetsType.shootingStar.radius)
//            physicsBody?.affectedByGravity = false
//            physicsBody?.fieldBitMask = PlanetsType.shootingStar.fieldMask
//            player?.volume = 1
//
//            // SKLight node
//            lightNode.falloff = 3
//            lightNode.position = .zero
//            lightNode.lightColor = .white
//            lightNode.categoryBitMask = PlanetsType.background.fieldMask | PlanetsType.planet.fieldMask | PlanetsType.shootingStar.fieldMask | PlanetsType.sun.fieldMask
//            addChild(lightNode)
//        } else {
//            physicsBody = nil
//        }
//    }
}
