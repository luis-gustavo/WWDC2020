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
    case shootingStar
    case planet
    case background
    case star

    var radius: CGFloat {
        switch self {
        case .sun: return 30
        case .shootingStar: return 5
        case .planet: return 15
        case .star: return 7
        case .background: fatalError("This doest not make any sense")
        }
    }

    var fieldMask: UInt32 {
        switch self {
        case .sun: return 0x1 << 0
        case .background: return 0x1 << 2
        case .planet: return 0x1 << 3
        case .star, .shootingStar: fatalError("This doest not make any sense")
        }
    }
}
