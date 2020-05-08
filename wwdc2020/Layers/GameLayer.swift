//
//  GameLayer.swift
//  wwdc2020
//
//  Created by Luis Gustavo Avelino de Lima Jacinto on 08/05/20.
//  Copyright © 2020 Luis Gustavo Avelino de Lima Jacinto. All rights reserved.
//

import SpriteKit

final class GameLayer: SKNode {

    // MARK: - Properties
    let size: CGSize
    let sun: SunNode
    let stars: [StarNode]

    // MARK: - Inits
    init(size: CGSize) {
        self.size = size
        self.sun = SunNode(circleOfRadius: PlanetsType.sun.radius)
        self.sun.setup()
        self.stars = [StarNode(circleOfRadius: PlanetsType.star.radius),
                      StarNode(circleOfRadius: PlanetsType.star.radius),
                      StarNode(circleOfRadius: PlanetsType.star.radius)]
        stars.forEach({ $0.setup() })

        super.init()

        sun.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(sun)
        stars.forEach({ $0.position = CGPoint(x: CGFloat.random(in: 0...size.width), y: CGFloat.random(in: 0...size.height)) })
        stars.forEach({ addChild($0) })
        stars.forEach({ $0.constraints = [SKConstraint.distance(SKRange(lowerLimit: 30), to: sun)] })
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Update
    func update(_ currentTime: TimeInterval) {
        stars.forEach({ star in
            if star.isActive {
                if let lastPosition = star.lastPosition {
                    let lastPositionInSelf = convert(lastPosition, to: self)
                    let positionInSelf = convert(star.position, to: self)
                    let path = CGMutablePath()
                    path.move(to: lastPositionInSelf)
                    path.addLine(to: positionInSelf)
                    let lineSegment = SKShapeNode(path: path)
                    lineSegment.strokeColor = star.fillColor
                    lineSegment.fillColor = star.fillColor
                    addChild(lineSegment)
                    let fadeOut = SKAction.fadeOut(withDuration: star.lineTrailDuration)
                    let remove = SKAction.removeFromParent()
                    let sequence = SKAction.sequence([fadeOut, remove])
                    lineSegment.run(sequence)
                }
                star.lastPosition = star.position
            }
        })
    }
}

extension GameLayer {
    func moveSun(analogicData: AnalogData) {
        sun.position.x += (analogicData.velocity.x)
        sun.position.y += (analogicData.velocity.y)
    }
}
