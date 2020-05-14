//
//  BackgroundLayer.swift
//  wwdc2020
//
//  Created by Luis Gustavo Avelino de Lima Jacinto on 08/05/20.
//  Copyright © 2020 Luis Gustavo Avelino de Lima Jacinto. All rights reserved.
//

import SpriteKit

final class BackgroundLayer: SKNode {

    // MARK: - Properties
    let size: CGSize
    let background = SKSpriteNode(imageNamed: "nebula")
    let shootingStar: ShootingStarNode

    // MARK: - Inits
    init(size: CGSize) {
        self.size = size

        // Shooting Stars
        self.shootingStar = ShootingStarNode(circleOfRadius: 3)
        self.shootingStar.setup()

        super.init()

        // Background
        addChild(background)
        background.zPosition = -3
        background.size = CGSize(width: size.width * 3, height: size.height * 3)
        background.lightingBitMask = PlanetType.background.fieldMask

        // Stars
        for _ in 1...50 {
            let star = StarNode(circleOfRadius: PlanetType.star.radius)
            star.position = CGPoint(x: CGFloat.random(in: background.frame.minX + 10 ... background.frame.maxX - 10), y: CGFloat.random(in: background.frame.minY + 10 ... background.frame.maxY - 10))
            star.setup()
            addChild(star)
        }

        // Shooting Star
        addChild(shootingStar)
        self.setupShootingStar()
        Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { [weak self] _ in
            self?.setupShootingStar()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupShootingStar() {
        let random = Int.random(in: 1...4)
        let initialPosition: CGPoint
        let finalPosition: CGPoint
        switch random {
        case 1: // left to right
            initialPosition = CGPoint(x: background.frame.minX - 20, y: CGFloat.random(in: background.frame.minY - 20 ... background.frame.maxY + 20))
            finalPosition = CGPoint(x: background.frame.maxX + 20, y: CGFloat.random(in: background.frame.minY - 20 ... background.frame.maxY + 20))
        case 2: // top to bottom
            initialPosition = CGPoint(x: CGFloat.random(in: background.frame.minX - 20 ... background.frame.maxX + 20), y: background.frame.maxY + 20)
            finalPosition = CGPoint(x: CGFloat.random(in: background.frame.minX - 20 ... background.frame.maxX + 20), y: background.frame.minY - 20)
        case 3: // right to left
            initialPosition = CGPoint(x: background.frame.maxX + 20, y: CGFloat.random(in: background.frame.minY - 20 ... background.frame.maxY + 20))
            finalPosition = CGPoint(x: background.frame.minX - 20, y: CGFloat.random(in: background.frame.minY - 20 ... background.frame.maxY + 20))
        default: // bottom to top
            initialPosition = CGPoint(x: CGFloat.random(in: background.frame.minX - 20 ... background.frame.maxX + 20), y: background.frame.minY - 20)
            finalPosition = CGPoint(x: CGFloat.random(in: background.frame.minX - 20 ... background.frame.maxX + 20), y: background.frame.maxY + 20)
        }

        shootingStar.alpha = 1
        shootingStar.position = initialPosition
        let moveAction = SKAction.move(to: finalPosition, duration: 5.0)
        let run = SKAction.run {
            self.shootingStar.lastPosition = nil
        }
        let fadeOut = SKAction.fadeOut(withDuration: 1.5)
        let sequence = SKAction.sequence([moveAction, fadeOut, run])
        shootingStar.run(sequence)
    }

    func update(_ currentTime: TimeInterval) {
        if let lastPosition = shootingStar.lastPosition {
            let lastPositionInSelf = convert(lastPosition, to: self)
            let positionInSelf = convert(shootingStar.position, to: self)
            let path = CGMutablePath()
            path.move(to: lastPositionInSelf)
            path.addLine(to: positionInSelf)
            let lineSegment = SKShapeNode(path: path)
            lineSegment.strokeColor = shootingStar.fillColor
            lineSegment.fillColor = shootingStar.fillColor
            addChild(lineSegment)
            let fadeOut = SKAction.fadeOut(withDuration: shootingStar.lineTrailDuration)
            let remove = SKAction.removeFromParent()
            let sequence = SKAction.sequence([fadeOut, remove])
            lineSegment.run(sequence)
        }
        shootingStar.lastPosition = shootingStar.position
    }
}
