//
//  Level.swift
//  how-does-your-garden-grow
//
//  Created by Adam Christopher Smith on 2/4/23.
//

struct Level {
    let plants: [Plant?]
    func plantForTurn(turn: Int) -> Plant? {
        if turn < plants.count {
            return plants[turn]
        }
        return nil
    }
}

extension Level {
    static func spring() -> Level {
        return Level(plants: [
            .tallBoy(),
            .tallBoy(),
            .fighterJet(),
            .tallBoy(),
            .tallBoy(),
            .fighterJet(),
            .tallBoy()
        ])
    }
    static func summer() -> Level {
        return Level(plants: [])
    }
    static func fall() -> Level {
        return Level(plants: [])
    }
    static func winter() -> Level {
        return Level(plants: [])
    }
}
