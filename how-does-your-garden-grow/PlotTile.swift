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
            let growthPercentage = (Double(plant.grownRootSegments) / Double(plant.rootSegments)) * 100
            if  growthPercentage > 50 {
                imageName += "_large"
            } else {
                imageName += "_small"
            }
            let texture = SKTexture(imageNamed: imageName)
            plantImage = SKSpriteNode(texture: texture, size: size)
            plantImage?.position = CGPoint(x: size.width / 2, y: size.height / 2)
            plantImage?.zPosition = Layer.plants.rawValue
            addChild(plantImage!)
            
            if growthPercentage == 100 {
                if let harvestParticle = SKEmitterNode(fileNamed: "Harvest") {
                    harvestParticle.position = CGPointMake(0, -plantImage!.size.height / 2)
                    // TODO: this doesn't position behind anything but the plant :(
                    harvestParticle.zPosition = Layer.glow.rawValue
                    plantImage?.addChild(harvestParticle)
                }
            }
        }
        // TODO: compute delta, add/remove textures for segments, animate frames
    }
}
