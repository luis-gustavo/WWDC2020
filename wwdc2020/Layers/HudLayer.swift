//
//  HudLayer.swift
//  wwdc2020
//
//  Created by Luis Gustavo Avelino de Lima Jacinto on 08/05/20.
//  Copyright © 2020 Luis Gustavo Avelino de Lima Jacinto. All rights reserved.
//

import SpriteKit

protocol HudLayerDelegate {
    func joystickMoved(_ velocity: CGPoint)
}

final class HudLayer: SKNode {

    // MARK: - Properties
    let size: CGSize
    let joystick: Joystick
    var delegate: HudLayerDelegate?
    let eventLabel: SKLabelNode
    let timerLabel: SKLabelNode
    var timerValue: Int = 60 {
        didSet {
            timerLabel.text = "Time left: \(timerValue)"
            if timerValue == 0 {
                timerLabel.removeAction(forKey: "timer")
                NotificationCenter.default.post(name: .timeEnded, object: nil)
            }
        }
    }


    // MARK: - Inits
    init(size: CGSize) {
        self.size = size

        // Joystick
        joystick = Joystick(withDiameter: 80)
        joystick.position = CGPoint(x: -size.width/2 + size.width * 0.1, y: -size.height/2 + size.height * 0.1)

        // Timer label
        self.timerLabel = SKLabelNode()

        // Event label
        self.eventLabel = SKLabelNode()

        super.init()

        // Add child
        addChild(joystick)
        addChild(timerLabel)
        addChild(eventLabel)

        // Timer label
        self.timerLabel.fontColor = .white
        self.timerLabel.text = "Time left: 60"
        self.timerLabel.position = CGPoint(x: size.width / 2 - timerLabel.frame.size.width / 2 - 20, y: size.height * 0.45)
        self.timerLabel.alpha = 0

        // Event label
        self.eventLabel.fontColor = .white
        self.eventLabel.position = CGPoint(x: 0, y: size.height * 0.45)
        self.eventLabel.alpha = 0

        // Joystick
        joystick.on(.move, { [unowned self] joystick in
            let newVelocity = CGPoint(x: joystick.velocity.x / 4, y: joystick.velocity.y / 4)
            self.delegate?.joystickMoved(newVelocity)
        })

        NotificationCenter.default.addObserver(self, selector: #selector(showEvent(_:)), name: .planetCollected, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showEvent(_:)), name: .planetCollidedWithBlackHole, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: .planetCollected, object: nil)
        NotificationCenter.default.removeObserver(self, name: .planetCollidedWithBlackHole, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func showEvent(_ notification: Notification) {
        guard let eventText = notification.userInfo?["text"] as? String else {
            fatalError("Text must exist")
        }

        self.eventLabel.text = eventText

        let duration: TimeInterval = 1.0
        let fadeIn = SKAction.fadeIn(withDuration: duration)
        let fadeOut = SKAction.fadeOut(withDuration: duration)
        let wait = SKAction.wait(forDuration: duration)
        let sequence = SKAction.sequence([fadeIn, wait, fadeOut])

        self.eventLabel.run(sequence)
    }

    func startTimer() {
        self.timerLabel.alpha = 1.0
        self.timerValue = 60
        let wait = SKAction.wait(forDuration: 1)
        let run = SKAction.run { [weak self] in
            guard let self = self else { return }
            self.timerValue -= 1
        }
        let sequence = SKAction.sequence([wait, run])
        let repeatForever = SKAction.repeatForever(sequence)
        self.timerLabel.run(repeatForever, withKey: "timer")
    }
}
