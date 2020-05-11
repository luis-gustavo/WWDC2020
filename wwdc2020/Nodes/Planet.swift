//
//  Planet.swift
//  wwdc2020
//
//  Created by Luis Gustavo Avelino de Lima Jacinto on 11/05/20.
//  Copyright © 2020 Luis Gustavo Avelino de Lima Jacinto. All rights reserved.
//

import SpriteKit
import AVFoundation

class PlanetNode: SKShapeNode {

    // MARK: - Properties
    var isActive = false {
        didSet {
            changeState(active: isActive)
        }
    }
    var lightNode = SKLightNode()
    var player: AVAudioPlayer?

    func setup(_ musicName: String) {
        player = try? AVAudioPlayer(contentsOf: Bundle.main.url(forResource: musicName, withExtension: "mp3")!)
        player?.prepareToPlay()
        fillColor = .gray
    }

    private func changeState(active: Bool) {
        if active {
            fillColor = .green
            physicsBody = SKPhysicsBody(circleOfRadius: PlanetsType.planet.radius)
            physicsBody?.affectedByGravity = false
            physicsBody?.fieldBitMask = PlanetsType.planet.fieldMask
            player?.volume = 1


            // SKLight node
            lightNode.falloff = 3
            lightNode.position = .zero
            lightNode.lightColor = .green
            lightNode.categoryBitMask = PlanetsType.background.fieldMask | PlanetsType.planet.fieldMask | PlanetsType.shootingStar.fieldMask | PlanetsType.sun.fieldMask
            addChild(lightNode)
        } else {
            physicsBody = nil
        }
    }
}
