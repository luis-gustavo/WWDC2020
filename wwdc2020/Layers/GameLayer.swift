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
    var planets = [Planet]()
    var shortStartDelay: TimeInterval = 1.0
    var nodeAngularDistance: [CGFloat] = [0, 0, 0, 0, 0, 0, 0, 0]
    var blackHoles = [BlackHoleNode]()
    var asteroids = [AsteroidNode]()

    // MARK: - Inits
    init(size: CGSize, backgroundFrame: CGRect) {

        // Class properties setup
        self.size = size
        self.backgroundFrame = backgroundFrame

        // Sun
        self.sun = SunNode()
        sun.position = CGPoint(x: size.width/2, y: size.height/2)
        self.sun.setup()
        sun.constraints = [
            .positionX(SKRange(lowerLimit: backgroundFrame.minX + sun.size.width / 2)),
            .positionX(SKRange(upperLimit: backgroundFrame.maxX - sun.size.width / 2)),
            .positionY(SKRange(upperLimit: backgroundFrame.maxY - sun.size.height / 2)),
            .positionY(SKRange(lowerLimit: backgroundFrame.minY + sun.size.height / 2))
        ]

        // Black holes
        self.blackHoles = [BlackHoleNode(),
                           BlackHoleNode(),
                           BlackHoleNode()]

        // Planets
        self.planets = [Mars(),
                        Saturn(),
                        Jupyter(),
                        Earth(),
                        Venus(),
                        Uranus(),
                        Neptune(),
                        Mercury()]

        // Asteroid
        self.asteroids = [AsteroidNode(), AsteroidNode(), AsteroidNode(), AsteroidNode(), AsteroidNode()]

        // Super
        super.init()

        // Add child
        addChild(sun)
        planets.forEach({ addChild($0) })
        blackHoles.forEach({ addChild($0) })
        asteroids.forEach({ addChild($0) })

        // Black holes
        self.blackHoles.forEach { blackHole in
            blackHole.zPosition = -1
            blackHole.position = CGPoint(x: CGFloat.random(in: backgroundFrame.minX...backgroundFrame.maxX), y: CGFloat.random(in: backgroundFrame.minY...backgroundFrame.maxY))
        }

        // Planets
        self.planets.forEach { planet in
            planet.position = CGPoint(x: CGFloat.random(in: backgroundFrame.minX...backgroundFrame.maxX), y: CGFloat.random(in: backgroundFrame.minY...backgroundFrame.maxY))
            planet.setup()
        }

        // Observers
        setupObservers()

        // Asteroid
        self.setupAsteroids()
        Timer.scheduledTimer(withTimeInterval: 30.0, repeats: true) { [weak self] _ in
            self?.setupAsteroids()
        }
    }

    func setupAsteroids() {
        for asteroid in asteroids {
            guard !asteroid.removed else { continue }
            let random = Int.random(in: 1...4)
            let initialPosition: CGPoint
            let finalPosition: CGPoint
            switch random {
            case 1: // left to right
                initialPosition = CGPoint(x: backgroundFrame.minX - 20, y: CGFloat.random(in: backgroundFrame.minY - 20 ... backgroundFrame.maxY + 20))
                finalPosition = CGPoint(x: backgroundFrame.maxX + 20, y: CGFloat.random(in: backgroundFrame.minY - 20 ... backgroundFrame.maxY + 20))
            case 2: // top to bottom
                initialPosition = CGPoint(x: CGFloat.random(in: backgroundFrame.minX - 20 ... backgroundFrame.maxX + 20), y: backgroundFrame.maxY + 20)
                finalPosition = CGPoint(x: CGFloat.random(in: backgroundFrame.minX - 20 ... backgroundFrame.maxX + 20), y: backgroundFrame.minY - 20)
            case 3: // right to left
                initialPosition = CGPoint(x: backgroundFrame.maxX + 20, y: CGFloat.random(in: backgroundFrame.minY - 20 ... backgroundFrame.maxY + 20))
                finalPosition = CGPoint(x: backgroundFrame.minX - 20, y: CGFloat.random(in: backgroundFrame.minY - 20 ... backgroundFrame.maxY + 20))
            default: // bottom to top
                initialPosition = CGPoint(x: CGFloat.random(in: backgroundFrame.minX - 20 ... backgroundFrame.maxX + 20), y: backgroundFrame.minY - 20)
                finalPosition = CGPoint(x: CGFloat.random(in: backgroundFrame.minX - 20 ... backgroundFrame.maxX + 20), y: backgroundFrame.maxY + 20)
            }

            asteroid.position = initialPosition
            let moveAction = SKAction.move(to: finalPosition, duration: 25.0)
            asteroid.run(moveAction)
        }
    }

    func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(sunPositionDidChange(_:)), name: .sunPositionChanged, object: nil)
    }

    @objc private func sunPositionDidChange(_ notification: Notification) {
        for planet in planets {
            guard !planet.isActive, !planet.removed else { continue }
            if sun.intersects(planet) {
                planet.isActive = true
                sun.addOrbitPath(orbitRadius: planet.orbitRadius)
                NotificationCenter.default.post(name: .planetCollected, object: nil, userInfo: ["text": "\(planet.name!) was rescued", "planet": planet.solarSystemPlanet])
            }
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

        blackHoles.forEach { blackHole in
            for index in 0 ..< planets.count {
                let planet = planets[index]
                guard !planet.removed, planet.isActive else { continue }
                if blackHole.intersects(planet) {
                    planet.removed = true
                    blackHole.suckPlanet(planet)
                    sun.removeOrbitPath(orbitRadius: planet.orbitRadius)
                    NotificationCenter.default.post(name: .planetCollidedWithBlackHole, object: nil, userInfo: ["text": "\(planet.name!) was absorbed by a black hole", "planet": planet.solarSystemPlanet])
                }
            }
        }

        asteroids.forEach { asteroid in
            for index in 0 ..< planets.count {
                let planet = planets[index]
                guard !planet.removed, planet.isActive, !asteroid.removed else { continue }
                if asteroid.intersects(planet) {
                    planet.removed = true
                    sun.removeOrbitPath(orbitRadius: planet.orbitRadius)
                    planet.removeFromParent()
                    asteroid.explosion()
                    asteroid.removed = true
                    NotificationCenter.default.post(name: .planetCollidedWithBlackHole, object: nil, userInfo: ["text": "\(planet.name!) was destroyed by an asteroid", "planet": planet.solarSystemPlanet])
                }
            }
        }

    }
}

extension GameLayer {
    func moveSun(velocity: CGPoint) {
        sun.position.x += velocity.x
        sun.position.y += velocity.y
    }
}
