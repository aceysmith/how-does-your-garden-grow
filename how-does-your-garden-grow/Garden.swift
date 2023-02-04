//
//  Garden.swift
//  how-does-your-garden-grow
//
//  Created by Adam Christopher Smith on 2/3/23.
//

import Foundation

struct Garden {
    private let horizonalTileCount: Int
    private let verticalTileCount: Int
    var plantPlots: [Plant?]
//    var dirtPlots: [[RootSegment]]
    
    init(horizonalTileCount: Int, verticalTileCount: Int) {
        self.horizonalTileCount = horizonalTileCount
        self.verticalTileCount = verticalTileCount

        plantPlots = [Plant?](repeating: nil, count: horizonalTileCount)
//        dirtPlots = [[RootSegment]](repeating: [], count: horizonalTileCount * verticalTileCount)
    }
    
//    subscript(row: Int, column: Int) -> [RootSegment] {
//        get {
//            return dirtPlots[row * horizonalTileCount + column]
//        }
//    }
    
    mutating func addPlant(position: Int, plant: Plant) {
        if let _ = plantPlots[position] {
            return
        }
        plantPlots[position] = plant
    }
    
    
    func rootSegmentCoordinate(rootSegment: RootSegment) -> (Int, Int) {
        return (0, 0)
    }
    
    mutating func grow() {
        // TODO: Do the logic to update all of the plants' segments' grown properties
        for plantIndex in 0..<horizonalTileCount {
            if var plant = plantPlots[plantIndex], plant.root.grown == false {
                plant.root.grown = true
                addPlant(position: plantIndex, plant: plant)
                plantPlots[plantIndex] = plant
            }
        }
    }
}
