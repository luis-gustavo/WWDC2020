//
//  AsteroidNode.swift
//  wwdc2020
//
//  Created by Luis Gustavo Avelino de Lima Jacinto on 12/05/20.
//  Copyright © 2020 Luis Gustavo Avelino de Lima Jacinto. All rights reserved.
//

import SpriteKit

class AsteroidNode: SKSpriteNode {

    // MARK: - Properties
    let sprite = SKTexture(imageNamed: "Asteroid")
    var removed = false

    // MARK: - Inits
    init() {
        super.init(texture: sprite, color: .clear, size: sprite.size())
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func explosion() {
        texture = nil
        removeAllActions()
        let emmiter = SKEmitterNode(fileNamed: "Spark")!
        addChild(emmiter)
        let wait = SKAction.wait(forDuration: 0.5)
        run(wait) { [weak self] in
            self?.removeFromParent()
        }
    }

}
