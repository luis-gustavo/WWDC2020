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
    func setup()
    func changeState(active: Bool)
}

extension Planet {
    func setup() {
        color = .gray
        colorBlendFactor = 1.0
    }
}
