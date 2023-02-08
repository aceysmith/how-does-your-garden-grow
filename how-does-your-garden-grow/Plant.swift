//
//  Plant.swift
//  how-does-your-garden-grow
//
//  Created by Adam Christopher Smith on 2/3/23.
//

import SpriteKit

enum PlantSpecies: String {
    case Cabbage
    case Carrot
    case Chard
    case Herb
    case Mustard
    case Tomato
}

enum Direction: Int {
    case left = 0
    case right
    case up
    case down
}

struct PlantRelativePosition {
    let x: Int
    let y: Int
    func moved(_ direction:Direction) -> PlantRelativePosition {
        var nextPosition: PlantRelativePosition
        switch (direction) {
        case .up:
            nextPosition = PlantRelativePosition(x: self.x, y: self.y - 1)
            break
        case .down:
            nextPosition = PlantRelativePosition(x: self.x, y: self.y + 1)
            break
        case .left:
            nextPosition = PlantRelativePosition(x: self.x - 1, y: self.y)
            break
        case .right:
            nextPosition = PlantRelativePosition(x: self.x + 1, y: self.y)
            break
        }
        return nextPosition
    }
}

struct Plant {
    var root: RootSegment
    let species: PlantSpecies
    let award: Int
    let hue: CGFloat
    var stunted = false
    var rootSegments: Int {
        return root.subSegments
    }
    var grownRootSegments: Int {
        return root.grownSubSegments
    }
    init(species: PlantSpecies, root: RootSegment, award: Int, hue: CGFloat) {
        self.species = species
        self.root = root
        self.award = award
        self.hue = hue
        self.root.addHue(hue: hue)
    }
    
    var segmentPositions: [(RootSegment, PlantRelativePosition)] {
        return root.computeSegmentPositions(plantRelativePosition: PlantRelativePosition(x: 0, y: 0))
    }

    mutating func grow(position: Int, canGrow: (PlantRelativePosition) -> Bool) -> Bool {
        return root.grow(position: PlantRelativePosition(x: position, y: 0), canGrow: canGrow)
    }
}

extension Plant {
    static func carrot() -> Plant {
        let downFive = RootSegment(parentDirection: .up, left: nil, right: nil, up: nil, down: nil)
        let downFour = RootSegment(parentDirection: .up, left: nil, right: nil, up: nil, down: downFive)
        let downThree = RootSegment(parentDirection: .up, left: nil, right: nil, up: nil, down: downFour)
        let downTwo = RootSegment(parentDirection: .up, left: nil, right: nil, up: nil, down: downThree)
        let downOne = RootSegment(parentDirection: .up, left: nil, right: nil, up: nil, down: downTwo)
        let root = RootSegment(parentDirection: .up, left: nil, right: nil, up: nil, down: downOne)
        
        return Plant(species: .Carrot, root: root, award: 5, hue: 0 / 6)
    }

    static func chard() -> Plant {
        let leftWingTop = RootSegment(parentDirection: .down, left: nil, right: nil, up: nil, down: nil)
        let leftWingBottom = RootSegment(parentDirection: .up, left: nil, right: nil, up: nil, down: nil)
        let leftWingMid = RootSegment(parentDirection: .right, left: nil, right: nil, up: leftWingTop, down: leftWingBottom)
        let leftWingConnector = RootSegment(parentDirection: .right, left: leftWingMid, right: nil, up: nil, down: nil)
        let rightWingTop = RootSegment(parentDirection: .down, left: nil, right: nil, up: nil, down: nil)
        let rightWingBottom = RootSegment(parentDirection: .up, left: nil, right: nil, up: nil, down: nil)
        let rightWingMid = RootSegment(parentDirection: .left, left: nil, right: nil, up: rightWingTop, down: rightWingBottom)
        let rightWingConnector = RootSegment(parentDirection: .left, left: nil, right: rightWingMid, up: nil, down: nil)
        let downThree = RootSegment(parentDirection: .up, left: nil, right: nil, up: nil, down: nil)
        let downTwo = RootSegment(parentDirection: .up, left: leftWingConnector, right: rightWingConnector, up: nil, down: downThree)
        let downOne = RootSegment(parentDirection: .up, left: nil, right: nil, up: nil, down: downTwo)
        let root = RootSegment(parentDirection: .up, left: nil, right: nil, up: nil, down: downOne)

        return Plant(species: .Chard, root: root, award: 10, hue: 1 / 6)
    }
    
