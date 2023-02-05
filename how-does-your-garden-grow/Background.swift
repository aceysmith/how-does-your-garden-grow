//
//  Background.swift
//  how-does-your-garden-grow
//
//  Created by Adam Christopher Smith on 2/4/23.
//

import SpriteKit

class Background: SKNode {
    init(size: CGSize, dirtHeight: Int) {
        super.init()
        
        let dirt = SKSpriteNode(imageNamed: "dirt")
        dirt.anchorPoint = .zero
        dirt.zPosition = -20
        addChild(dirt)

        let sky = SKSpriteNode(imageNamed: "sky")
        sky.anchorPoint = .zero
        sky.xScale = size.width / sky.texture!.size().width
        sky.yScale = size.width / sky.texture!.size().width
        sky.position = CGPoint(x: 0, y: dirtHeight)
        sky.zPosition = -10
        addChild(sky)
    }
    required init?(coder aDecoder: NSCoder) { return nil }
}
