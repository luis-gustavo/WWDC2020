//
//  PlanetsType.swift
//  wwdc2020
//
//  Created by Luis Gustavo Avelino de Lima Jacinto on 08/05/20.
//  Copyright © 2020 Luis Gustavo Avelino de Lima Jacinto. All rights reserved.
//

import SpriteKit

enum PlanetsType {
    case sun
    case star
    case planet
    case background

    var radius: CGFloat {
        switch self {
        case .sun: return 30
        case .star: return 5
        case .planet: return 15
        case .background: fatalError("This doest not make any sense")
        }
    }

    var fieldMask: UInt32 {
        switch self {
        case .sun: return 0x0
        case .star, .planet: return 0x1
        case .background: return 0x2
        }
    }
}
