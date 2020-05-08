//
//  GameScene.swift
//  wwdc2020
//
//  Created by Luis Gustavo Avelino de Lima Jacinto on 08/05/20.
//  Copyright © 2020 Luis Gustavo Avelino de Lima Jacinto. All rights reserved.
//

import SpriteKit
import GameplayKit

enum PhysicsCategory: UInt32 {
    case none = 0x0
    case sun = 0x1
    case others = 0x2
}

class GameScene: SKScene {

    let shapeNode1: SKShapeNode
    let shapeNode2: SKShapeNode
    let gravityField: SKFieldNode
    var lp: CGPoint?

    // MARK: - Inits
    override init(size: CGSize) {
        shapeNode1 = SKShapeNode(circleOfRadius: 10)
        shapeNode2 = SKShapeNode(circleOfRadius: 5)
//        gravityField = SKFieldNode.linearGravityField(withVector: vector_float3(0, -1, 0))
        gravityField = SKFieldNode.radialGravityField()
        gravityField.falloff = 0.0
        gravityField.strength = 2
//        gravityField.strength = 9.8


        super.init(size: size)

        physicsWorld.gravity = .zero
        shapeNode1.fillColor = .blue
        shapeNode1.position = CGPoint(x: size.width/2, y: size.height/2)
//        shapeNode1.physicsBody = SKPhysicsBody(circleOfRadius: 10)
//        shapeNode1.physicsBody?.affectedByGravity = false
//        shapeNode1.physicsBody?.fieldBitMask = PhysicsCategory.sun.rawValue

        shapeNode2.fillColor = .red
        shapeNode2.position = CGPoint(x: shapeNode1.position.x + 30, y: shapeNode1.position.y + 30)
        shapeNode2.physicsBody = SKPhysicsBody(circleOfRadius: 5)
        shapeNode2.physicsBody?.affectedByGravity = false
        shapeNode2.physicsBody?.fieldBitMask = PhysicsCategory.others.rawValue
//        shapeNode2.physicsBody?.mass = 0

        gravityField.categoryBitMask = PhysicsCategory.others.rawValue

        addChild(shapeNode1)
        addChild(shapeNode2)
        shapeNode1.addChild(gravityField)

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - DidMove
    override func didMove(to view: SKView) {
        super.didMove(to: view)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        let touch = touches.first!
        let location = touch.location(in: self)
        let moveAction = SKAction.move(to: location, duration: 1.0)
        shapeNode1.run(moveAction)

    }

    override func update(_ currentTime: TimeInterval) {


        if let lastPosition = lp {
            let path = CGMutablePath()
            path.move(to: lastPosition)
            path.addLine(to: shapeNode2.position)
            let lineSegment = SKShapeNode(path: path)
            lineSegment.strokeColor = shapeNode2.fillColor
            lineSegment.fillColor = shapeNode2.fillColor
            addChild(lineSegment)
            let fadeOut = SKAction.fadeOut(withDuration: 2.5)
            let remove = SKAction.removeFromParent()
            let sequence = SKAction.sequence([fadeOut, remove])
            lineSegment.run(sequence)
        }
        lp = shapeNode2.position

//        planet.lastPosition = planet.node.position
    }
}
