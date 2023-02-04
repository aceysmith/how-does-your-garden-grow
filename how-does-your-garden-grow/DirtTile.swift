//
//  DirtTile.swift
//  how-does-your-garden-grow
//
//  Created by Adam Christopher Smith on 2/4/23.
//

import SpriteKit

class DirtTile: SKShapeNode {
    init(size: CGSize) {
        super.init()
        self.path = CGPath(rect: CGRect(origin: .zero, size: size), transform: nil)
        self.strokeColor = .cyan
    }
    
    required init?(coder aDecoder: NSCoder) { return nil }
}
