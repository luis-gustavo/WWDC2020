//
//  Test.swift
//  wwdc2020
//
//  Created by Luis Gustavo Avelino de Lima Jacinto on 11/05/20.
//  Copyright © 2020 Luis Gustavo Avelino de Lima Jacinto. All rights reserved.
//

import Foundation

class Test {
    private init() { }

    static let shared = Test()

    func getNextSound() -> String {
        return sounds.removeFirst()
    }

    private var sounds = ["BigSawBass1",
                  "BigSawBass2",
                  "BigSawBass3",
                  "BigSawBass4",
                  "ClassicElectricPiano1",
                  "ClassicElectricPiano2",
                  "ClassicElectricPiano3",
                  "HeavySynthBass1",
                  "HeavySynthBass2",
                  "HeavySynthBass3",
                  "HeavySynthBass4",
                  "HeavySynthBass5",
                  "HeavySynthBass6",
                  "HeavySynthBass7",
                  "HeavySynthBass8",
                  "JumpUpBass1",
                  "JumpUpBass2",
                  "JumpUpBass3",
                  "TauregMoonBass1",
                  "TauregMoonBass2",
                  "TauregMoonBass3",
                  "TauregMoonBass4"]
}
