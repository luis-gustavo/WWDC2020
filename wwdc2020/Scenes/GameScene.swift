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
//    private var planets = [(SolarSystemPlanet, CGFloat)]()
    let backgroundFrame: CGRect
    
    // MARK: - Inits
    override init(size: CGSize) {
        self.hudLayer = HudLayer(size: size)
        self.backgroundLayer = BackgroundLayer(size: size)
        self.backgroundFrame = CGRect(origin: CGPoint(x: backgroundLayer.background.frame.origin.x + backgroundLayer.background.size.width * 0.05,
                                                      y: backgroundLayer.background.frame.origin.y + backgroundLayer.background.size.height * 0.05),
                                      size: CGSize(width: backgroundLayer.background.size.width * 0.9,
                                                   height: backgroundLayer.background.size.height * 0.9))
        self.gameLayer = GameLayer(size: size, backgroundFrame: self.backgroundFrame)

        super.init(size: size)

        // Setup
        physicsWorld.gravity = .zero

        // Add child
        addChild(gameLayer)
        addChild(backgroundLayer)

        // Camera
        setupCamera()
        self.camera?.addChild(hudLayer)
        camera?.xScale = 1.2
        camera?.yScale = 1.2

        // Managers
//        SoundManager.shared.start(with: 1.0)
        _ = GameManager.shared

        // Background layer
        backgroundLayer.zPosition = -2

        // Hud layer
        hudLayer.delegate = self
//        hudLayer.startTimer()


        // Observers
        setupObservers()
    }

    func setupObservers() {
//        NotificationCenter.default.addObserver(self, selector: #selector(zoomInCamera(_:)), name: .planetCollected, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(zoomOutCamera(_:)), name: .planetCollidedWithBlackHole, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setupDialogue(_:)), name: .explosionEnded, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setupSecondDialogue(_:)), name: .collectedAllPlanets, object: nil)
    }

    @objc private func setupSecondDialogue(_ notification: Notification) {

        hudLayer.hidePlanetsLabel()
        GameManager.shared.inCustscene = true
        hudLayer.joystick.touchesEnded(Set<UITouch>(), with: nil)
        hudLayer.stopTimer()
        hudLayer.startDialogue(.climax)
        hudLayer.joystick.run(.fadeOut(withDuration: 1.0))
    }

    @objc private func setupDialogue(_ notification: Notification) {
        hudLayer.zPosition = 0
        hudLayer.startDialogue(.intro)
    }

//    private func mapPlanetToScale(_ planet: SolarSystemPlanet) -> CGFloat {
//        switch planet {
//            case .mars: return 1.05
//            case .earth: return 1.15
//            case .venus: return 1.1
//            case .mercury: return 1.0
//            case .jupyter: return 1.35
//            case .saturn: return 1.3
//            case .uranus: return 1.25
//            case .neptune: return 1.2
//        }
//    }

//    @objc private func zoomOutCamera(_ notification: Notification) {
//        return
//        guard let planet = notification.userInfo?["planet"] as? SolarSystemPlanet else {
//            fatalError("The parameter must exist")
//        }
//        planets.removeAll(where: { $0.0 == planet })
//
//        if planets.isEmpty {
//            let scaleAction = SKAction.scale(to: 1.0, duration: 1.0)
//            camera?.run(scaleAction)
//            return
//        }
//
//        let currentScale = camera!.xScale
//        if let biggestScale = planets.map({ $0.1 }).max(), biggestScale != currentScale {
//            let scaleAction = SKAction.scale(to: biggestScale, duration: 1.0)
//            camera?.run(scaleAction)
//        }
//    }
//
//    @objc private func zoomInCamera(_ notification: Notification) {
//        return
//        guard let planet = notification.userInfo?["planet"] as? SolarSystemPlanet else {
//            fatalError("The parameter must exist")
//        }
//        planets.append((planet, mapPlanetToScale(planet)))
//
//        let currentScale = camera!.xScale
//        if let biggestScale = planets.map({ $0.1 }).max(), biggestScale > currentScale {
//            let scaleAction = SKAction.scale(to: biggestScale, duration: 1.0)
//            camera?.run(scaleAction)
//        }
//    }

    deinit {
//        NotificationCenter.default.removeObserver(self, name: .planetCollected, object: nil)
//        NotificationCenter.default.removeObserver(self, name: .planetCollidedWithBlackHole, object: nil)
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
//        camera.constraints =
//            [
//            .distance(.init(upperLimit: 10), to: gameLayer.sun),
//            .positionX(SKRange(lowerLimit: backgroundLayer.background.frame.minX + size.width/2 - 10)),
//            .positionX(SKRange(upperLimit: backgroundLayer.background.frame.maxX - size.width/2 + 10)),
//            .positionY(SKRange(upperLimit: backgroundLayer.background.frame.maxY - size.height/2 + 10)),
//            .positionY(SKRange(lowerLimit: backgroundLayer.background.frame.minY + size.height/2 - 10))
//        ]
        camera.constraints =
            [
            .distance(.init(upperLimit: 10), to: gameLayer.sun),
            .positionX(SKRange(lowerLimit: backgroundFrame.minX + size.width/2 - 10)),
            .positionX(SKRange(upperLimit: backgroundFrame.maxX - size.width/2 + 10)),
            .positionY(SKRange(upperLimit: backgroundFrame.maxY - size.height/2 + 10)),
            .positionY(SKRange(lowerLimit: backgroundFrame.minY + size.height/2 - 10))
        ]
        addChild(camera)
        self.camera = camera
    }
}

extension GameScene {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        hudLayer.touchesBegan(touches, with: event)
    }
}

extension GameScene: HudLayerDelegate {
    func joystickMoved(_ velocity: CGPoint) {
        self.gameLayer.moveSun(velocity: velocity)
    }

    func startCutscene() {
        hudLayer.zPosition = 10
        hudLayer.flash()
    }

    func dialogueFinished(_ dialogue: DialogueScene) {
        switch dialogue {
        case .intro:
            hudLayer.showPlanetsLabel()
            gameLayer.setupFirstPhase()
            hudLayer.joystick.run(.fadeIn(withDuration: 1.0))
            hudLayer.startTimer()
            GameManager.shared.inCustscene = false
        case .climax:
            hudLayer.showPlanetsLabel()
            hudLayer.startTimer()
            gameLayer.setupSecondPhase()
            hudLayer.joystick.run(.fadeIn(withDuration: 1.0))
            GameManager.shared.inCustscene = false
        }
    }
}
