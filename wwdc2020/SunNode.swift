//
//  SunNode.swift
//  wwdc2020
//
//  Created by Luis Gustavo Avelino de Lima Jacinto on 08/05/20.
//  Copyright © 2020 Luis Gustavo Avelino de Lima Jacinto. All rights reserved.
//

import SpriteKit

final class SunNode: SKShapeNode {

    // MARK: - Properties
    var gravityField: SKFieldNode!

    func setup() {

        gravityField = SKFieldNode.radialGravityField()
        fillColor = .yellow

        // Setup gravity field
        gravityField.falloff = 0
        gravityField.strength = 2
        gravityField.categoryBitMask = PlanetsType.star.fieldMask
        addChild(gravityField)


    }

}
