//
//  GameLayer.swift
//  wwdc2020
//
//  Created by Luis Gustavo Avelino de Lima Jacinto on 08/05/20.
//  Copyright © 2020 Luis Gustavo Avelino de Lima Jacinto. All rights reserved.
//

import SpriteKit
import AVFoundation

final class GameLayer: SKNode {

    // MARK: - Properties
    let size: CGSize
    let backgroundFrame: CGRect
    let sun: SunNode
    var shootingStars = [ShootingStarNode]()
    var planets = [Planet]()
    var shortStartDelay: TimeInterval = 1.0
    var nodeAngularDistance: [CGFloat] = [0, 0, 0, 0, 0, 0, 0, 0]
    var blackHoles = [BlackHoleNode]()

    // MARK: - Inits
    init(size: CGSize, backgroundFrame: CGRect) {

        // Class properties setup
        self.size = size
        self.backgroundFrame = backgroundFrame

        // Sun
        self.sun = SunNode(circleOfRadius: PlanetsType.sun.radius)
        sun.position = CGPoint(x: size.width/2, y: size.height/2)
        self.sun.setup()

        // Black holes
        self.blackHoles = [BlackHoleNode(circleOfRadius: 10),
                           BlackHoleNode(circleOfRadius: 10),
                           BlackHoleNode(circleOfRadius: 10)]

        // Planets
        self.planets = [Mars(circleOfRadius: PlanetsType.planet.radius),
                        Saturn(circleOfRadius: PlanetsType.planet.radius),
                        Jupyter(circleOfRadius: PlanetsType.planet.radius),
                        Earth(circleOfRadius: PlanetsType.planet.radius),
                        Venus(circleOfRadius: PlanetsType.planet.radius),
                        Uranus(circleOfRadius: PlanetsType.planet.radius),
                        Neptune(circleOfRadius: PlanetsType.planet.radius),
                        Mercury(circleOfRadius: PlanetsType.planet.radius)]

        // Shooting Stars
        self.shootingStars = [ShootingStarNode(circleOfRadius: PlanetsType.shootingStar.radius),                   ShootingStarNode(circleOfRadius: PlanetsType.shootingStar.radius)]
        shootingStars.forEach({ shootingStar in
            shootingStar.setup()
        })

        // Super
        super.init()

        // Add child
        addChild(sun)
        planets.forEach({ addChild($0) })
//        blackHoles.forEach({ addChild($0) })

        // Black holes
//        self.blackHoles.forEach { blackHole in
//            blackHole.position = CGPoint(x: CGFloat.random(in: backgroundFrame.minX...backgroundFrame.maxX), y: CGFloat.random(in: backgroundFrame.minY...backgroundFrame.maxY))
//            blackHole.fillColor = .red
//        }

        // Planets
        self.planets.forEach { planet in
            planet.position = CGPoint(x: CGFloat.random(in: backgroundFrame.minX...backgroundFrame.maxX), y: CGFloat.random(in: backgroundFrame.minY...backgroundFrame.maxY))
            planet.setup()
        }

        // Stars
        for _ in 1...50 {
            let star = StarNode(circleOfRadius: PlanetsType.star.radius)
            star.position = CGPoint(x: CGFloat.random(in: backgroundFrame.minX ... backgroundFrame.maxX), y: CGFloat.random(in: backgroundFrame.minY ... backgroundFrame.maxY))
            star.setup()
            addChild(star)
        }

        // Observers
        setupObservers()

        // Shooting Star
        shootingStars.forEach({ addChild($0) })
        self.setupShootingStar()
        Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { [weak self] _ in
            self?.setupShootingStar()
        }
    }

