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
    var lightNode = SKLightNode()

    override var position: CGPoint {
        didSet {
            NotificationCenter.default.post(name: .sunPositionChanged, object: nil, userInfo: ["position": position])
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: .collisionWithStar, object: nil)
    }


    func setup() {
        physicsBody = SKPhysicsBody(circleOfRadius: PlanetsType.sun.radius)
        physicsBody?.affectedByGravity = false
        physicsBody?.fieldBitMask = PlanetsType.sun.fieldMask

        fillColor = .yellow

        // SKLight node
        lightNode.falloff = 1.0//3.0
        lightNode.position = .zero
        lightNode.lightColor = .yellow
        lightNode.categoryBitMask = PlanetsType.background.fieldMask
        addChild(lightNode)

        NotificationCenter.default.addObserver(self, selector: #selector(collisionWithStar(_:)), name: .collisionWithStar, object: nil)

//        Timer.scheduledTimer(withTimeInterval: 2.5, repeats: true) { [weak self] _ in
//            guard let self = self else { return }
//            self.lightNode.falloff += 0.1
//            print(self.lightNode.falloff)
//            NotificationCenter.default.post(name: .sunlightDecayed, object: nil, userInfo: ["falloff": self.lightNode.falloff])
//        }
    }

    @objc private func collisionWithStar(_ notification: Notification) {
        let applier: CGFloat = 0.3
        lightNode.falloff = lightNode.falloff - applier <= 0.1 ? 1.0 : lightNode.falloff - applier
        print(lightNode.falloff)
        NotificationCenter.default.post(name: .sunlightDecayed, object: nil, userInfo: ["falloff": self.lightNode.falloff])
    }

}
