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
    let gameOverLayer: GameOverLayer
    let backgroundFrame: CGRect
    
    // MARK: - Inits
    override init(size: CGSize) {
        self.hudLayer = HudLayer(size: size)
        self.gameOverLayer = GameOverLayer(size: size)
        self.backgroundLayer = BackgroundLayer(size: size)
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            self.backgroundFrame = CGRect(origin: CGPoint(x: backgroundLayer.background.frame.origin.x + backgroundLayer.background.size.width * 0.1,
                            y: backgroundLayer.background.frame.origin.y + backgroundLayer.background.size.height * 0.1),
            size: CGSize(width: backgroundLayer.background.size.width * 0.8,
                         height: backgroundLayer.background.size.height * 0.8))
        default:
            self.backgroundFrame = CGRect(origin: CGPoint(x: backgroundLayer.background.frame.origin.x + backgroundLayer.background.size.width * 0.05,
                            y: backgroundLayer.background.frame.origin.y + backgroundLayer.background.size.height * 0.05),
            size: CGSize(width: backgroundLayer.background.size.width * 0.9,
                         height: backgroundLayer.background.size.height * 0.9))
        }

        self.gameLayer = GameLayer(size: size, backgroundFrame: self.backgroundFrame)

        super.init(size: size)



        // Setup
        physicsWorld.gravity = .zero

        // Add child
        addChild(gameLayer)
        addChild(backgroundLayer)
        backgroundColor = .black

        // Camera
        setupCamera()
        self.camera?.addChild(hudLayer)

        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            camera?.xScale = 1.7
            camera?.yScale = 1.7
        default:
            camera?.xScale = 1.3
            camera?.yScale = 1.3
        }

        // Managers
        _ = GameManager.shared

        // Background layer
        backgroundLayer.zPosition = -2

        // Hud layer
        hudLayer.delegate = self

        // Observers
        setupObservers()
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: .explosionEnded, object: nil)
        NotificationCenter.default.removeObserver(self, name: .collectedAllPlanets, object: nil)
        NotificationCenter.default.removeObserver(self, name: .timeEnded, object: nil)
        NotificationCenter.default.removeObserver(self, name: .noMorePlanetsLeft, object: nil)
    }

    func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(setupDialogue(_:)), name: .explosionEnded, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setupSecondDialogue(_:)), name: .collectedAllPlanets, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(timeEnded(_:)), name: .timeEnded, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(noMorePlanetsLeft(_:)), name: .noMorePlanetsLeft, object: nil)
    }

    @objc private func timeEnded(_ notification: Notification) {

        if GameManager.shared.isInFirstPart {
            hudLayer.planetsLost = hudLayer.planetsAmount - hudLayer.planetsCollected
            gameLayer.removeUntakenPlanets()
            setupSecondDialogue(Notification(name: .planetCollected))
        } else {
            // Won the game
            gameLayer.setupGameOver()
            showGameOverLayer()
        }
    }

    func showGameOverLayer() {
        hudLayer.removeFromParent()
        camera?.addChild(gameOverLayer)
        gameOverLayer.setupGameOverLayer(planetsSaved: hudLayer.planetsCollected, planetsLost: hudLayer.planetsLost)
    }

    @objc private func noMorePlanetsLeft(_ notification: Notification) {
        gameLayer.setupGameOver()
        showGameOverLayer()
    }

    @objc private func setupSecondDialogue(_ notification: Notification) {

        GameManager.shared.isInFirstPart = false
        gameLayer.prepareForSecondPhase()
        hudLayer.hidePlanetsLabel()
        GameManager.shared.inCustscene = true
        hudLayer.joystick.touchesEnded(Set<UITouch>(), with: nil)
        hudLayer.stopTimer()
        hudLayer.startDialogue(.climax(hudLayer.planetsLost))
        hudLayer.joystick.run(.fadeOut(withDuration: 1.0))
    }

    @objc private func setupDialogue(_ notification: Notification) {
        hudLayer.zPosition = 0
        hudLayer.startDialogue(.intro)
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
        if gameOverLayer.parent != nil {
            gameOverLayer.touchesBegan(touches, with: event)
        }
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
