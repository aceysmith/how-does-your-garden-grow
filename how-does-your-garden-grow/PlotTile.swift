//
//  PlotTile.swift
//  how-does-your-garden-grow
//
//  Created by Adam Christopher Smith on 2/4/23.
//

import SpriteKit

class PlotTile: SKEffectNode {
    private var lastSegments: [RootSegment] = []
    private var plantImage: SKSpriteNode?
    private var size: CGSize
    init(size: CGSize) {
        self.size = size
        super.init()
    }
    required init?(coder aDecoder: NSCoder) { return nil }

    func displayPlant(plant: Plant?) {
        if let plantImage {
            plantImage.removeFromParent()
            self.plantImage = nil
        }
        if let plant {
            var imageName = plant.species.rawValue
            if Double(plant.grownRootSegments) / Double(plant.rootSegments) > 0.5 {
                imageName += "_large"
            } else {
                imageName += "_small"
            }
            let texture = SKTexture(imageNamed: imageName)
            plantImage = SKSpriteNode(texture: texture, size: size)
            plantImage?.position = CGPoint(x: size.width / 2, y: size.height / 2)
            plantImage?.zPosition = Layer.plants.rawValue
            addChild(plantImage!)
        }
        // TODO: compute delta, add/remove textures for segments, animate frames
    }
}
