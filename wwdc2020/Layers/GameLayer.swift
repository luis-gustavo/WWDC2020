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
    let backgroundFrameForAsteroids: CGRect
    let sun: SunNode
    var planets = [Planet]()
    var shortStartDelay: TimeInterval = 1.0
    var nodeAngularDistance: [CGFloat] = [0, 0, 0, 0, 0, 0, 0, 0]
    var blackHoles = [BlackHoleNode]()
    var asteroids = [AsteroidNode]()
    var velocity = CGPoint.zero
    var timeVariation: TimeInterval = 0
    var lastCallToUpdate: TimeInterval = 0
    var lastTouchLocation: CGPoint?
    let movePointsPerSecond: CGFloat = 600.0
    var isTouching = false

    // MARK: - Inits
    init(size: CGSize, backgroundFrame: CGRect, backgroundFrameForAsteroids: CGRect) {

        // Class properties setup
        self.size = size
        self.backgroundFrame = backgroundFrame
        self.backgroundFrameForAsteroids = backgroundFrameForAsteroids

        // Sun
        self.sun = SunNode()
        sun.position = CGPoint(x: size.width/2, y: size.height/2)
        self.sun.setup()

        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            sun.constraints = [
                .positionX(SKRange(lowerLimit: backgroundFrameForAsteroids.minX + sun.size.width + 20)),
                .positionX(SKRange(upperLimit: backgroundFrameForAsteroids.maxX - sun.size.width - 20)),
                .positionY(SKRange(upperLimit: backgroundFrameForAsteroids.maxY - sun.size.height - 10)),
                .positionY(SKRange(lowerLimit: backgroundFrameForAsteroids.minY + sun.size.height + 10))
            ]
        default:
            sun.constraints = [
                .positionX(SKRange(lowerLimit: backgroundFrame.minX + sun.size.width / 2)),
                .positionX(SKRange(upperLimit: backgroundFrame.maxX - sun.size.width / 2)),
                .positionY(SKRange(upperLimit: backgroundFrame.maxY - sun.size.height / 2)),
                .positionY(SKRange(lowerLimit: backgroundFrame.minY + sun.size.height / 2))
            ]
        }
        sun.safeArea = CGRect(origin: sun.position, size: CGSize(width: 1000, height: 1000))
        sun.safeArea.origin = CGPoint(x: sun.position.x - sun.safeArea.size.width/2, y: sun.position.y - sun.safeArea.size.height/2)

        // Planets
        self.planets = [Mars(),
                        Saturn(),
                        Jupyter(),
                        Earth(),
                        Venus(),
                        Uranus(),
                        Neptune(),
                        Mercury()]

        // Super
        super.init()

        // Add child
        addChild(sun)
        planets.forEach({ planet in
            addChild(planet)
            planet.isActive = true
            sun.addOrbitPath(orbitRadius: planet.orbitRadius)
        })

        // Observers
        setupObservers()
    }

    @objc private func setupExplosion(_ notification: Notification) {
        // Planets
        let randomIndex = Int.random(in: 0...7)
        var count = 0
        for index in 0 ..< planets.count {
            let planet = planets[index]
            planet.isActive = false

            var newPosition: CGPoint?
            repeat {
                if index == randomIndex {
                    let pos = CGPoint(x: CGFloat.random(in: sun.safeArea.minX...sun.safeArea.maxX), y: CGFloat.random(in: sun.safeArea.minY...sun.safeArea.maxY))
                    let rect = CGRect(origin: CGPoint(x: pos.x - planet.size.width/2, y: pos.y - planet.size.height/2), size: planet.size)
                    newPosition = sun.frame.intersects(rect) ? nil : pos
                } else {
                    let x: CGFloat
                    let y: CGFloat
                    switch index {
                    case 0, 1:
                        x = CGFloat.random(in: backgroundFrame.minX...backgroundFrame.midX)
                        y = CGFloat.random(in: backgroundFrame.midY...backgroundFrame.maxY)
                    case 2, 3:
                        x = CGFloat.random(in: backgroundFrame.midX...backgroundFrame.maxX)
                        y = CGFloat.random(in: backgroundFrame.midY...backgroundFrame.maxY)
                    case 4, 5:
                        x = CGFloat.random(in: backgroundFrame.minX...backgroundFrame.midX)
                        y = CGFloat.random(in: backgroundFrame.minY...backgroundFrame.midY)
                    default:
                        x = CGFloat.random(in: backgroundFrame.midX...backgroundFrame.maxX)
                        y = CGFloat.random(in: backgroundFrame.minY...backgroundFrame.midY)
                    }
                    let pos = CGPoint(x: x, y: y)
                    newPosition = sun.safeArea.contains(pos) ? nil : pos
                }
            } while newPosition == nil
            planet.position = newPosition!
            planet.setup()
            sun.removeOrbitPath(orbitRadius: planet.orbitRadius)
            planet.alpha = 0
            planet.constraints = [
                .positionX(SKRange(lowerLimit: backgroundFrame.minX + planet.size.width / 2)),
                .positionX(SKRange(upperLimit: backgroundFrame.maxX - planet.size.width / 2)),
                .positionY(SKRange(upperLimit: backgroundFrame.maxY - planet.size.height / 2)),
                .positionY(SKRange(lowerLimit: backgroundFrame.minY + planet.size.height / 2))
            ]
            count += 1
        }
    }

    func setupSecondPhase() {
        // Black holes
        for index in 0 ..< blackHoles.count {
            let blackHole = blackHoles[index]

            blackHole.run(.fadeIn(withDuration: 1.0))
            blackHole.zPosition = -1
            var newPosition: CGPoint?
            repeat {
                let x: CGFloat
                let y: CGFloat
                switch index {
                case 0:
                    x = CGFloat.random(in: backgroundFrame.minX...backgroundFrame.midX)
                    y = CGFloat.random(in: backgroundFrame.midY...backgroundFrame.maxY)
                case 1:
                    x = CGFloat.random(in: backgroundFrame.midX...backgroundFrame.maxX)
                    y = CGFloat.random(in: backgroundFrame.midY...backgroundFrame.maxY)
                case 2:
                    x = CGFloat.random(in: backgroundFrame.minX...backgroundFrame.midX)
                    y = CGFloat.random(in: backgroundFrame.minY...backgroundFrame.midY)
                default:
                    x = CGFloat.random(in: backgroundFrame.midX...backgroundFrame.maxX)
                    y = CGFloat.random(in: backgroundFrame.minY...backgroundFrame.midY)
                }
                let pos = CGPoint(x: x, y: y)
                newPosition = sun.safeArea.contains(pos) ? nil : pos
            } while newPosition == nil
            blackHole.position = newPosition!
        }

        // Asteroids
        self.setupAsteroids()
        Timer.scheduledTimer(withTimeInterval: 10.0, repeats: false) { [weak self] _ in
            self?.setupAsteroids()
            Timer.scheduledTimer(withTimeInterval: 10.0, repeats: false) { _ in
                self?.setupAsteroids()
            }
        }
    }

    func setupFirstPhase() {
        // Planets
        planets.forEach({ $0.alpha = 1 })

        // Black holes
        self.blackHoles = [BlackHoleNode(),
                           BlackHoleNode(),
                           BlackHoleNode(),
                           BlackHoleNode()]


        blackHoles.forEach({ addChild($0) })

        // Black holes
        for index in 0 ..< blackHoles.count {
            let blackHole = blackHoles[index]
            blackHole.zPosition = -1
            var newPosition: CGPoint?
            repeat {
                let x: CGFloat
                let y: CGFloat
                switch index {
                case 0:
                    x = CGFloat.random(in: backgroundFrame.minX...backgroundFrame.midX)
                    y = CGFloat.random(in: backgroundFrame.midY...backgroundFrame.maxY)
                case 1:
                    x = CGFloat.random(in: backgroundFrame.midX...backgroundFrame.maxX)
                    y = CGFloat.random(in: backgroundFrame.midY...backgroundFrame.maxY)
                case 2:
                    x = CGFloat.random(in: backgroundFrame.minX...backgroundFrame.midX)
                    y = CGFloat.random(in: backgroundFrame.minY...backgroundFrame.midY)
                default:
                    x = CGFloat.random(in: backgroundFrame.midX...backgroundFrame.maxX)
                    y = CGFloat.random(in: backgroundFrame.minY...backgroundFrame.midY)
                }
                let pos = CGPoint(x: x, y: y)
                newPosition = sun.safeArea.contains(pos) ? nil : pos
            } while newPosition == nil
            blackHole.position = newPosition!
        }
    }

    func prepareForSecondPhase() {
        blackHoles.forEach({ $0.alpha = 0 })
        sun.position = CGPoint(x: size.width/2, y: size.height/2)
    }

    func setupAsteroids() {

        let _asteroids = [AsteroidNode(), AsteroidNode(), AsteroidNode(), AsteroidNode()]

        for index in 0 ..< _asteroids.count {
            let asteroid = _asteroids[index]

            guard !asteroid.removed else { continue }
            let initialPosition: CGPoint
            let finalPosition: CGPoint
            let offset: CGFloat = -50
            switch index {
            case 0: // left to right
                initialPosition = CGPoint(x: backgroundFrameForAsteroids.minX - 50, y: CGFloat.random(in: backgroundFrameForAsteroids.minY - offset ... backgroundFrameForAsteroids.maxY + offset))
                finalPosition = CGPoint(x: backgroundFrameForAsteroids.maxX + offset, y: CGFloat.random(in: backgroundFrameForAsteroids.minY - offset ... backgroundFrameForAsteroids.maxY + offset))
            case 1: // top to bottom
                initialPosition = CGPoint(x: CGFloat.random(in: backgroundFrameForAsteroids.minX - offset ... backgroundFrameForAsteroids.maxX + offset), y: backgroundFrameForAsteroids.maxY + offset)
                finalPosition = CGPoint(x: CGFloat.random(in: backgroundFrameForAsteroids.minX - offset ... backgroundFrameForAsteroids.maxX + offset), y: backgroundFrameForAsteroids.minY - offset)
            case 2: // right to left
                initialPosition = CGPoint(x: backgroundFrameForAsteroids.maxX + offset, y: CGFloat.random(in: backgroundFrameForAsteroids.minY - offset ... backgroundFrameForAsteroids.maxY + offset))
                finalPosition = CGPoint(x: backgroundFrameForAsteroids.minX - offset, y: CGFloat.random(in: backgroundFrameForAsteroids.minY - offset ... backgroundFrameForAsteroids.maxY + offset))
            default: // bottom to top
                initialPosition = CGPoint(x: CGFloat.random(in: backgroundFrameForAsteroids.minX - offset ... backgroundFrameForAsteroids.maxX + offset), y: backgroundFrameForAsteroids.minY - offset)
                finalPosition = CGPoint(x: CGFloat.random(in: backgroundFrameForAsteroids.minX - offset ... backgroundFrameForAsteroids.maxX + offset), y: backgroundFrameForAsteroids.maxY + offset)
            }

            addChild(asteroid)
            asteroid.position = initialPosition
            let moveAction = SKAction.move(to: finalPosition, duration: 20)
            asteroid.run(moveAction)
        }

        self.asteroids.append(contentsOf: _asteroids)
    }

    func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(setupExplosion(_:)), name: .explosionStarted, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: .explosionStarted, object: nil)
    }

    func removeUntakenPlanets() {
        for planet in planets {
            guard !planet.isActive else { continue }
            planet.removed = true
            planet.removeFromParent()
        }
    }

    func setupGameOver() {
        blackHoles.forEach({ $0.removeFromParent() })
        blackHoles = []
        asteroids.forEach({ $0.removeFromParent() })
        asteroids = []
        sun.position = CGPoint(x: size.width/2, y: size.height/2)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateTimeVariation(currentTime: TimeInterval) {
        if lastCallToUpdate > 0 {
            timeVariation = currentTime - lastCallToUpdate
        } else {
            timeVariation = 0
        }

        lastCallToUpdate = currentTime
    }


    // MARK: - Update
    func update(_ currentTime: TimeInterval) {
        updateTimeVariation(currentTime: currentTime)
        if isTouching, !GameManager.shared.inCustscene, !GameManager.shared.inIntro {
            moveSun(velocity: velocity)
        }
        movimentationFunction()

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
                    SoundManager.shared.playSound(.blackHole)
                    planet.removed = true
                    blackHole.suckPlanet(planet)
                    sun.removeOrbitPath(orbitRadius: planet.orbitRadius)
                    NotificationCenter.default.post(name: .planetCollidedWithBlackHole, object: nil, userInfo: ["text": "\(planet.name!) was absorbed by a black hole", "planet": planet.solarSystemPlanet])
                }
            }
        }

        for planet in planets {
            guard !planet.isActive, !planet.removed else { continue }
            if sun.intersects(planet) {
                SoundManager.shared.playSound(.planet)
                planet.isActive = true
                planet.constraints = []
                sun.addOrbitPath(orbitRadius: planet.orbitRadius)
                NotificationCenter.default.post(name: .planetCollected, object: nil, userInfo: ["text": "\(planet.name!) was rescued", "planet": planet.solarSystemPlanet])
            }
        }

        asteroids.forEach { asteroid in
            for index in 0 ..< planets.count {
                let planet = planets[index]
                guard !planet.removed, planet.isActive, !asteroid.removed else { continue }
                if asteroid.intersects(planet) {
                    SoundManager.shared.playSound(.explosion)
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

    func setVelocity(location: CGPoint) {
        let moveVector = CGPoint(x: (location.x - sun.position.x),
                                 y: (location.y - sun.position.y))

        let length = CGFloat(sqrt(pow(moveVector.x, 2) + pow(moveVector.y, 2)))

        let direction = CGPoint(x: (moveVector.x / length),
                                y: (moveVector.y / length))

        velocity = CGPoint(x: direction.x * movePointsPerSecond,
                           y: direction.y * movePointsPerSecond)
    }

    func moveSun(velocity: CGPoint) {

        let amountToMove = CGPoint(x: velocity.x * CGFloat(timeVariation),
                                   y: velocity.y * CGFloat(timeVariation))

        sun.position = CGPoint(
            x: sun.position.x + amountToMove.x,
            y: sun.position.y + amountToMove.y)
    }

    func movimentationFunction() {
        if let lastTouchLocation = lastTouchLocation {
            let diff = CGPoint(x:lastTouchLocation.x - sun.position.x,
                               y: lastTouchLocation.y - sun.position.y)
            let length = CGFloat(sqrt(pow(Double(diff.x), 2.0) + pow(Double(diff.y), 2.0)))
            if length <= movePointsPerSecond * CGFloat(timeVariation) {
                sun.position = lastTouchLocation
                velocity = CGPoint.zero
            } else {

            }
        }
    }
}

extension GameLayer {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        isTouching = true
        if let touch = touches.first {
            let touchLocation = touch.location(in: self)
            setVelocity(location: touchLocation)
            if touchLocation != lastTouchLocation {
                lastTouchLocation = touchLocation
            }
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchLocation = touch.location(in: self)
            setVelocity(location: touchLocation)
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isTouching = false
    }

}