    static func herb() -> Plant {
        let fiveRight = RootSegment(parentDirection: .left, left: nil, right: nil, up: nil, down: nil)
        let fiveLeft = RootSegment(parentDirection: .right, left: nil, right: nil, up: nil, down: nil)
        let five = RootSegment(parentDirection: .up, left: fiveLeft, right: fiveRight, up: nil, down: nil)
        let four = RootSegment(parentDirection: .up, left: nil, right: nil, up: nil, down: five)
        let three = RootSegment(parentDirection: .up, left: nil, right: nil, up: nil, down: four)
        let two = RootSegment(parentDirection: .up, left: nil, right: nil, up: nil, down: three)
        let one = RootSegment(parentDirection: .up, left: nil, right: nil, up: nil, down: two)

        return Plant(species: .Herb, root: one, award: 5, hue: 2 / 6)
    }
    
    static func cabbage() -> Plant {
        let threeRight = RootSegment(parentDirection: .up, left: nil, right: nil, up: nil, down: nil)
        let threeLeft = RootSegment(parentDirection: .up, left: nil, right: nil, up: nil, down: nil)
        let oneRight = RootSegment(parentDirection: .down, left: nil, right: nil, up: nil, down: nil)
        let oneLeft = RootSegment(parentDirection: .down, left: nil, right: nil, up: nil, down: nil)
        let three = RootSegment(parentDirection: .up, left: nil, right: nil, up: nil, down: nil)
        let twoRight = RootSegment(parentDirection: .left, left: nil, right: nil, up: oneRight, down: threeRight)
        let twoLeft = RootSegment(parentDirection: .right, left: nil, right: nil, up: oneLeft, down: threeLeft)
        let two = RootSegment(parentDirection: .up, left: twoLeft, right: twoRight, up: nil, down: three)
        let one = RootSegment(parentDirection: .up, left: nil, right: nil, up: nil, down: two)

        return Plant(species: .Cabbage, root: one, award: 5, hue: 3 / 6)
    }
    
    static func tomato() -> Plant {
        let sixRightRight = RootSegment(parentDirection: .left, left: nil, right: nil, up: nil, down: nil)
        let sixRight = RootSegment(parentDirection: .left, left: nil, right: sixRightRight, up: nil, down: nil)
        let sixLeftLeft = RootSegment(parentDirection: .right, left: nil, right: nil, up: nil, down: nil)
        let sixLeft = RootSegment(parentDirection: .right, left: sixLeftLeft, right: nil, up: nil, down: nil)
        let six = RootSegment(parentDirection: .up, left: sixLeft, right: sixRight, up: nil, down: nil)
        let five = RootSegment(parentDirection: .up, left: nil, right: nil, up: nil, down: six)
        let fourRightRight = RootSegment(parentDirection: .left, left: nil, right: nil, up: nil, down: nil)
        let fourRight = RootSegment(parentDirection: .left, left: nil, right: fourRightRight, up: nil, down: nil)
        let fourLeftLeft = RootSegment(parentDirection: .right, left: nil, right: nil, up: nil, down: nil)
        let fourLeft = RootSegment(parentDirection: .right, left: fourLeftLeft, right: nil, up: nil, down: nil)
        let four = RootSegment(parentDirection: .up, left: fourLeft, right: fourRight, up: nil, down: five)
        let three = RootSegment(parentDirection: .up, left: nil, right: nil, up: nil, down: four)
        let two = RootSegment(parentDirection: .up, left: nil, right: nil, up: nil, down: three)
        let one = RootSegment(parentDirection: .up, left: nil, right: nil, up: nil, down: two)

        return Plant(species: .Tomato, root: one, award: 10, hue: 4 / 6)
    }
    
    static func mustard() -> Plant {
        
        let oneRightDown = RootSegment(parentDirection: .up, left: nil, right: nil, up: nil, down: nil)
        let oneRight = RootSegment(parentDirection: .left, left: nil, right: nil, up: nil, down: oneRightDown)
        let oneLeftDown = RootSegment(parentDirection: .up, left: nil, right: nil, up: nil, down: nil)
        let oneLeft = RootSegment(parentDirection: .right, left: nil, right: nil, up: nil, down: oneLeftDown)
        let one = RootSegment(parentDirection: .up, left: oneLeft, right: oneRight, up: nil, down: nil)

        return Plant(species: .Mustard, root: one, award: 3, hue: 5 / 6)
    }
}
