//
//  Level.swift
//  how-does-your-garden-grow
//
//  Created by Adam Christopher Smith on 2/4/23.
//

struct Level {
    let plants: [Plant]
    func plantForTurn(turn: Int) -> Plant? {
        if turn < plants.count {
            return plants[turn]
        }
        return nil
    }
}

extension Level {
    static let levels: [Level] = [
        .spring(),
        .summer(),
        .fall(),
        .winter()
    ]
    static func spring() -> Level {
        return Level(plants: [
            .herb(),
            .carrot(),
            .cabbage(),
            .chard(),
            .mustard(),
            .tomato(),
            .carrot(),
            .mustard(),
            .herb(),
            .carrot(),
            .cabbage(),
            .chard(),
            .mustard(),
            .tomato(),
            .carrot(),
            .mustard(),
            .herb(),
            .carrot(),
            .cabbage(),
            .chard(),
            .mustard(),
            .tomato(),
            .carrot(),
            .mustard(),
        ])
    }
    static func summer() -> Level {
        return Level(plants: [
            .mustard(),
            .tomato(),
            .carrot(),
            .mustard(),
        ])
    }
    static func fall() -> Level {
        return Level(plants: [
            .carrot(),
            .cabbage(),
            .chard(),
            .mustard(),
        ])
    }
    static func winter() -> Level {
        return Level(plants: [
            .chard(),
            .mustard(),
            .tomato(),
            .carrot(),
            .mustard(),
        ])
    }
}
