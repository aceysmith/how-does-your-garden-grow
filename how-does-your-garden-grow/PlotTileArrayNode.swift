//
//  PlantTileArray.swift
//  how-does-your-garden-grow
//
//  Created by Adam Christopher Smith on 2/4/23.
//

import SpriteKit

class PlotTileArrayNode: SKNode {
    private let tileCount: Int
    private let displayPreview: Bool
    
    private let plotTiles: [PlotTileNode]
    
    public init(displayPreview: Bool, tileSize: CGSize, tileCount: Int) {
        self.tileCount = tileCount
        self.displayPreview = displayPreview
        var plotTiles = [PlotTileNode]()
        for _ in 0..<tileCount {
            plotTiles.append(PlotTileNode(size: tileSize, displayPreview: displayPreview))
        }
        self.plotTiles = plotTiles
        super.init()
        for (index, tile) in self.plotTiles.enumerated() {
            tile.position = CGPoint(
                x: (index % tileCount) * Int(tileSize.width),
                y: 0
            )
            tile.zPosition = displayPreview ? Layer.plantsPreview.rawValue : Layer.plants.rawValue
            addChild(tile)
        }
    }
    required init?(coder aDecoder: NSCoder) { return nil }
    
    subscript(column: Int) -> PlotTileNode {
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
