//
//  Garden.swift
//  how-does-your-garden-grow
//
//  Created by Adam Christopher Smith on 2/3/23.
//

struct Garden {
    private let horizonalTileCount: Int
    private let verticalTileCount: Int
    var plantPlots: [Plant?]
    
    init(horizonalTileCount: Int, verticalTileCount: Int) {
        self.horizonalTileCount = horizonalTileCount
        self.verticalTileCount = verticalTileCount

        plantPlots = [Plant?](repeating: nil, count: horizonalTileCount)
    }
    
    mutating func addPlant(position: Int, plant: Plant) {
        if let _ = plantPlots[position] {
            return
        }
        plantPlots[position] = plant
    }
    
    mutating func grow() {
        let sortedPlantsByGrown = plantPlots.enumerated().sorted(by: {$0.element?.grownRootSegments.count ?? 0 > $1.element?.grownRootSegments.count ?? 0})
        for (i, plant) in sortedPlantsByGrown {
            if var plant {
                plant.grow()
                self.plantPlots[i] = plant
            }
        }
//        for plantIndex in 0..<horizonalTileCount {
//            if var plant = plantPlots[plantIndex], plant.root.grown == false {
//                plant.root.grown = true
//                addPlant(position: plantIndex, plant: plant)
//                plantPlots[plantIndex] = plant
//            }
//        }
    }
}
