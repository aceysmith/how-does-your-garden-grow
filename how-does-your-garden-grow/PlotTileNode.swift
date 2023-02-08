//
//  PlotTile.swift
//  how-does-your-garden-grow
//
//  Created by Adam Christopher Smith on 2/4/23.
//

import SpriteKit

class PlotTileNode: SKEffectNode {
    private var lastSegments: [RootSegment] = []
    private var plantImage: SKSpriteNode!
    private var harvestParticle: SKEmitterNode?
    private var lastPlant: Plant?
    private let size: CGSize
    private let displayPreview: Bool
    init(size: CGSize, displayPreview: Bool) {
        self.size = size
        self.displayPreview = displayPreview
        super.init()
        plantImage = SKSpriteNode(texture: nil, size: size)
        plantImage.position = CGPoint(x: size.width / 2, y: size.height / 2)
        plantImage.zPosition = Layer.plants.rawValue
        plantImage.color = .brown
        plantImage.isHidden = true
        addChild(plantImage)
        
        if !displayPreview {
            harvestParticle = SKEmitterNode(fileNamed: "Harvest")
            harvestParticle?.isPaused = true
            harvestParticle?.isHidden = true
            harvestParticle?.position = CGPoint(x: size.width / 2, y: size.width / 2)
            harvestParticle?.zPosition = Layer.glow.rawValue
            addChild(harvestParticle!)
        }
    }
    required init?(coder aDecoder: NSCoder) { return nil }

    func displayPlant(plant: Plant?) {
        if let plant {
            lastPlant = plant
            var imageName = plant.species.rawValue
            let growthPercentage = (Double(plant.grownRootSegments) / Double(plant.rootSegments)) * 100
            if  growthPercentage > 50 {
                imageName += "_large"
            } else {
                imageName += "_small"
            }
            plantImage.texture = SKTexture(imageNamed: imageName)
            plantImage.isHidden = false
            plantImage.alpha = displayPreview ? 0.5 : 1.0
            plantImage.colorBlendFactor = plant.stunted ? 1 : 0
            harvestParticle?.isPaused = growthPercentage < 100
            harvestParticle?.isHidden = growthPercentage < 100
        } else {
            harvestParticle?.isPaused = true
            harvestParticle?.isHidden = true
            plantImage.texture = nil
            plantImage.isHidden = true
            lastPlant = nil
        }
        // TODO: compute delta, add/remove textures for segments, animate frames
    }
}
