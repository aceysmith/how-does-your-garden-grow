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
    
    mutating func removePlant(position: Int) {
        plantPlots[position] = nil
    }
    
    mutating func grow() {
        let sortedPlantsByGrown = plantPlots.enumerated().sorted(by: {
            $0.element?.grownRootSegments ?? 0 > $1.element?.grownRootSegments ?? 0
        })
        for (i, plant) in sortedPlantsByGrown {
            var plotFilled = [Bool](repeating: false, count: horizonalTileCount * verticalTileCount)
            for (i, plant) in plantPlots.enumerated() {
                guard let plant else { continue }
                for (rootSegment, relativePosition) in plant.segmentPositions {
                    guard rootSegment.grown == true else { continue }
                    plotFilled[relativePosition.y * horizonalTileCount + relativePosition.x + i] = true
                }
            }

            guard var plant, plant.grownRootSegments < plant.rootSegments else { continue }
            let plantGrew = plant.grow(position: i, canGrow: { position in
                if position.x < 0 || position.x >= horizonalTileCount || position.y < 0 || position.y >= verticalTileCount {
                    return false
                }
                if plotFilled[position.y * horizonalTileCount + position.x] {
                    return false
                }
                return true
            })
            if !plantGrew {
                plant.stunted = true
            } else if plant.stunted {
                plant.stunted = false
            }
            self.plantPlots[i] = plant
         }
    }
}
