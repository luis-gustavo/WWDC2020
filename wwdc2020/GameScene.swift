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
    let movableAnalogic: GMAnalogControl

    // MARK: - Inits
    override init(size: CGSize) {
        self.gameLayer = GameLayer(size: size)
        let analogicSize = CGSize(width: 80, height: 80)
        movableAnalogic = GMAnalogControl(analogSize: analogicSize, bigTexture: SKTexture(imageNamed: "arrow"), smallTexture: SKTexture(imageNamed: "arrow"))
        movableAnalogic.position = CGPoint(x: size.width * 0.1, y: size.height * 0.1)

        super.init(size: size)

        movableAnalogic.delegate = self
        physicsWorld.gravity = .zero
        addChild(gameLayer)
        addChild(movableAnalogic)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - DidMove
    override func didMove(to view: SKView) {
        super.didMove(to: view)
    }

    // MARK: - Update
    override func update(_ currentTime: TimeInterval) {
        gameLayer.update(currentTime)
    }
}

extension GameScene {


    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        movableAnalogic.touchesBegan(touches, with: event)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        movableAnalogic.touchesEnded(touches, with: event)
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        movableAnalogic.touchesCancelled(touches, with: event)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        movableAnalogic.touchesMoved(touches, with: event)
    }
}

extension GameScene: GMAnalogDelegate {
    func analogDataUpdated(analogicData: AnalogData) {
        gameLayer.moveSun(analogicData: analogicData)
    }
}
