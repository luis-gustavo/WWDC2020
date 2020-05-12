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
    var shootingStars = [ShootingStarNode]()

    // MARK: - Inits
    init(size: CGSize) {
        self.size = size

        // Shooting Stars
        self.shootingStars = [ShootingStarNode(circleOfRadius: PlanetType.shootingStar.radius),                   ShootingStarNode(circleOfRadius: PlanetType.shootingStar.radius)]
        shootingStars.forEach({ shootingStar in
            shootingStar.setup()
        })

        super.init()

        // Background
        addChild(background)
        background.zPosition = -1
        background.size = CGSize(width: size.width * 2, height: size.height * 2)
        background.lightingBitMask = PlanetType.background.fieldMask

        // Stars
        for _ in 1...50 {
            let star = StarNode(circleOfRadius: PlanetType.star.radius)
            star.position = CGPoint(x: CGFloat.random(in: background.frame.minX ... background.frame.maxX), y: CGFloat.random(in: background.frame.minY ... background.frame.maxY))
            star.setup()
            addChild(star)
        }

        // Shooting Star
        shootingStars.forEach({ addChild($0) })
        self.setupShootingStar()
        Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { [weak self] _ in
            self?.setupShootingStar()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupShootingStar() {
        let firstCoordinates: [(initial: CGPoint, final: (CGPoint))] = [
            (CGPoint(x: background.frame.minX, y: background.frame.minY), (CGPoint(x: background.frame.maxX, y: background.frame.maxY))),
            (CGPoint(x: background.frame.minX, y: background.frame.maxY), (CGPoint(x: background.frame.maxX, y: background.frame.minY))),
            (CGPoint(x: background.frame.minX, y: background.frame.midY), (CGPoint(x: background.frame.maxX, y: background.frame.midY))),
            (CGPoint(x: background.frame.minX, y: background.frame.midY), (CGPoint(x: background.frame.maxX, y: background.frame.maxY))),
            (CGPoint(x: background.frame.minX, y: background.frame.midY), (CGPoint(x: background.frame.maxX, y: background.frame.minY))),
            (CGPoint(x: background.frame.minX + (background.frame.maxX - background.frame.minX) * 0.3, y: background.frame.maxY), (CGPoint(x: background.frame.maxX, y: background.frame.minY))),
            (CGPoint(x: background.frame.minX + (background.frame.maxX - background.frame.minX) * 0.3, y: background.frame.minY), (CGPoint(x: background.frame.maxX, y: background.frame.maxY)))
            ]
        let secondCoordinates: [(initial: CGPoint, final: (CGPoint))] = [
            (CGPoint(x: background.frame.maxX, y: background.frame.minY), (CGPoint(x: background.frame.minX, y: background.frame.maxY))),
            (CGPoint(x: background.frame.maxX, y: background.frame.maxY), (CGPoint(x: background.frame.minX, y: background.frame.minY))),
            (CGPoint(x: background.frame.maxX, y: background.frame.midY), (CGPoint(x: background.frame.minX, y: background.frame.minY))),
            (CGPoint(x: background.frame.maxX, y: background.frame.midY), (CGPoint(x: background.frame.minX, y: background.frame.maxY)))
        ]

        for index in 0 ..< shootingStars.count {
            let shootingStar = shootingStars[index]
            shootingStar.alpha = 1
            let coordinate = index.isMultiple(of: 2) ? secondCoordinates.randomElement()!: firstCoordinates.randomElement()!
            shootingStar.position = coordinate.initial
            let moveAction = SKAction.move(to: coordinate.final, duration: 5.0)
            let run = SKAction.run {
                shootingStar.lastPosition = nil
            }
            let fadeOut = SKAction.fadeOut(withDuration: 1.5)
            let sequence = SKAction.sequence([moveAction, fadeOut, run])
            shootingStar.run(sequence)
        }
    }

    func update(_ currentTime: TimeInterval) {
        shootingStars.forEach { shootingStar in
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
}
