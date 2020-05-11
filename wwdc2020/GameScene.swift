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

        backgroundLayer.zPosition = -1

        setupCamera()
        self.camera?.addChild(hudLayer)

        SoundManager.shared.start()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Update
    override func update(_ currentTime: TimeInterval) {
        gameLayer.update(currentTime)
    }

    override func didMove(to view: SKView) {
        super.didMove(to: view)
    }
}

extension GameScene {
    func setupCamera() {
        let camera = SKCameraNode()
        camera.constraints = [.distance(.init(upperLimit: 10), to: gameLayer.sun)]
        addChild(camera)
        self.camera = camera
    }
}

extension GameScene: HudLayerDelegate {
    func joystickMoved(_ velocity: CGPoint) {
        self.gameLayer.moveSun(velocity: velocity)
    }
}
