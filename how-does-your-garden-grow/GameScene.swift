//
//  GameScene.swift
//  how-does-your-garden-grow
//
//  Created by Adam Christopher Smith on 2/3/23.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var label : SKLabelNode!
    private var spinnyNode : SKShapeNode?
    
    override func didMove(to view: SKView) {
        self.label = SKLabelNode(text: "Hello, World!")
        self.label.position = CGPoint(x: view.frame.size.width / 2, y: view.frame.size.height / 2)
        addChild(self.label)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