    func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(sunPositionDidChange(_:)), name: .sunPositionChanged, object: nil)
    }

    func setupShootingStar() {
        let firstCoordinates: [(initial: CGPoint, final: (CGPoint))] = [
            (CGPoint(x: backgroundFrame.minX, y: backgroundFrame.minY), (CGPoint(x: backgroundFrame.maxX, y: backgroundFrame.maxY))),
            (CGPoint(x: backgroundFrame.minX, y: backgroundFrame.maxY), (CGPoint(x: backgroundFrame.maxX, y: backgroundFrame.minY))),
            (CGPoint(x: backgroundFrame.minX, y: backgroundFrame.midY), (CGPoint(x: backgroundFrame.maxX, y: backgroundFrame.midY))),
            (CGPoint(x: backgroundFrame.minX, y: backgroundFrame.midY), (CGPoint(x: backgroundFrame.maxX, y: backgroundFrame.maxY))),
            (CGPoint(x: backgroundFrame.minX, y: backgroundFrame.midY), (CGPoint(x: backgroundFrame.maxX, y: backgroundFrame.minY))),
            (CGPoint(x: backgroundFrame.minX + (backgroundFrame.maxX - backgroundFrame.minX) * 0.3, y: backgroundFrame.maxY), (CGPoint(x: backgroundFrame.maxX, y: backgroundFrame.minY))),
            (CGPoint(x: backgroundFrame.minX + (backgroundFrame.maxX - backgroundFrame.minX) * 0.3, y: backgroundFrame.minY), (CGPoint(x: backgroundFrame.maxX, y: backgroundFrame.maxY)))
            ]
        let secondCoordinates: [(initial: CGPoint, final: (CGPoint))] = [
            (CGPoint(x: backgroundFrame.maxX, y: backgroundFrame.minY), (CGPoint(x: backgroundFrame.minX, y: backgroundFrame.maxY))),
            (CGPoint(x: backgroundFrame.maxX, y: backgroundFrame.maxY), (CGPoint(x: backgroundFrame.minX, y: backgroundFrame.minY))),
            (CGPoint(x: backgroundFrame.maxX, y: backgroundFrame.midY), (CGPoint(x: backgroundFrame.minX, y: backgroundFrame.minY))),
            (CGPoint(x: backgroundFrame.maxX, y: backgroundFrame.midY), (CGPoint(x: backgroundFrame.minX, y: backgroundFrame.maxY)))
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

    @objc private func sunPositionDidChange(_ notification: Notification) {
        guard let position = notification.userInfo?["position"] as? CGPoint else {
            fatalError("There must exist a value of type \(type(of: CGPoint.self))")
        }

        for planet in planets {
            guard !planet.isActive, !planet.removed else { continue }
            let planetPosition = convert(planet.position, to: self)
            let sunPosition = convert(position, to: self)
            let distance = CGPoint.distanceBetweenPoints(planetPosition, sunPosition)
            if sun.intersects(planet) {
                planet.isActive = true
            }
//            if distance <= 100 {
//                planet.isActive = true
//            }
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: .sunPositionChanged, object: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Update
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

        for index in 0 ..< planets.count {
            let planet = planets[index]
            guard planet.isActive, !planet.removed else { continue }
            let dt: CGFloat = 1.0/60.0
            let period: CGFloat = planet.period
            let orbitPosition = convert(sun.position, to: self)
            let orbitRadius = planet.orbitRadius
            var node2AngularDistance = nodeAngularDistance[index]

            let normal = CGVector(dx:orbitPosition.x + CGFloat(cos(node2AngularDistance))*orbitRadius.x ,dy:orbitPosition.y + CGFloat(sin(node2AngularDistance))*orbitRadius.y);

            node2AngularDistance += (CGFloat.pi*2.0)/period*dt;

            if abs(node2AngularDistance) > CGFloat.pi*2 {
                node2AngularDistance = 0
            }
            let planetPosition = convert(planet.position, to: self)
            planet.physicsBody!.velocity = CGVector(dx:(normal.dx-planetPosition.x)/dt ,dy:(normal.dy-planetPosition.y)/dt)

            nodeAngularDistance[index] = node2AngularDistance
        }

//        blackHoles.forEach { (blackHole) in
//            for index in 0 ..< planets.count {
//                let planet = planets[index]
//                guard !planet.removed else { continue }
//                if blackHole.intersects(planet) {
//                    planet.removed = true
//                    blackHole.suckPlanet(planet)
//                }
//            }
//        }

    }
}

extension GameLayer {
    func moveSun(velocity: CGPoint) {
        sun.position.x += velocity.x
        sun.position.y += velocity.y
    }
}
