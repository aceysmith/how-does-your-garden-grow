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
    case Mustard
}

struct PlantRelativePosition {
    let x: Int
    let y: Int
}

struct Plant {
    var root: RootSegment
    let species: PlantSpecies
    let award: Int
    let tint: SKColor
    var rootSegments: [RootSegment] {
        return root.subSegments
    }
    var grownRootSegments: [RootSegment] {
        return root.grownSubSegments
    }
    init(species: PlantSpecies, root: RootSegment, award: Int, tint: SKColor) {
        self.species = species
        self.root = root
        self.award = award
        self.tint = tint
    }
    
    var segmentPositions: [(RootSegment, PlantRelativePosition)] {
        return root.computeSegmentPositions(plantRelativePosition: PlantRelativePosition(x: 0, y: 0))
    }

    // TODO: can this / should this be a delegate to pass the call down to root?
    mutating func grow() -> Bool {
        return root.grow()
    }
}

extension Plant {
    static func tallBoy() -> Plant {
        let downThree = RootSegment(parentDirection: .up, left: nil, right: nil, up: nil, down: nil)
        let downTwo = RootSegment(parentDirection: .up, left: nil, right: nil, up: nil, down: downThree)
        let downOne = RootSegment(parentDirection: .up, left: nil, right: nil, up: nil, down: downTwo)
        let root = RootSegment(parentDirection: .up, left: nil, right: nil, up: nil, down: downOne)
        
        return Plant(species: .Mustard, root: root, award: 10, tint: .green)
    }

    static func fighterJet() -> Plant {
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

        return Plant(species: .Chard, root: root, award: 10, tint: .gray)
    }
}
