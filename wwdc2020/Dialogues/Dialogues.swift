//
//  Dialogues.swift
//  wwdc2020
//
//  Created by Luis Gustavo Avelino de Lima Jacinto on 14/05/20.
//  Copyright © 2020 Luis Gustavo Avelino de Lima Jacinto. All rights reserved.
//

import Foundation

enum DialogueScene {
    case intro
    case climax(Int)

    var dialogue: [String] {
        switch self {
        case .intro:
            return [
                "(Tap on the screen to play the next sentence)",
                "...What just happened ?!",
                "I think something just hitted us",
                "Oh no!!! Where are all the planets ?",
                "They can't survive long away from me",
                "The space is cold and full of danger",
                "Can you help me to rescue them ?",
                "There are eight planets lost in space",
                "We have one minute to save\n as most planets as we can",
                "The future of the solar system relies in us",
                "We must remember to watch\nout for the black holes",
                "If a planet touches it, it will be absorbed by it",
                "Let's go!!!"
            ]
        case .climax(let planetsLost):
            return [
                "Great!",
                "We saved \(planetsLost == 0 ? "all" : "some") of them",
                "And everything can go back to nor...",
                "Oh no!!!",
                "An asteroid storm is coming!",
                "We must dodge the asteroids, otherwise\nthe planets will be destroyed",
                "We need to keep the planets\nsafe for one minute"
            ]
        }
    }
}
