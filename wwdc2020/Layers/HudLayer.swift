//
//  HudLayer.swift
//  wwdc2020
//
//  Created by Luis Gustavo Avelino de Lima Jacinto on 08/05/20.
//  Copyright © 2020 Luis Gustavo Avelino de Lima Jacinto. All rights reserved.
//

import SpriteKit

protocol HudLayerDelegate {
    func startCutscene()
    func dialogueFinished(_ dialogue: DialogueScene)
}

final class HudLayer: SKNode {

    // MARK: - Properties
    let size: CGSize
    var delegate: HudLayerDelegate?
    let eventLabel: SKLabelNode
    let timerLabel: SKLabelNode
    var timerValue: Int = 45 {
        didSet {
            timerLabel.text = "Time left: \(timerValue)"
            if timerValue == 0 {
                timerLabel.removeAction(forKey: "timer")
                NotificationCenter.default.post(name: .timeEnded, object: nil)
            }
        }
    }
    let dialogueNode = DialogueNode()
    let flashNode: FlashWhiteNode
    let tapToStartLabel = SKLabelNode()
    let planetsLabel = SKLabelNode()
    let planetsAmount = 8
    var planetsCollected = 0 {
        didSet {
            planetsLabel.text = "\(planetsCollected)/\(planetsLost)/\(planetsAmount)"
        }
    }
    var planetsLost = 0 {
        didSet {
            planetsLabel.text = "\(planetsCollected)/\(planetsLost)/\(planetsAmount)"
            if planetsLost == 8 {
                NotificationCenter.default.post(name: .noMorePlanetsLeft, object: nil)
            }
        }
    }

    // MARK: - Inits
    init(size: CGSize) {
        self.size = size

        // Timer label
        self.timerLabel = SKLabelNode()

        // Event label
        self.eventLabel = SKLabelNode()

        // Flash node
        self.flashNode = FlashWhiteNode(rectOf: CGSize(width: size.width, height: size.height))
        flashNode.alpha = 0

        super.init()

        // Add child
        addChild(timerLabel)
        addChild(eventLabel)
        addChild(dialogueNode)
        addChild(flashNode)
        addChild(tapToStartLabel)
        addChild(planetsLabel)

        // Timer label
        self.timerLabel.fontColor = .white
        self.timerLabel.text = "Time left: 45"
        self.timerLabel.alpha = 0

        // Planets label
        planetsLabel.fontColor = .white
        planetsLabel.text = "0/0/8"
        planetsLabel.alpha = 0

        // Event label
        self.eventLabel.fontColor = .white
        self.eventLabel.alpha = 0

        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            self.eventLabel.fontSize = 28
            self.eventLabel.position = CGPoint(x: 0, y: size.height * 0.3)
            self.timerLabel.fontSize = 28
            self.timerLabel.position = CGPoint(x: size.width / 2 - timerLabel.frame.size.width / 2 - 20, y: size.height * 0.4)
            self.planetsLabel.fontSize = 28
            self.planetsLabel.position = CGPoint(x: -size.width / 2 + planetsLabel.frame.size.width / 2 + 20, y: self.timerLabel.frame.origin.y)
            tapToStartLabel.fontSize = 42
        default:
            self.eventLabel.fontSize = 32
            self.eventLabel.position = CGPoint(x: 0, y: size.height * 0.4)
            self.timerLabel.fontSize = 32
            self.timerLabel.position = CGPoint(x: size.width / 2 - timerLabel.frame.size.width / 2 - 20, y: size.height * 0.45)
            self.planetsLabel.fontSize = 32
            self.planetsLabel.position = CGPoint(x: -size.width / 2 + planetsLabel.frame.size.width / 2 + 20, y: self.timerLabel.frame.origin.y)
            tapToStartLabel.fontSize = 48
        }

        // Tap to start label
        self.tapToStartLabel.fontColor = .white
        self.tapToStartLabel.fontSize = 48
        self.tapToStartLabel.position = CGPoint(x: 0, y: -size.height/2.5)
        self.tapToStartLabel.text = "Tap on the screen to start"
        let duration: TimeInterval = 1.0
        let scaleUp = SKAction.scale(to: 1.2, duration: duration)
        let scaleDown = SKAction.scale(to: 0.8, duration: duration)
        let sequence = SKAction.sequence([scaleUp, scaleDown])
        let repeatForever = SKAction.repeatForever(sequence)
        self.tapToStartLabel.run(repeatForever)

        // Dialogue node
        dialogueNode.texture?.filteringMode = .nearest
        dialogueNode.size = CGSize(width: size.width * 0.8, height: size.height * 0.25)
        let x: CGFloat = 0
        let y: CGFloat = -size.height / 2 + dialogueNode.size.height/2 + 10
        dialogueNode.position = CGPoint(x: x, y: y)
        dialogueNode.delegate = self

        // Observers
        NotificationCenter.default.addObserver(self, selector: #selector(showEvent(_:)), name: .planetCollected, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showEvent(_:)), name: .planetCollidedWithBlackHole, object: nil)

    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: .planetCollected, object: nil)
        NotificationCenter.default.removeObserver(self, name: .planetCollidedWithBlackHole, object: nil)
    }

    func flash() {
        flashNode.start()
    }

    func startDialogue(_ dialogue: DialogueScene) {
        dialogueNode.startDialogue(dialogue)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func showEvent(_ notification: Notification) {
        guard let eventText = notification.userInfo?["text"] as? String else {
            fatalError("Text must exist")
        }

        if eventText.contains("rescued") {
            planetsCollected += 1
        } else {
            planetsCollected -= 1
            planetsLost += 1
        }

        self.eventLabel.text = eventText

        let duration: TimeInterval = 1.0
        let fadeIn = SKAction.fadeIn(withDuration: duration)
        let fadeOut = SKAction.fadeOut(withDuration: duration)
        let wait = SKAction.wait(forDuration: duration)
        let sequence = SKAction.sequence([fadeIn, wait, fadeOut])

        self.eventLabel.run(sequence)
    }

    func showPlanetsLabel() {
        planetsLabel.run(.fadeIn(withDuration: 1.0))
    }

    func hidePlanetsLabel() {
        planetsLabel.run(.fadeOut(withDuration: 1.0))
    }

    func startTimer(_ value: Int) {
        self.timerValue = value
        self.timerLabel.text = "Time left: \(value)"
        let wait = SKAction.wait(forDuration: 1)
        let run = SKAction.run { [weak self] in
            guard let self = self else { return }
            self.timerValue -= 1
        }
        let sequence = SKAction.sequence([wait, run])
        let repeatForever = SKAction.repeatForever(sequence)
        timerLabel.run(.fadeIn(withDuration: 1.0)) {
            self.timerLabel.run(repeatForever, withKey: "timer")
        }
    }

    func stopTimer() {
        self.timerLabel.removeAllActions()
        self.timerLabel.run(.fadeOut(withDuration: 1.0))
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        if tapToStartLabel.parent != nil {
            GameManager.shared.inCustscene = true
            GameManager.shared.inIntro = false
            tapToStartLabel.removeFromParent()
            delegate?.startCutscene()
        } else if GameManager.shared.inCustscene {
            dialogueNode.nextDialogue()
        }
    }
}

extension HudLayer: DialogueNodeProtocol {
    func dialogueFinished(_ dialogue: DialogueScene) {
        dialogueNode.run(.fadeOut(withDuration: 1.0))
        delegate?.dialogueFinished(dialogue)
    }
}
