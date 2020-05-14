//
//  PlanetsType.swift
//  wwdc2020
//
//  Created by Luis Gustavo Avelino de Lima Jacinto on 08/05/20.
//  Copyright © 2020 Luis Gustavo Avelino de Lima Jacinto. All rights reserved.
//

import SpriteKit

enum PlanetType {
    case sun
    case shootingStar
    case planet(SolarSystemPlanet)
    case background
    case star
    case asteroid

    var radius: CGFloat {
        switch self {
        case .sun: return 30
        case .shootingStar: return 3
        case .planet (let solarSystemPlanet):
            switch solarSystemPlanet {
            case .mars: return 12
            case .earth: return 16
            case .venus: return 16
            case .mercury: return 10
            case .jupyter: return 30
            case .saturn: return 24
            case .uranus: return 20
            case .neptune: return 20
            }
        case .star: return 1
        case .asteroid: return 6
        case .background: fatalError("This doest not make any sense")
        }
    }

    var fieldMask: UInt32 {
        switch self {
        case .sun: return 0x1 << 0
        case .background: return 0x1 << 2
        case .planet (_): return 0x1 << 3
        case .star, .shootingStar, .asteroid: fatalError("This does not make any sense")
        }
    }

    var orbitRadius: CGPoint {
        switch self {
        case .planet(let solarSystemPlanet):
            switch solarSystemPlanet {
            case .mars: return CGPoint(x: 140, y: 140)
            case .earth: return CGPoint(x: 260, y: 260)
            case .venus: return CGPoint(x: 200, y: 200)
            case .mercury: return CGPoint(x: 80, y: 80)
            case .jupyter: return CGPoint(x: 500, y: 500)
            case .saturn: return CGPoint(x: 440, y: 440)
            case .uranus: return CGPoint(x: 380, y: 380)
            case .neptune: return CGPoint(x: 320, y: 320)
            }
        default: fatalError("This does not make any sense")
        }
    }

    var period: CGFloat {
        switch self {
        case .planet(let solarSystemPlanet):
            switch solarSystemPlanet {
            case .mars: return 1.5
            case .earth: return 2.5
            case .venus: return 2
            case .mercury: return 1
            case .jupyter: return 4
            case .saturn: return 3
            case .uranus: return 3
            case .neptune: return 2
            }
        default: fatalError("This does not make any sense")
        }
    }

    var name: String {
        switch self {
        case .sun: return "Sunny"
        case .planet(let solarSystemPlanet):
            switch solarSystemPlanet {
                case .mars: return "Mars"
                case .earth: return "Earth"
                case .venus: return "Venus"
                case .mercury: return "Mercury"
                case .jupyter: return "Jupyter"
                case .saturn: return "Saturn"
                case .uranus: return "Uranus"
                case .neptune: return "Neptune"
            }
        default: fatalError("This does not make any sense")
        }
    }
}
