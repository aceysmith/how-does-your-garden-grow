//
//  DirtGrid.swift
//  how-does-your-garden-grow
//
//  Created by Adam Christopher Smith on 2/4/23.
//

import SpriteKit

class DirtTileGrid: SKNode {
    private let horizonalTileCount: Int
    private let verticalTileCount: Int

    private let dirtTiles: [DirtTile]
    
    public init(tileWidth: Int, horizonalTileCount: Int, verticalTileCount: Int) {
        self.horizonalTileCount = horizonalTileCount
        self.verticalTileCount = verticalTileCount
        var dirtTiles = [DirtTile]()
        for _ in 0..<verticalTileCount * horizonalTileCount {
            dirtTiles.append(DirtTile(size: CGSize(width: tileWidth, height: tileWidth)))
        }
        self.dirtTiles = dirtTiles
        super.init()
        for (index, tile) in self.dirtTiles.enumerated() {
            tile.position = CGPoint(
                x: (index % horizonalTileCount) * tileWidth,
                y: (verticalTileCount - (index / horizonalTileCount) - 1) * tileWidth
            )
            addChild(tile)
        }
    }
    required init?(coder aDecoder: NSCoder) { return nil }

    subscript(row: Int, column: Int) -> DirtTile? {
        get {
            if row < 0 || row >= verticalTileCount || column < 0 || column >= horizonalTileCount {
                return nil
            }
            return dirtTiles[row * horizonalTileCount + column]
        }
    }
    
    func displayPlants(plants: [Plant?]) {
        var rootSegmentsGrid = [[RootSegment]](repeating: [], count: horizonalTileCount * verticalTileCount)
        for (index, plant) in plants.enumerated() {
            guard let plant else { continue }
            for (rootSegment, position) in plant.segmentPositions {
                rootSegmentsGrid[position.y * horizonalTileCount + position.x + index].append(rootSegment)
            }
        }
        for (index, dirtTile) in dirtTiles.enumerated() {
            dirtTile.displayRootSegments(rootSegments: rootSegmentsGrid[index])
        }
    }
}
