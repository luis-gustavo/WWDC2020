//
//  GameScene.swift
//  wwdc2020
//
//  Created by Luis Gustavo Avelino de Lima Jacinto on 08/05/20.
//  Copyright © 2020 Luis Gustavo Avelino de Lima Jacinto. All rights reserved.
//

import SpriteKit
import GameplayKit

final class GameScene: SKScene {

    // MARK: - Properties
    let gameLayer: GameLayer
    let hudLayer: HudLayer
    let backgroundLayer: BackgroundLayer
    private var planets = [(SolarSystemPlanet, CGFloat)]()
    
    // MARK: - Inits
    override init(size: CGSize) {
        self.hudLayer = HudLayer(size: size)
        self.backgroundLayer = BackgroundLayer(size: size)
        self.gameLayer = GameLayer(size: size, backgroundFrame: self.backgroundLayer.background.frame)

        super.init(size: size)

        hudLayer.delegate = self
        physicsWorld.gravity = .zero
        addChild(gameLayer)
        addChild(backgroundLayer)

        backgroundLayer.zPosition = -2

        setupCamera()
        self.camera?.addChild(hudLayer)

        SoundManager.shared.start(with: 1.0)

        _ = GameManager.shared

        hudLayer.startTimer()

        NotificationCenter.default.addObserver(self, selector: #selector(zoomInCamera(_:)), name: .planetCollected, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(zoomOutCamera(_:)), name: .planetCollidedWithBlackHole, object: nil)
    }

    private func mapPlanetToScale(_ planet: SolarSystemPlanet) -> CGFloat {
        switch planet {
            case .mars: return 1.05
            case .earth: return 1.15
            case .venus: return 1.1
            case .mercury: return 1.0
            case .jupyter: return 1.35
            case .saturn: return 1.3
            case .uranus: return 1.25
            case .neptune: return 1.2
        }
    }

    @objc private func zoomOutCamera(_ notification: Notification) {
        guard let planet = notification.userInfo?["planet"] as? SolarSystemPlanet else {
            fatalError("The parameter must exist")
        }
        planets.removeAll(where: { $0.0 == planet })

        if planets.isEmpty {
            let scaleAction = SKAction.scale(to: 1.0, duration: 1.0)
            camera?.run(scaleAction)
            return
        }

        let currentScale = camera!.xScale
        if let biggestScale = planets.map({ $0.1 }).max(), biggestScale != currentScale {
            let scaleAction = SKAction.scale(to: biggestScale, duration: 1.0)
            camera?.run(scaleAction)
        }
    }

    @objc private func zoomInCamera(_ notification: Notification) {
        guard let planet = notification.userInfo?["planet"] as? SolarSystemPlanet else {
            fatalError("The parameter must exist")
        }
        planets.append((planet, mapPlanetToScale(planet)))

        let currentScale = camera!.xScale
        if let biggestScale = planets.map({ $0.1 }).max(), biggestScale > currentScale {
            let scaleAction = SKAction.scale(to: biggestScale, duration: 1.0)
            camera?.run(scaleAction)
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: .planetCollected, object: nil)
        NotificationCenter.default.removeObserver(self, name: .planetCollidedWithBlackHole, object: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Update
    override func update(_ currentTime: TimeInterval) {
        gameLayer.update(currentTime)
        backgroundLayer.update(currentTime)
    }

    override func didMove(to view: SKView) {
        super.didMove(to: view)
    }
}

extension GameScene {
    func setupCamera() {
        let camera = SKCameraNode()
        camera.constraints =
            [
            .distance(.init(upperLimit: 10), to: gameLayer.sun),
            .positionX(SKRange(lowerLimit: backgroundLayer.background.frame.minX + size.width/2 - 10)),
            .positionX(SKRange(upperLimit: backgroundLayer.background.frame.maxX - size.width/2 + 10)),
            .positionY(SKRange(upperLimit: backgroundLayer.background.frame.maxY - size.height/2 + 10)),
            .positionY(SKRange(lowerLimit: backgroundLayer.background.frame.minY + size.height/2 - 10))
        ]
        addChild(camera)
        self.camera = camera
    }
}

extension GameScene: HudLayerDelegate {
    func joystickMoved(_ velocity: CGPoint) {
        self.gameLayer.moveSun(velocity: velocity)
    }
}
