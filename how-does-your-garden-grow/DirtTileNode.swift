//
//  DirtTile.swift
//  how-does-your-garden-grow
//
//  Created by Adam Christopher Smith on 2/4/23.
//

import SpriteKit

let lineWidth = 2

class DirtTileNode: SKShapeNode {
    var lastSegments: [RootSegment] = []
    var spriteNodes: [SKSpriteNode] = []
    private var size: CGSize!
    init(size: CGSize) {
        super.init()
        self.size = size
        self.path = CGPath(
            rect: CGRect(
                origin: CGPoint(x: lineWidth / 2, y: lineWidth / 2),
                size: CGSize(width: size.width - lineWidth, height: size.height - lineWidth)
            ),
            transform: nil
        )
        self.strokeColor = .brown.withAlphaComponent(0.3)
        self.lineWidth = 2
    }
    required init?(coder aDecoder: NSCoder) { return nil }

    func displayRootSegments(rootSegments: [RootSegment]) {
        if spriteNodes.count < rootSegments.count {
            for _ in spriteNodes.count..<rootSegments.count {
                let spriteNode = SKSpriteNode(texture: nil, size: size)
                spriteNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
                addChild(spriteNode)
                spriteNodes.append(spriteNode)
            }
        } else if rootSegments.count < spriteNodes.count {
            for i in rootSegments.count..<spriteNodes.count {
                spriteNodes[i].texture = nil
            }
        }

        for (i, rootSegment) in rootSegments.enumerated() {
//            let opacity = rootSegment.grown ? 1.0 : 0.3
            let leftGrown   = (rootSegment.left?.grown ?? false)  || (rootSegment.parentDirection == .left && rootSegment.grown)
            let rightGrown  = (rootSegment.right?.grown ?? false) || (rootSegment.parentDirection == .right && rootSegment.grown)
            let upGrown     = (rootSegment.up?.grown ?? false)    || (rootSegment.parentDirection == .up && rootSegment.grown)
            let downGrown   = (rootSegment.down?.grown ?? false)  || (rootSegment.parentDirection == .down && rootSegment.grown)
            
            let spriteNode = spriteNodes[i]
            var texture: SKTexture?
            if leftGrown && !rightGrown && !upGrown && !downGrown {
                texture = SKTexture(imageNamed: "line_tip")
                spriteNode.zRotation = .pi / 2
            }
            if !leftGrown && rightGrown && !upGrown && !downGrown {
                texture = SKTexture(imageNamed: "line_tip")
                spriteNode.zRotation = -.pi / 2
            }
            if !leftGrown && !rightGrown && upGrown && !downGrown {
                texture = SKTexture(imageNamed: "line_tip")
                spriteNode.zRotation = 0
            }
            if !leftGrown && !rightGrown && !upGrown && downGrown {
                texture = SKTexture(imageNamed: "line_tip")
                spriteNode.zRotation = .pi
            }


            if !leftGrown && !rightGrown && upGrown && downGrown {
                texture = SKTexture(imageNamed: "line_straight")
                spriteNode.zRotation = 0
            }
            if leftGrown && rightGrown && !upGrown && !downGrown {
                texture = SKTexture(imageNamed: "line_straight")
                spriteNode.zRotation = .pi / 2
            }

            
            if !leftGrown && rightGrown && upGrown && !downGrown {
                texture = SKTexture(imageNamed: "line_corner")
                spriteNode.zRotation = 0
            }
            if !leftGrown && rightGrown && !upGrown && downGrown {
                texture = SKTexture(imageNamed: "line_corner")
                spriteNode.zRotation = -.pi / 2
            }
            if leftGrown && !rightGrown && !upGrown && downGrown {
                texture = SKTexture(imageNamed: "line_corner")
                spriteNode.zRotation = .pi
            }
            if leftGrown && !rightGrown && upGrown && !downGrown {
                texture = SKTexture(imageNamed: "line_corner")
                spriteNode.zRotation = .pi / 2
            }

            
            if !leftGrown && rightGrown && upGrown && downGrown {
                texture = SKTexture(imageNamed: "line_3_way")
                spriteNode.zRotation = 0
            }
            if leftGrown && !rightGrown && upGrown && downGrown {
                texture = SKTexture(imageNamed: "line_3_way")
                spriteNode.zRotation = .pi
            }
            if leftGrown && rightGrown && !upGrown && downGrown {
                texture = SKTexture(imageNamed: "line_3_way")
                spriteNode.zRotation = -.pi / 2
            }
            if leftGrown && rightGrown && upGrown && !downGrown {
                texture = SKTexture(imageNamed: "line_3_way")
                spriteNode.zRotation = .pi / 2
            }


            if leftGrown && rightGrown && upGrown && downGrown {
                texture = SKTexture(imageNamed: "line_4_way")
                spriteNode.zRotation = 0
            }
            spriteNodes[i].texture = texture
        }

        var color: UIColor = .brown.withAlphaComponent(0.3)
        for rootSegment in rootSegments {
            if rootSegment.grown == true {
                color = .brown
            }
        }
        self.fillColor = color
        
        self.strokeColor = rootSegments.count > 1 ? .red : .brown.withAlphaComponent(0.3)
        // TODO: compute delta, add/remove textures for segments, animate frames
    }
}
