//
//  PlotTile.swift
//  how-does-your-garden-grow
//
//  Created by Adam Christopher Smith on 2/4/23.
//

import SpriteKit

class PlotTile: SKShapeNode {
    private var lastSegments: [RootSegment] = []
    private var plantImage: SKSpriteNode?
    private var size: CGSize
    init(size: CGSize) {
        self.size = size
        super.init()
//        self.path = CGPath(rect: CGRect(origin: .zero, size: size), transform: nil)
//        self.strokeColor = .green
    }
    required init?(coder aDecoder: NSCoder) { return nil }

    func displayPlant(plant: Plant?) {
        if let plantImage {
            plantImage.removeFromParent()
            self.plantImage = nil
        }
        if let plant {
            let texture = SKTexture(imageNamed: "\(plant.species.rawValue)_large")
            self.plantImage = SKSpriteNode(texture: texture, size: self.size)
            self.plantImage?.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
            addChild(self.plantImage!)
        }
        // TODO: compute delta, add/remove textures for segments, animate frames
    }
}
