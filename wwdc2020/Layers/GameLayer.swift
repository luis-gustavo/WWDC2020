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
    let sun: SunNode
//    var shootingStars = [ShootingStarNode]()
    var shootingStar: ShootingStarNode
//    var planets = [PlanetNode]()
    let planet: PlanetNode
    var shortStartDelay: TimeInterval = 1.0
    var node2AngularDistance: CGFloat = 0
    var stars = [StarNode]()


    // MARK: - Inits
    init(size: CGSize) {
        self.size = size
        self.sun = SunNode(circleOfRadius: PlanetsType.sun.radius)
        self.sun.setup()

        self.planet = PlanetNode(circleOfRadius: PlanetsType.planet.radius)
        planet.setup(Test.shared.getNextSound())
        planet.position = CGPoint(x: CGFloat.random(in: 0...size.width), y: CGFloat.random(in: 0...size.height))
        planet.constraints = [SKConstraint.distance(SKRange(lowerLimit: 30), to: sun)]

        self.shootingStar = ShootingStarNode(circleOfRadius: PlanetsType.shootingStar.radius)
        self.shootingStar.setup()

        super.init()

        sun.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(sun)
        addChild(planet)

//        for _ in 1...4 {
//            let star = ShootingStarNode(circleOfRadius: PlanetsType.shootingStar.radius)
//            star.setup(Test.shared.getNextSound())
//            star.position = CGPoint(x: CGFloat.random(in: 0...size.width), y: CGFloat.random(in: 0...size.height))
//            star.constraints = [SKConstraint.distance(SKRange(lowerLimit: 30), to: sun)]
//            addChild(star)
//            shootingStars.append(star)
//        }

        for _ in 1...10 {
            let star = StarNode(circleOfRadius: PlanetsType.star.radius)
            star.position = CGPoint(x: CGFloat.random(in: 0...size.width), y: CGFloat.random(in: 0...size.height))
            addChild(star)
            stars.append(star)
        }


        NotificationCenter.default.addObserver(self, selector: #selector(sunPositionDidChange(_:)), name: .sunPositionChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(audioDidFinish(_:)), name: .audioDidFinish, object: nil)

        setupAudios()
        shootingStarA()
    }

    func shootingStarA() {
        let coordinates: [(initial: CGPoint, final: (CGPoint))] = [(CGPoint(x: 0, y: 0), (CGPoint(x: size.width, y: size.height)))]

        let coordinate = coordinates.randomElement()!
        shootingStar.position = coordinate.initial
        addChild(shootingStar)

        let moveAction = SKAction.move(to: coordinate.final, duration: 5.0)
        let run = SKAction.run { [weak self] in
            self?.shootingStar.position = coordinate.initial
        }
        let sequence = SKAction.sequence([moveAction, run])
        let repeatForever = SKAction.repeatForever(sequence)
        shootingStar.run(repeatForever)
    }

    func setupAudios(replay: Bool = false) {
        sun.player?.stop()
//        shootingStars.forEach({ $0.player?.stop() })
        planet.player?.stop()
//        planets.forEach({ $0.player?.stop() })

        sun.player?.currentTime = 0
//        shootingStars.forEach({ $0.player?.currentTime = 0 })
//        planets.forEach({ $0.player?.currentTime = 0 })
        planet.player?.currentTime = 0

        let time = sun.player!.deviceCurrentTime + shortStartDelay
        sun.player!.play(atTime: time)
//        shootingStars.forEach({ star in
//            star.player!.play(atTime: time)
//            if !replay {
//                star.player?.volume = 0
//            }
//        })
//        planets.forEach({ planet in
//            planet.player!.play(atTime: time)
//            if !replay {
//                planet.player?.volume = 0
//            }
//        })
        planet.player!.play(atTime: time)
    }

    @objc private func audioDidFinish(_ notification: Notification) {
        setupAudios(replay: true)
    }

    @objc private func sunPositionDidChange(_ notification: Notification) {
        guard let position = notification.userInfo?["position"] as? CGPoint else {
            fatalError("There must exist a value of type \(type(of: CGPoint.self))")
        }

//        shootingStars.forEach({ star in
//            guard !star.isActive else { return }
//            let starPosition = convert(star.position, to: self)
//            let sunPosition = convert(position, to: self)
//            let distance = CGPoint.distanceBetweenPoints(starPosition, sunPosition)
//            if distance <= 100 {
//                star.isActive = true
//            }
//        })

        stars.forEach({ star in
            guard !star.isActive else { return }
            let starPosition = convert(star.position, to: self)
            let sunPosition = convert(position, to: self)
            let distance = CGPoint.distanceBetweenPoints(starPosition, sunPosition)
            if distance <= 100 {
                star.isActive = true
            }
        })

//        planets.forEach({ planet in
//            guard !planet.isActive else { return }
//            let planetPosition = convert(planet.position, to: self)
//            let sunPosition = convert(position, to: self)
//            let distance = CGPoint.distanceBetweenPoints(planetPosition, sunPosition)
//            if distance <= 100 {
//                planet.isActive = true
//            }
//        })
        if !planet.isActive {
            let planetPosition = convert(planet.position, to: self)
            let sunPosition = convert(position, to: self)
            let distance = CGPoint.distanceBetweenPoints(planetPosition, sunPosition)
            if distance <= 100 {
                planet.isActive = true
            }
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: .sunPositionChanged, object: nil)
        NotificationCenter.default.removeObserver(self, name: .audioDidFinish, object: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Update
    func update(_ currentTime: TimeInterval) {
//        shootingStars.forEach({ star in
//            if shootingStar.isActive {
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
//            }
//        })

//        let dt: CGFloat = 1.0/60.0
//        let period: CGFloat = 3
//        let orbitPosition = convert(sun.position, to: self)
//        let orbitRadius = CGPoint(x: 50, y: 50)
//
//        let normal = CGVector(dx: orbitPosition.x + CGFloat(cos(self.node2AngularDistance))*orbitRadius.x, dy: orbitPosition.y + CGFloat(sin(self.node2AngularDistance))*orbitRadius.y)
//
//        if fabs(self.node2AngularDistance) > CGFloat(Float.pi*2) {
//            self.node2AngularDistance = 0
//        }
//        planet.physicsBody!.velocity = CGVector(dx:(normal.dx-planet.position.x)/dt ,dy:(normal.dy-planet.position.y)/dt)

        if planet.isActive {
            let dt: CGFloat = 1.0/60.0 //Delta Time
            let period: CGFloat = 3 //Number of seconds it takes to complete 1 orbit.
            let orbitPosition = convert(sun.position, to: self) //Point to orbit.
            let orbitRadius = CGPoint(x: 100, y: 150) //Radius of orbit.

            let normal = CGVector(dx:orbitPosition.x + CGFloat(cos(self.node2AngularDistance))*orbitRadius.x ,dy:orbitPosition.y + CGFloat(sin(self.node2AngularDistance))*orbitRadius.y);
            self.node2AngularDistance += (CGFloat(M_PI)*2.0)/period*dt;
            if (fabs(self.node2AngularDistance)>CGFloat(M_PI)*2)
            {
                self.node2AngularDistance = 0
            }
            let planetPosition = convert(planet.position, to: self)
            planet.physicsBody!.velocity = CGVector(dx:(normal.dx-planetPosition.x)/dt ,dy:(normal.dy-planetPosition.y)/dt);
        }

    }
}

extension GameLayer {
    func moveSun(velocity: CGPoint) {
        sun.position.x += velocity.x
        sun.position.y += velocity.y
    }
}
