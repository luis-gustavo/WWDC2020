//
//  GameOverLayer.swift
//  wwdc2020
//
//  Created by Luis Gustavo Avelino de Lima Jacinto on 14/05/20.
//  Copyright © 2020 Luis Gustavo Avelino de Lima Jacinto. All rights reserved.
//

import SpriteKit

class GameOverLayer: SKNode {

    // MARK: - Properties
    let size: CGSize
    let resultLabel = SKLabelNode()
    let playAgainLabel = SKLabelNode()

    // MARK:
    init(size: CGSize) {
        self.size = size

        super.init()

        // Add child
        addChild(resultLabel)
        addChild(playAgainLabel)
    }

    func setupGameOverLayer(planetsSaved: Int, planetsLost: Int) {
        // Result label
        resultLabel.fontColor = .white
        if planetsLost == 8 {
            resultLabel.text = "All of the planets of the solar system were destroyed"
        } else if planetsLost > 0  {
            resultLabel.text = "You saved \(planetsSaved) planets of the solar system!"
        } else {
            resultLabel.text = "You saved all of the planets solar system!!"
        }
        resultLabel.position = CGPoint(x: 0, y: size.height * 0.4)

        // Play again button
        playAgainLabel.fontColor = .white
        playAgainLabel.text = "Tap on the screen to play again"
        playAgainLabel.position = CGPoint(x: 0, y: -size.height/2.5)
        let duration: TimeInterval = 1.0
        let scaleUp = SKAction.scale(to: 1.2, duration: duration)
        let scaleDown = SKAction.scale(to: 0.8, duration: duration)
        let sequence = SKAction.sequence([scaleUp, scaleDown])
        let repeatForever = SKAction.repeatForever(sequence)
        self.playAgainLabel.run(repeatForever)

        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            playAgainLabel.fontSize = 42
            resultLabel.fontSize = 28
        default:
            playAgainLabel.fontSize = 48
            resultLabel.fontSize = 32
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GameOverLayer {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        NotificationCenter.default.post(name: .replay, object: nil)
    }
}
