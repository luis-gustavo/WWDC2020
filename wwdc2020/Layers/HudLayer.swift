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

    // MARK: - Inits
    init(size: CGSize) {
        self.size = size
        joystick = Joystick(withDiameter: 80)
        joystick.position = CGPoint(x: -size.width/2 + size.width * 0.1, y: -size.height/2 + size.height * 0.1)

        super.init()

        addChild(joystick)
        joystick.on(.move, { [unowned self] joystick in
            let newVelocity = CGPoint(x: joystick.velocity.x / 4, y: joystick.velocity.y / 4)
            self.delegate?.joystickMoved(newVelocity)
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
