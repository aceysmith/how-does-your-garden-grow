//
//  Level.swift
//  how-does-your-garden-grow
//
//  Created by Adam Christopher Smith on 2/4/23.
//

struct Level {
    let name: String
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
        return Level(name: "Spring", plants: [
            .herb(),
            .carrot(),
            .cabbage(),
            .chard(),
            .mustard(),
            .tomato(),
            .carrot(),
            .mustard(),
            .herb(),
            .cabbage(),
            .chard(),
            .mustard(),
            .tomato(),
            .carrot(),
            .mustard(),
        ])
    }
    static func summer() -> Level {
        return Level(name: "Summer", plants: [
            .mustard(),
            .tomato(),
            .carrot(),
            .cabbage(),
            .chard(),
            .mustard(),
            .tomato(),
            .cabbage(),
            .carrot(),
            .mustard(),
            .herb(),
            .carrot(),
            .carrot(),
            .mustard(),
        ])
    }
    static func fall() -> Level {
        return Level(name: "Fall", plants: [
            .carrot(),
            .cabbage(),
            .herb(),
            .chard(),
            .carrot(),
            .cabbage(),
            .herb(),
            .tomato(),
            .carrot(),
            .cabbage(),
            .carrot(),
            .chard(),
            .mustard(),
        ])
    }
    static func winter() -> Level {
        return Level(name: "Winter", plants: [
            .tomato(),
            .carrot(),
            .cabbage(),
            .chard(),
            .mustard(),
            .tomato(),
            .chard(),
            .cabbage(),
            .carrot(),
            .herb(),
            .carrot(),
            .mustard(),
        ])
    }
}

