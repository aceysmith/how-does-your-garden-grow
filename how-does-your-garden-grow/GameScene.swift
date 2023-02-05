//
//  GameScene.swift
//  how-does-your-garden-grow
//
//  Created by Adam Christopher Smith on 2/3/23.
//

import SpriteKit

let secondsPerTick = 3.0
let ticksPerPlant = 2

let horizontalTileCount = 18
let verticleTileCount = 7

enum Layer: CGFloat {
    case background = -100
    case dirt = -20
    case sky = -10
    case player = 10
}

class GameScene: SKScene {
    
    var tick = 0
    var score = 0
    var playerPosition = 12
    var garden = Garden(horizonalTileCount: horizontalTileCount, verticalTileCount: verticleTileCount)
    var dirtGrid: DirtTileGrid!
    var plotArray: PlotTileArray!
    var player: Player!
    var scoreLabel: SKLabelNode!
    
    var currentLevel = Level.spring()
    
    var dirtInset: CGFloat = .zero
    var dirtHeight: CGFloat = .zero
    var tileWidth: CGFloat = .zero
    
    override func didMove(to view: SKView) {
        tileWidth = floor(view.frame.width / CGFloat(horizontalTileCount))
        dirtInset = (view.frame.width - (tileWidth * CGFloat(horizontalTileCount))) / 2
        dirtHeight = CGFloat(verticleTileCount) * tileWidth
        let plantSize = CGSize(width: tileWidth, height: 2 * tileWidth)

        player = Player(size: CGSize(width: 100, height: 500), plantSize: plantSize)
        player.anchorPoint = CGPoint(x: 0.5, y: 0)
        player.position = CGPoint(x: xPosForPosition(position: playerPosition), y: view.frame.height)
        addChild(player)
                
        plotArray = PlotTileArray(tileSize: plantSize, tileCount: horizontalTileCount)
        plotArray.position = CGPoint(x: (view.frame.width - (CGFloat(horizontalTileCount) * tileWidth)) / 2, y: CGFloat(dirtHeight))
        addChild(plotArray)
        
        dirtGrid = DirtTileGrid(
            tileWidth: Int(tileWidth),
            horizonalTileCount: horizontalTileCount,
            verticalTileCount: verticleTileCount
        )
        dirtGrid.position = CGPoint(x: (view.frame.width - (CGFloat(horizontalTileCount) * tileWidth)) / 2, y: 0)
        addChild(dirtGrid)
        
        let background = Background(size: view.frame.size, dirtHeight: Int(dirtHeight))
        background.zPosition = -1000
        addChild(background)

        scoreLabel = SKLabelNode(text: "Score \(score)")
        scoreLabel.position = CGPoint(x: view.frame.maxX - 100, y: view.frame.maxY - 50)
        addChild(scoreLabel)
        
        update()

        run(
            .repeatForever(
                .sequence([
                    .wait(forDuration: secondsPerTick),
                    .run({ [self] in
                        update()
                    })
                ])
            )
        )
    }
        
    func update() {
        garden.grow()

        if tick % ticksPerPlant == 0 {
            let turn = tick / ticksPerPlant
            let turnDuration = Double(ticksPerPlant) * secondsPerTick
            if let nextPlant = currentLevel.plantForTurn(turn: turn) {
                player.holdPlantSpecies(plantSpecies: nextPlant.species)
                player.run(.sequence([
                    .moveTo(y: CGFloat(dirtHeight), duration: 0.85 * turnDuration),
                    .run({ [self] in
                        garden.addPlant(position: playerPosition, plant: nextPlant)
                        player.holdPlantSpecies(plantSpecies: nil)
                        redisplay()
                    }),
                    .moveTo(y: view!.frame.size.height, duration: 0.15 * turnDuration),
                ]))
            }
        }
        tick += 1
        redisplay()
    }
    
    func redisplay() {
        plotArray.displayPlants(plants: garden.plantPlots)
        dirtGrid.displayPlants(plants: garden.plantPlots)
    }
    
    func xPosForPosition(position: Int) -> CGFloat {
        return dirtInset + (tileWidth / 2) + (CGFloat(position) * tileWidth)
    }
    
    func positionForXPos(xPos: CGFloat) -> Int {
        return min(
            max(
                Int((xPos - dirtInset) / tileWidth),
                0
            ),
            horizontalTileCount - 1
        )
    }
    
    func cutPlant(position: Int) {
        guard garden.plantPlots[position] != nil else { return }
        garden.removePlant(position: position)
        redisplay()
    }
    
    func harvestPlant(position: Int) {
        guard let plant = garden.plantPlots[position] else { return }
        score += plant.award
        scoreLabel.text = "Score: \(score)"
        garden.removePlant(position: position)
        redisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchLocation = touches.first!.location(in: scene!)
        let position = positionForXPos(xPos: touchLocation.x)
        
        let touchedAPlot = scene?.nodes(at: touchLocation).contains(where: { node in
            return node is PlotTile
        }) ?? false
        if touchedAPlot {
            if let plant = garden.plantPlots[position], plant.grownRootSegments == plant.rootSegments {
                harvestPlant(position: position)
            } else {
                cutPlant(position: position)
            }
        } else {
            playerPosition = position
            player.run(
                .moveTo(
                    x: xPosForPosition(position: position),
                    duration: 0.2
                )
            )
        }
    }
    
    func addRoot(initialSize: Double) -> SKSpriteNode {
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
