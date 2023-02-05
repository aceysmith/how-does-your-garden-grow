//
//  DirtTile.swift
//  how-does-your-garden-grow
//
//  Created by Adam Christopher Smith on 2/4/23.
//

import SpriteKit

let lineWidth = 2

class DirtTileNode: SKShapeNode {
    var lastSegments: [RootSegment] = []
    init(size: CGSize) {
        super.init()
        self.path = CGPath(
            rect: CGRect(
                origin: CGPoint(x: lineWidth / 2, y: lineWidth / 2),
                size: CGSize(width: size.width - lineWidth, height: size.height - lineWidth)
            ),
            transform: nil
        )
        self.strokeColor = .brown.withAlphaComponent(0.3)
        self.lineWidth = 2
    }
    required init?(coder aDecoder: NSCoder) { return nil }

    func displayRootSegments(rootSegments: [RootSegment]) {
        var color: UIColor = .brown.withAlphaComponent(0.3)
        for rootSegment in rootSegments {
            if rootSegment.grown == true {
                color = .brown
            }
        }
        self.fillColor = color
        
        self.strokeColor = rootSegments.count > 1 ? .red : .brown.withAlphaComponent(0.3)
        // TODO: compute delta, add/remove textures for segments, animate frames
    }
}
