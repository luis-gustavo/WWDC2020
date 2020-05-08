//
//  StarNode.swift
//  wwdc2020
//
//  Created by Luis Gustavo Avelino de Lima Jacinto on 08/05/20.
//  Copyright © 2020 Luis Gustavo Avelino de Lima Jacinto. All rights reserved.
//

import SpriteKit
import AVFoundation

final class StarNode: SKShapeNode {

    // MARK: - Properties
    let lineTrailDuration: TimeInterval = 2.5
    var lastPosition: CGPoint?
    var isActive = false {
        didSet {
            changeState(active: isActive)
        }
    }
    var lightNode = SKLightNode()
    lazy var player: AVAudioPlayer? = try? AVAudioPlayer(contentsOf: Bundle.main.url(forResource: "loopTwo", withExtension: "wav")!)

    func setup() {
        player?.prepareToPlay()
        player?.play()
        player?.volume = 0
        player?.numberOfLoops = -1
        fillColor = .gray
    }

    private func changeState(active: Bool) {
        if active {
            fillColor = .red
            physicsBody = SKPhysicsBody(circleOfRadius: PlanetsType.star.radius)
            physicsBody?.affectedByGravity = false
            physicsBody?.fieldBitMask = PlanetsType.star.fieldMask
            player?.volume = 1

            // SKLight node
            lightNode.falloff = 3
            lightNode.position = .zero
            lightNode.lightColor = .white
            lightNode.categoryBitMask = PlanetsType.background.fieldMask | PlanetsType.planet.fieldMask | PlanetsType.star.fieldMask | PlanetsType.sun.fieldMask
            addChild(lightNode)
        } else {
            physicsBody = nil
        }
    }
    
    // MARK: - Update
    func update(_ currentTime: TimeInterval) {
        
    }
}
