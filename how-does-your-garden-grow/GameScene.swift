//
//  GameScene.swift
//  how-does-your-garden-grow
//
//  Created by Adam Christopher Smith on 2/3/23.
//

import SpriteKit

let secondsPerTick = 1.0
let ticksPerPlant = 2

let horizontalTileCount = 17
let verticleTileCount = 6

enum Layer: CGFloat {
    case sky
    case glow
    case dirt
    case dirtPreview
    case dirtRoot
    case player
    case hand
    case plants
    case ui
}

protocol GameSceneDelegate {
    func gameDidFinish(score: Int)
}

class GameScene: SKScene {
    var gameSceneDelegate: GameSceneDelegate?
    var level: Level = .spring()
    
    var tick = 0
    var score = 0
    var playerPosition = 8
    var nextPlant: Plant?
    var garden = Garden(horizonalTileCount: horizontalTileCount, verticalTileCount: verticleTileCount)
    var dirtGrid: DirtTileGridNode!
    var plotArray: PlotTileArrayNode!
    var player: PlayerNode!
    var scoreLabel: SKLabelNode!
    
    var dirtInset: CGFloat = .zero
    var dirtHeight: CGFloat = .zero
    var tileWidth: CGFloat = .zero
    
    override func didMove(to view: SKView) {
        tileWidth = floor(view.frame.width / CGFloat(horizontalTileCount))
        dirtInset = (view.frame.width - (tileWidth * CGFloat(horizontalTileCount))) / 2
        dirtHeight = CGFloat(verticleTileCount) * tileWidth
        let plantSize = CGSize(width: tileWidth, height: 2 * tileWidth)

        player = PlayerNode(size: CGSize(width: 100, height: 500), plantSize: plantSize)
        player.anchorPoint = CGPoint(x: 0.5, y: 0)
        player.position = CGPoint(x: xPosForPosition(position: playerPosition), y: view.frame.height)
        player.zPosition = Layer.player.rawValue
        addChild(player)
                
        plotArray = PlotTileArrayNode(tileSize: plantSize, tileCount: horizontalTileCount)
        plotArray.position = CGPoint(x: (view.frame.width - (CGFloat(horizontalTileCount) * tileWidth)) / 2, y: CGFloat(dirtHeight))
        addChild(plotArray)
        
        dirtGrid = DirtTileGridNode(
            tileWidth: Int(tileWidth),
            horizonalTileCount: horizontalTileCount,
            verticalTileCount: verticleTileCount
        )
        dirtGrid.position = CGPoint(x: (view.frame.width - (CGFloat(horizontalTileCount) * tileWidth)) / 2, y: 0)
        addChild(dirtGrid)
        
        let background = BackgroundNode(size: view.frame.size, dirtHeight: Int(dirtHeight))
        background.zPosition = -1000
        addChild(background)

        scoreLabel = SKLabelNode(text: "Score \(score)")
        scoreLabel.position = CGPoint(x: view.frame.maxX - 100, y: view.frame.maxY - 50)
        scoreLabel.zPosition = Layer.ui.rawValue
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
            nextPlant = level.plantForTurn(turn: turn)
            if let nextPlant {
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
            } else if !garden.plantPlots.contains(where: { plant in plant != nil }) {
                gameSceneDelegate?.gameDidFinish(score: score)
            }
        }
        tick += 1
        redisplay()
    }
    
    func redisplay() {
        var plants = garden.plantPlots
        if plants[playerPosition] == nil, nextPlant != nil {
            plants[playerPosition] = nextPlant
        }
        plotArray.displayPlants(plants: plants)
        dirtGrid.displayPlants(plants: plants)
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
            return node is PlotTileNode
        }) ?? false
        if touchedAPlot, let touchedPlant = garden.plantPlots[position] {
            if touchedPlant.grownRootSegments == touchedPlant.rootSegments {
                harvestPlant(position: position)
            } else if touchedPlant.stunted {
                cutPlant(position: position)
            }
        } else if playerPosition != position {
            playerPosition = position
            redisplay()
            player.run(
                .moveTo(
                    x: xPosForPosition(position: position),
                    duration: 0.2
                )
            )
        }
    }
}
