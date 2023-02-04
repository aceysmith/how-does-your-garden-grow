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
        
        let blueSky = SKSpriteNode(color: .blue, size: size)
        blueSky.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(blueSky)
        
        let dirt = SKSpriteNode(color: .brown, size: CGSize(width: size.width, height: CGFloat(dirtHeight)))
        dirt.position = CGPoint(x: size.width / 2, y: CGFloat(dirtHeight) / 2)
        addChild(dirt)
    }
    
    required init?(coder aDecoder: NSCoder) { return nil }
}
