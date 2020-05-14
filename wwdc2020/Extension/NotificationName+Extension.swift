//
//  NotificationName+Extension.swift
//  wwdc2020
//
//  Created by Luis Gustavo Avelino de Lima Jacinto on 08/05/20.
//  Copyright © 2020 Luis Gustavo Avelino de Lima Jacinto. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let sunPositionChanged = Notification.Name("sunPositionChanged")
    static let planetCollected = Notification.Name("planetCollected")
    static let timeEnded = Notification.Name("timeEnded")
    static let planetCollidedWithBlackHole = Notification.Name("planetCollidedWithBlackHole")
    static let explosionStarted = Notification.Name("explosionStarted")
    static let explosionEnded = Notification.Name("explosionEnded")
    static let collectedAllPlanets = Notification.Name("collectedAllPlanets")
}
