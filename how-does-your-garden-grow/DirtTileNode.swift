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
    private let displayPreview: Bool
    init(size: CGSize, displayPreview: Bool) {
        self.displayPreview = displayPreview
        super.init()
        self.size = size
        self.path = CGPath(
            rect: CGRect(
                origin: .zero,
                size: CGSize(width: size.width, height: size.height)
            ),
            transform: nil
        )
        self.fillColor = .clear
        self.strokeColor = UIColor(red: 0.6, green: 0.4, blue: 0.2, alpha: 1.0)
    }
    required init?(coder aDecoder: NSCoder) { return nil }

    func displayRootSegments(rootSegments: [RootSegment]) {
        if spriteNodes.count < rootSegments.count {
            for _ in spriteNodes.count..<rootSegments.count {
                let spriteNode = SKSpriteNode(texture: nil, size: size)
                spriteNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
                spriteNode.colorBlendFactor = 1
                addChild(spriteNode)
                spriteNodes.append(spriteNode)
            }
        } else if rootSegments.count < spriteNodes.count {
            for i in rootSegments.count..<spriteNodes.count {
                spriteNodes[i].texture = nil
                spriteNodes[i].isHidden = true
            }
        }

        for (i, rootSegment) in rootSegments.enumerated() {
            let spriteNode = spriteNodes[i]
            if !displayPreview && !rootSegment.grown {
                spriteNode.texture = nil
                spriteNode.isHidden = true
                continue
            }
            var leftGrown: Bool = false
            var rightGrown: Bool = false
            var upGrown: Bool = false
            var downGrown: Bool = false

            if displayPreview {
                leftGrown   = rootSegment.left != nil || rootSegment.parentDirection == .left
                rightGrown  = rootSegment.right != nil || rootSegment.parentDirection == .right
                upGrown     = rootSegment.up != nil || rootSegment.parentDirection == .up
                downGrown   = rootSegment.down != nil || rootSegment.parentDirection == .down
            } else {
                leftGrown   = (rootSegment.left?.grown ?? false)  || (rootSegment.parentDirection == .left && rootSegment.grown)
                rightGrown  = (rootSegment.right?.grown ?? false) || (rootSegment.parentDirection == .right && rootSegment.grown)
                upGrown     = (rootSegment.up?.grown ?? false)    || (rootSegment.parentDirection == .up && rootSegment.grown)
                downGrown   = (rootSegment.down?.grown ?? false)  || (rootSegment.parentDirection == .down && rootSegment.grown)
            }
            
            var texture: SKTexture? = nil
            if let (imageName, zRotation) = computeDrawParams(left: leftGrown, right: rightGrown, up: upGrown, down: downGrown) {
                texture = SKTexture(imageNamed: imageName)
                spriteNode.zRotation = zRotation
            }
            spriteNode.color = UIColor(hue: rootSegment.hue, saturation: 0.9, brightness: 0.5, alpha: displayPreview ? 0.3 : 1)
            spriteNode.texture = texture
            spriteNode.isHidden = false
        }

        self.fillColor = rootSegments.count > 1 ? .red.withAlphaComponent(0.1) : .clear
    }
    
    func computeDrawParams(left: Bool, right: Bool, up: Bool, down: Bool) -> (String, CGFloat)? {
        if left && !right && !up && !down {
            return ("line_tip", .pi / 2)
        }
        if !left && right && !up && !down {
            return ("line_tip", -.pi / 2)
        }
        if !left && !right && up && !down {
            return ("line_tip", 0)
        }
        if !left && !right && !up && down {
            return ("line_tip", .pi)
        }


        if !left && !right && up && down {
            return ("line_straight", 0)
        }
        if left && right && !up && !down {
            return ("line_straight", .pi / 2)
        }

        
        if !left && right && up && !down {
            return ("line_corner", 0)
        }
        if !left && right && !up && down {
            return ("line_corner", -.pi / 2)
        }
        if left && !right && !up && down {
            return ("line_corner", .pi)
        }
        if left && !right && up && !down {
            return ("line_corner", .pi / 2)
        }

        
        if !left && right && up && down {
            return ("line_3_way", 0)
        }
        if left && !right && up && down {
            return ("line_3_way", .pi)
        }
        if left && right && !up && down {
            return ("line_3_way", -.pi / 2)
        }
        if left && right && up && !down {
            return ("line_3_way", .pi / 2)
        }

        if left && right && up && down {
            return ("line_4_way", 0)
        }
        return nil
    }
}
