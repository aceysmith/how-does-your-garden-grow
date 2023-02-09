//
//  Background.swift
//  how-does-your-garden-grow
//
//  Created by Adam Christopher Smith on 2/4/23.
//

import SpriteKit

class BackgroundNode: SKNode {
    init(size: CGSize, dirtHeight: Int) {
        super.init()
        
        let dirt = SKSpriteNode(imageNamed: "dirt")
        dirt.anchorPoint = CGPoint(x: 0, y: 1.0)
        dirt.position = CGPoint(x: 0, y: dirtHeight)
        dirt.zPosition = Layer.dirtBackground.rawValue
        addChild(dirt)

        let sky = SKSpriteNode(imageNamed: "garden")
        sky.anchorPoint = .zero
        sky.xScale = size.width / sky.texture!.size().width
        sky.yScale = size.width / sky.texture!.size().width
        sky.position = CGPoint(x: 0, y: dirtHeight)
        sky.zPosition = Layer.skyBackground.rawValue
        addChild(sky)
    }
    required init?(coder aDecoder: NSCoder) { return nil }
}
