//
//  GameScene.swift
//  how-does-your-garden-grow
//
//  Created by Adam Christopher Smith on 2/3/23.
//

import SpriteKit
import Foundation

let secondsPerTick = 1.0

let horizontalTileCount = 20
let verticleTileCount = 10

class GameScene: SKScene {
    
    var tick = 0
    var garden = Garden(horizonalTileCount: horizontalTileCount, verticalTileCount: verticleTileCount)
    var dirtGrid: DirtGrid!
    
    override func didMove(to view: SKView) {
        dirtGrid = DirtGrid(
            tileWidth: Int(floor(view.frame.width / CGFloat(horizontalTileCount))),
            horizonalTileCount: horizontalTileCount,
            verticalTileCount: verticleTileCount
        )
        dirtGrid.position = CGPoint(x: 0, y: 200)
        addChild(dirtGrid)
        // TODO: Initialize all of the shape/texture nodes
        
        // TODO: Probably easier to have some time delta logic in `update(_ currentTime: TimeInterval)` instead of adding another timer here. &shrug;
        run(
            SKAction.repeatForever(.sequence([
                .wait(forDuration: secondsPerTick),
                .run({
                    self.update()
                })
            ]))
        )
    }
        
    func update() {
        // TODO: Answer: Should a new plant go down before or after the garden grows?
        // TODO: Use a level type object to look up which plants to add
        // TODO: Use the current column selection to determine which position to try to add the plant
        switch tick {
        case 10:
            garden.addPlant(position: 0, plant: .TallBoy())
            break
        case 20:
            garden.addPlant(position: 3, plant: .FighterJet())
            break
        default: break
        }

        let oldGarden = garden

        garden.grow()
        
        animateGarden(oldGarden: oldGarden, newGarden: garden)
        tick += 1
    }
    
    func animateGarden(oldGarden: Garden, newGarden: Garden) {
        // TODO: First pass, add some representation of whether root segments have grown at each tile
        // TODO: Actually animate plots with a big ol SKAction group sequence of all of the SKSpriteNodes
    }
    
//    let leftRoot = addRoot(initialSize: 0)
//    leftRoot.position = CGPoint(x: view.frame.midX - 300, y: view.frame.midY)
//    let midRoot = addRoot(initialSize: 1)
//    midRoot.position = CGPoint(x: view.frame.midX - 100, y: view.frame.midY)
//    let rightRoot = addRoot(initialSize: 2)
//    rightRoot.position = CGPoint(x: view.frame.midX + 100, y: view.frame.midY)
//
//    addChild(leftRoot)
//    addChild(midRoot)
//    addChild(rightRoot)
    
    func addRoot(initialSize: Double) -> SKSpriteNode {
        let bigLongRoot = SKTexture(imageNamed: "bigRoot")
        let bigLongRootSize = bigLongRoot.size()
        let width = bigLongRootSize.width
        let height = bigLongRootSize.height
        let tileCount = width / height
        let leftRoot = SKSpriteNode(
            texture: SKTexture(
                rect: CGRect(
                    x: 0,
                    y: 0,
                    width: 1 / tileCount,
                    height: 1
                ),
                in: bigLongRoot
            )
        )
        
        var textures: [SKTexture] = []
        let frameCount = 300
        for i in 0..<frameCount {
            let leftPercentage = initialSize / (width / height)
            textures.append(SKTexture(
                rect: CGRect(
                    x: min(width - height, (leftPercentage * width) + (CGFloat(i) / CGFloat(frameCount) * (width - height))) / width,
                    y: 0,
                    width: 1 / tileCount,
                    height: 1
                ),
                in: bigLongRoot
            ))
        }
        
        let crop = SKCropNode()
        crop.maskNode = SKSpriteNode(imageNamed: "upperLeftFilled")
        crop.addChild(leftRoot)
        leftRoot.position = CGPoint(x: view!.frame.midX, y: view!.frame.midY)
        leftRoot.run(SKAction.animate(with: textures, timePerFrame: 1/CGFloat(frameCount)))
        return leftRoot
    }
}
