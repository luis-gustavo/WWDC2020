//
//  BackgroundLayer.swift
//  wwdc2020
//
//  Created by Luis Gustavo Avelino de Lima Jacinto on 08/05/20.
//  Copyright © 2020 Luis Gustavo Avelino de Lima Jacinto. All rights reserved.
//

import SpriteKit

final class BackgroundLayer: SKNode {

    // MARK: - Properties
    let size: CGSize
    let background = SKSpriteNode(imageNamed: "nebula")

    // MARK: - Inits
    init(size: CGSize) {
        self.size = size

        super.init()

        addChild(background)
        background.size = CGSize(width: size.width * 15, height: size.height * 15)
        background.lightingBitMask = PlanetsType.background.fieldMask
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
