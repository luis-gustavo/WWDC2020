//
//  DialogueNode.swift
//  wwdc2020
//
//  Created by Luis Gustavo Avelino de Lima Jacinto on 14/05/20.
//  Copyright © 2020 Luis Gustavo Avelino de Lima Jacinto. All rights reserved.
//

import SpriteKit

protocol DialogueNodeProtocol {
    func dialogueFinished(_ dialogueScene: DialogueScene)
}

class DialogueNode: SKSpriteNode {

    // MARK: - Properties
    let sprite = SKTexture(imageNamed: "Dialogue Box")
    let dialogueLabel = SKLabelNode()
    var dialogueScene: DialogueScene?
    var currentTalks = [String]()
    var delegate: DialogueNodeProtocol?

    // MARK: - Inits
    init() {
        super.init(texture: sprite, color: .clear, size: sprite.size())

        // Dialogue label
        addChild(dialogueLabel)
        dialogueLabel.fontColor = .white
        dialogueLabel.numberOfLines = 10
        dialogueLabel.constraints = [
            SKConstraint.positionX(SKRange(lowerLimit: frame.minX + 20, upperLimit: frame.maxX - 20))
        ]
        dialogueLabel.text = "asdasdasd"
        dialogueLabel.position = CGPoint(x: dialogueLabel.position.x, y: dialogueLabel.position.y - dialogueLabel.frame.size.height/2)
        dialogueLabel.text = ""
        alpha = 0
    }

    func startDialogue(_ dialogueScene: DialogueScene) {
        self.dialogueScene = dialogueScene
        currentTalks = dialogueScene.dialogue

        if currentTalks.isEmpty {
            delegate?.dialogueFinished(dialogueScene)
        } else {
            let talk = self.currentTalks.removeFirst()
            dialogueLabel.text = talk
            run(SKAction.fadeIn(withDuration: 1.0))
        }
    }

    func nextDialogue() {
        guard let dialogueScene = dialogueScene else { return }

        if currentTalks.isEmpty {
            delegate?.dialogueFinished(dialogueScene)
        } else {
            let talk = self.currentTalks.removeFirst()
            let duration: TimeInterval = 0.5
            let fadeOut = SKAction.fadeOut(withDuration: duration)
            let block = SKAction.run {
                self.dialogueLabel.text = talk
            }
            let fadeIn = SKAction.fadeIn(withDuration: duration)
            let sequence = SKAction.sequence([fadeOut, block, fadeIn])
            dialogueLabel.run(sequence)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
