//
//  Player.swift
//  how-does-your-garden-grow
//
//  Created by Adam Christopher Smith on 2/4/23.
//

import SpriteKit

class Player: SKSpriteNode {
    var hand: SKSpriteNode!
    var plantSize: CGSize
    public init(size: CGSize, plantSize: CGSize) {
        self.plantSize = plantSize
        super.init(texture: SKTexture(imageNamed: "arm"), color: .white, size: size)
        hand = SKSpriteNode(texture: nil, size: plantSize)
        hand.anchorPoint = CGPoint(x: 0.5, y: 0)
        addChild(hand)
    }
    required init?(coder aDecoder: NSCoder) { return nil }
    
    func holdPlantSpecies(plantSpecies: PlantSpecies?) {
        if let plantSpecies {
            hand.texture = SKTexture(imageNamed: "\(plantSpecies.rawValue)_small")
        } else {
            hand.texture = nil
        }
    }
}
