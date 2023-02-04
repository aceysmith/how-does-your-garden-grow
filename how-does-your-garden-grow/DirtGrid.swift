//
//  DirtGrid.swift
//  how-does-your-garden-grow
//
//  Created by Adam Christopher Smith on 2/4/23.
//

import SpriteKit

class DirtGrid: SKNode {
    private let horizonalTileCount: Int
    private let verticalTileCount: Int

    let dirtTiles: [DirtTile]
    
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
                y: (index / horizonalTileCount) * tileWidth
            )
            addChild(tile)
        }
    }
    
    subscript(row: Int, column: Int) -> DirtTile {
        get {
            return dirtTiles[row * horizonalTileCount + column]
        }
    }
    
    required init?(coder aDecoder: NSCoder) { return nil }
}
