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
    case climax

    var dialogue: [String] {
        switch self {
        case .intro:
            return [
                "Tap on the screen to continue",
                "... What just happened ?!",
                "I think something just hit me",
                "Oh no! Where are the planets ?",
                "They can't survive long away from me",
                "The space is cold and full of danger",
                "Can you help me to rescue them ?",
                "Remember to watch out for the black holes",
                "If a planet touch it it will be absorved by it",
                "You have one minute to save the most planets as you can",
                "Let's go!!!"
            ]
        case .climax:
            return [
                "Great! we collected them all",
                "The solar system is saved",
                "And everything can go back to nor...",
                "Oh my god!",
                "A meteor storm is coming!",
                "Dodge the meteors, otherwise the planets will be destroyed",
                "You have to survive for one minute"
            ]
        }
    }
}
