//
//  DirtTile.swift
//  how-does-your-garden-grow
//
//  Created by Adam Christopher Smith on 2/4/23.
//

import SpriteKit

class DirtTile: SKShapeNode {
    var lastSegments: [RootSegment] = []
    init(size: CGSize) {
        super.init()
        self.path = CGPath(rect: CGRect(origin: .zero, size: size), transform: nil)
        self.strokeColor = .brown.withAlphaComponent(0.3)
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
        // TODO: compute delta, add/remove textures for segments, animate frames
    }
}
