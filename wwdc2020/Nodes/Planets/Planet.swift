//
//  Planet.swift
//  wwdc2020
//
//  Created by Luis Gustavo Avelino de Lima Jacinto on 11/05/20.
//  Copyright © 2020 Luis Gustavo Avelino de Lima Jacinto. All rights reserved.
//

import SpriteKit

protocol Planet: SKSpriteNode {
    var orbitRadius: CGPoint { get set }
    var period: CGFloat { get set }
    var isActive: Bool { get set }
    var lightNode: SKLightNode { get set }
    var removed: Bool { get set }
    var sprite: SKTexture { get set }
    var lightColor: UIColor { get set }
    var solarSystemPlanet: SolarSystemPlanet { get }
    func setup()
    func changeState(active: Bool)
    func moveSlowly()
}

extension Planet {
    func setup() {
        color = .gray
        colorBlendFactor = 1.0
        moveSlowly()
    }

    func moveSlowly() {
        let wait = SKAction.wait(forDuration: 1.0)
        let moveAction = SKAction.run { [weak self] in
            let dx = CGFloat.random(in: -20...20)
            let dy = CGFloat.random(in: -20...20)
            let move = SKAction.move(by: CGVector(dx: dx, dy: dy), duration: 4.0)
            self?.run(move)
        }
        let sequence = SKAction.sequence([moveAction, wait])
        let repeatForever = SKAction.repeatForever(sequence)
        run(repeatForever)
    }
}


