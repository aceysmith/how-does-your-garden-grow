//
//  DirtGrid.swift
//  how-does-your-garden-grow
//
//  Created by Adam Christopher Smith on 2/4/23.
//

import SpriteKit

class DirtTileGridNode: SKNode {
    private let horizonalTileCount: Int
    private let verticalTileCount: Int

    private let dirtTiles: [DirtTileNode]
    
    public init(tileWidth: Int, horizonalTileCount: Int, verticalTileCount: Int) {
        self.horizonalTileCount = horizonalTileCount
        self.verticalTileCount = verticalTileCount
        var dirtTiles = [DirtTileNode]()
        for _ in 0..<verticalTileCount * horizonalTileCount {
            dirtTiles.append(DirtTileNode(size: CGSize(width: tileWidth, height: tileWidth)))
        }
        self.dirtTiles = dirtTiles
        super.init()
        for (index, tile) in self.dirtTiles.enumerated() {
            tile.position = CGPoint(
                x: (index % horizonalTileCount) * tileWidth,
                y: (verticalTileCount - (index / horizonalTileCount) - 1) * tileWidth
            )
            tile.zPosition = Layer.dirtPreview.rawValue
            addChild(tile)
        }
    }
    required init?(coder aDecoder: NSCoder) { return nil }

    subscript(row: Int, column: Int) -> DirtTileNode? {
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
