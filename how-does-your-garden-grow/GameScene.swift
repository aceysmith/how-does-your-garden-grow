//
//  GameScene.swift
//  how-does-your-garden-grow
//
//  Created by Adam Christopher Smith on 2/3/23.
//

import SpriteKit

let secondsPerTick = 0.2
let ticksPerPlant = 10

let horizontalTileCount = 24
let verticleTileCount = 7

class GameScene: SKScene {
    
    var tick = 0
    var score = 0
    var armPosition = 12
    var garden = Garden(horizonalTileCount: horizontalTileCount, verticalTileCount: verticleTileCount)
    var dirtGrid: DirtTileGrid!
    var plotArray: PlotTileArray!
    var arm: SKShapeNode!
    var hand: SKSpriteNode!
    
    var currentLevel = Level.spring()
    
    override func didMove(to view: SKView) {
        let tileWidth = Int(floor(view.frame.width / CGFloat(horizontalTileCount)))
        let dirtHeight = verticleTileCount * tileWidth
        let plantSize = CGSize(width: tileWidth, height: 2 * tileWidth)

        arm = SKShapeNode(rect: CGRect(origin: .zero, size: CGSize(width: 30, height: 1000)))
        arm.fillColor = .red
        arm.zPosition = 10
        addChild(arm)
        hand = SKSpriteNode(texture: nil, size: plantSize)
        hand.zPosition = 20
        arm.addChild(hand)
                
        plotArray = PlotTileArray(tileSize: plantSize, tileCount: horizontalTileCount)
        plotArray.position = CGPoint(x: (view.frame.width - CGFloat(horizontalTileCount * tileWidth)) / 2, y: CGFloat(dirtHeight))
        addChild(plotArray)
        
        dirtGrid = DirtTileGrid(
            tileWidth: tileWidth,
            horizonalTileCount: horizontalTileCount,
            verticalTileCount: verticleTileCount
        )
        dirtGrid.position = CGPoint(x: (view.frame.width - CGFloat(horizontalTileCount * tileWidth)) / 2, y: 0)
        addChild(dirtGrid)
        
        let background = Background(size: view.frame.size, dirtHeight: dirtHeight)
        background.zPosition = -1000
        addChild(background)

        moveArm(position: armPosition)
        loadHand(turn: 0)

        arm.run(.repeatForever(.sequence([
            .moveTo(y: view.frame.size.height + 100, duration: 0.1),
            .moveTo(y: CGFloat(dirtHeight), duration: Double(ticksPerPlant) * secondsPerTick - 0.1)
        ])))
        run(
            .repeatForever(.sequence([
                .wait(forDuration: secondsPerTick),
                .run({
                    self.update()
                })
            ]))
        )
    }
        
    func update() {
        let oldGarden = garden

        garden.grow()

        tick += 1

        if tick % ticksPerPlant == 0 {
            let turn = tick / ticksPerPlant
            loadHand(turn: turn + 1)
            if let plant = currentLevel.plantForTurn(turn: turn) {
                garden.addPlant(position: armPosition, plant: plant)
                moveArm(position: Int(arc4random()) % horizontalTileCount)
            }
        }

        displayGarden(oldGarden: oldGarden, newGarden: garden)
    }
    
    func displayGarden(oldGarden: Garden, newGarden: Garden) {
        plotArray.displayPlants(plants: newGarden.plantPlots)
        dirtGrid.displayPlants(plants: newGarden.plantPlots)
        // TODO: First pass, add some representation of whether root segments have grown at each tile
        // TODO: Actually animate plots with a big ol SKAction group sequence of all of the SKSpriteNodes
    }
    
    func loadHand(turn: Int) {
        if let nextPlant = currentLevel.plantForTurn(turn: turn) {
            hand.texture = SKTexture(imageNamed: "\(nextPlant.species.rawValue)_large")
        } else {
            hand.texture = nil
        }
    }
    
    func moveArm(position: Int) {
        armPosition = position
        arm.run(.moveTo(x: CGFloat((Double(position) / Double(horizontalTileCount))) * view!.frame.width, duration: 0.2))
    }
    
    func cutPlant(position: Int) {
        guard garden.plantPlots[position] != nil else { return }
        garden.removePlant(position: position)
    }
    
    func harvestPlant(position: Int) {
        guard let plant = garden.plantPlots[position] else { return }
        score += plant.award
        garden.removePlant(position: position)
    }
    
    //        let leftRoot = addRoot(initialSize: 0)
    //        leftRoot.position = CGPoint(x: view.frame.midX - 300, y: view.frame.midY)
    //        let midRoot = addRoot(initialSize: 1)
    //        midRoot.position = CGPoint(x: view.frame.midX - 100, y: view.frame.midY)
    //        let rightRoot = addRoot(initialSize: 2)
    //        rightRoot.position = CGPoint(x: view.frame.midX + 100, y: view.frame.midY)
    //
    //        addChild(leftRoot)
    //        addChild(midRoot)
    //        addChild(rightRoot)

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
        leftRoot.run(.animate(with: textures, timePerFrame: 5/CGFloat(frameCount)))
        return leftRoot
    }
}
