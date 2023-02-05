//
//  PlantTileArray.swift
//  how-does-your-garden-grow
//
//  Created by Adam Christopher Smith on 2/4/23.
//

import SpriteKit

class PlotTileArray: SKNode {
    private let tileCount: Int
    
    private let plotTiles: [PlotTile]
    
    public init(tileSize: CGSize, tileCount: Int) {
        self.tileCount = tileCount
        var plotTiles = [PlotTile]()
        for _ in 0..<tileCount {
            plotTiles.append(PlotTile(size: tileSize))
        }
        self.plotTiles = plotTiles
        super.init()
        for (index, tile) in self.plotTiles.enumerated() {
            tile.position = CGPoint(
                x: (index % tileCount) * Int(tileSize.width),
                y: 0
            )
            addChild(tile)
        }
    }
    required init?(coder aDecoder: NSCoder) { return nil }
    
    subscript(column: Int) -> PlotTile {
        get {
            return plotTiles[column]
        }
    }
    
    func displayPlants(plants: [Plant?]) {
        for (index, plant) in plants.enumerated() {
            self[index].displayPlant(plant: plant)
        }
    }
}
