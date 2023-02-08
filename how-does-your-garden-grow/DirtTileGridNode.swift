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
    private let displayPreview: Bool
    private let dirtTiles: [DirtTileNode]
    
    public init(displayPreview: Bool, tileWidth: Int, horizonalTileCount: Int, verticalTileCount: Int) {
        self.horizonalTileCount = horizonalTileCount
        self.verticalTileCount = verticalTileCount
        self.displayPreview = displayPreview
        var dirtTiles = [DirtTileNode]()
        for _ in 0..<verticalTileCount * horizonalTileCount {
            dirtTiles.append(DirtTileNode(size: CGSize(width: tileWidth, height: tileWidth), displayPreview: displayPreview))
        }
        self.dirtTiles = dirtTiles
        super.init()
        for (index, tile) in self.dirtTiles.enumerated() {
            tile.position = CGPoint(
                x: (index % horizonalTileCount) * tileWidth,
                y: (verticalTileCount - (index / horizonalTileCount) - 1) * tileWidth
            )

            tile.zPosition = displayPreview ? Layer.dirtPreview.rawValue : Layer.dirtRoot.rawValue
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
                let computedX = position.x + index
                if computedX < 0 || computedX >= horizonalTileCount || position.y < 0 || position.y >= verticalTileCount {
                    continue
                }
                rootSegmentsGrid[position.y * horizonalTileCount + computedX].append(rootSegment)
            }
        }
        for (index, dirtTile) in dirtTiles.enumerated() {
            dirtTile.displayRootSegments(rootSegments: rootSegmentsGrid[index])
        }
    }
}
