//
//  GameScene.swift
//  how-does-your-garden-grow
//
//  Created by Adam Christopher Smith on 2/3/23.
//

import SpriteKit

let secondsPerTick = 2.0
let ticksPerPlant = 2

let horizontalTileCount = 17
let verticleTileCount = 6

let uiFont = "HelveticaNeue-Bold"

enum Layer: CGFloat {
    case skyBackground
    case glow
    case dirtBackground
    case dirtPreview
    case dirtRoot
    case player
    case hand
    case plants
    case plantsPreview
    case ui
}

protocol GameSceneDelegate {
    func gameDidFinish(score: Int)
}

class GameScene: SKScene {
    // Object Properties
    let gameSceneDelegate: GameSceneDelegate?
    let level: Level?
    let gameMode: GameMode
    let showTutorial: Bool

    // Game State
    var garden = Garden(horizonalTileCount: horizontalTileCount, verticalTileCount: verticleTileCount)
    var nextPlant: Plant?
    var playerPosition = 8
    var plantHeld: Bool = false
    var score = 0
    var tick = 0
    var lives = 5

    // Scene state
    var lastTime: TimeInterval = 0

    // Display nodes
    var dirtGrid: DirtTileGridNode!
    var dirtGridPreview: DirtTileGridNode!
    var plotArray: PlotTileArrayNode!
    var plotArrayPreview: PlotTileArrayNode!
    var player: PlayerNode!

    // UI
    var levelLabel: SKLabelNode!
    var livesLabel: SKLabelNode!
    var scoreLabel: SKLabelNode!
    var titleLabel: SKSpriteNode!
    var helpLabel: SKLabelNode!

    // Computed layout properties
    var dirtInset: CGFloat = .zero
    var dirtHeight: CGFloat = .zero
    var tileWidth: CGFloat = .zero

    init(size: CGSize, delegate: GameSceneDelegate, showTutorial: Bool, level: Level?) {
        self.gameSceneDelegate = delegate
        self.level = level
        self.showTutorial = showTutorial
        self.gameMode = level == nil ? .endless : .puzzle
        super.init(size: size)
    }
    required init?(coder aDecoder: NSCoder) { return nil }

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

        plotArray = PlotTileArrayNode(
            displayPreview: false,
            tileSize: plantSize,
            tileCount: horizontalTileCount
        )
        plotArray.position = CGPoint(x: (view.frame.width - (CGFloat(horizontalTileCount) * tileWidth)) / 2, y: CGFloat(dirtHeight))
        addChild(plotArray)

        plotArrayPreview = PlotTileArrayNode(
            displayPreview: true,
            tileSize: plantSize,
            tileCount: horizontalTileCount
        )
        plotArrayPreview.position = CGPoint(x: (view.frame.width - (CGFloat(horizontalTileCount) * tileWidth)) / 2, y: CGFloat(dirtHeight))
        addChild(plotArrayPreview)

        dirtGrid = DirtTileGridNode(
            displayPreview: false,
            tileWidth: Int(tileWidth),
            horizonalTileCount: horizontalTileCount,
            verticalTileCount: verticleTileCount
        )
        dirtGrid.position = CGPoint(x: (view.frame.width - (CGFloat(horizontalTileCount) * tileWidth)) / 2, y: 0)
        addChild(dirtGrid)

        dirtGridPreview = DirtTileGridNode(
            displayPreview: true,
            tileWidth: Int(tileWidth),
            horizonalTileCount: horizontalTileCount,
            verticalTileCount: verticleTileCount
        )
        dirtGridPreview.position = CGPoint(x: (view.frame.width - (CGFloat(horizontalTileCount) * tileWidth)) / 2, y: 0)
        addChild(dirtGridPreview)

        let background = BackgroundNode(size: view.frame.size, dirtHeight: Int(dirtHeight))
        background.zPosition = -1000
        addChild(background)

        if showTutorial {
            titleLabel = SKSpriteNode(imageNamed: "title")
            titleLabel.zPosition = Layer.ui.rawValue
            titleLabel.xScale = 0.75
            titleLabel.position = CGPoint(x: frame.midX, y: frame.midY)
            addChild(titleLabel)

            helpLabel = SKLabelNode(text: "Tap to Plant, Pull and Harvest! Tap to Start >")
            helpLabel.fontSize = 40
            helpLabel.fontName = uiFont
            helpLabel.horizontalAlignmentMode = .center
            helpLabel.verticalAlignmentMode = .center
            helpLabel.position = CGPoint(x: titleLabel.frame.midX, y: titleLabel.frame.minY - 50)
            helpLabel.zPosition = Layer.ui.rawValue
            addChild(helpLabel)

            isPaused = true
        }

        scoreLabel = SKLabelNode(text: "Score: \(score)")
        scoreLabel.fontName = uiFont
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.verticalAlignmentMode = .center
        scoreLabel.position = CGPoint(x: frame.maxX - 50, y: frame.maxY - 50)
        scoreLabel.zPosition = Layer.ui.rawValue
        scoreLabel.isHidden = showTutorial
        addChild(scoreLabel)

        if gameMode == .puzzle, let level = level {
            levelLabel = SKLabelNode(text: "Level: \(level.name)")
            levelLabel.fontName = uiFont
            levelLabel.horizontalAlignmentMode = .left
            levelLabel.verticalAlignmentMode = .center
            levelLabel.position = CGPoint(x: frame.minX + 50, y: frame.maxY - 50)
            levelLabel.zPosition = Layer.ui.rawValue
            levelLabel.isHidden = showTutorial
            addChild(levelLabel)
        } else {
            livesLabel = SKLabelNode(text: "Lives: ")
            livesLabel.fontName = uiFont
            livesLabel.horizontalAlignmentMode = .left
            livesLabel.verticalAlignmentMode = .center
            livesLabel.position = CGPoint(x: frame.minX + 50, y: frame.maxY - 50)
            livesLabel.zPosition = Layer.ui.rawValue
            livesLabel.isHidden = showTutorial
            updateLivesLabel(lives: lives)
            addChild(livesLabel)
        }
    }

    override func update(_ currentTime: TimeInterval) {
        if (currentTime - lastTime) <= secondsPerTick {
            return
        }
        lastTime = currentTime

        garden.grow()

        if tick % ticksPerPlant == 0 {
            let turn = tick / ticksPerPlant
            let turnDuration = Double(ticksPerPlant) * secondsPerTick

            if let level {
                nextPlant = level.plantForTurn(turn: turn)
            } else {
                nextPlant = Plant.randomPlant()
            }
            if let nextPlant {
                player.holdPlantSpecies(plantSpecies: nextPlant.species)
                plantHeld = true
                player.run(.sequence([
                    .moveTo(y: CGFloat(dirtHeight), duration: 0.85 * turnDuration),
                    .run({ [self] in
                        if garden.plantPlots[playerPosition] == nil {
                            garden.addPlant(position: playerPosition, plant: nextPlant)
                        } else if gameMode == .endless {
                            deductLives()
                        }
                        player.holdPlantSpecies(plantSpecies: nil)
                        plantHeld = false
                        redisplay()
                    }),
                    .moveTo(y: view!.frame.size.height + 50, duration: 0.15 * turnDuration),
                ]))
            } else if !garden.plantPlots.contains(where: { plant in plant != nil }) {
                gameSceneDelegate?.gameDidFinish(score: score)
            }
        }
        tick += 1
        redisplay()
    }

    func redisplay() {
        let plants = garden.plantPlots
        plotArray.displayPlants(plants: plants)
        dirtGrid.displayPlants(plants: plants)

        var plotPreviewPlants = [Plant?](repeating: nil, count: horizontalTileCount)
        if plantHeld {
            plotPreviewPlants[playerPosition] = nextPlant
            plotPreviewPlants[playerPosition]?.stunted = plants[playerPosition] != nil
        }
        plotArrayPreview.displayPlants(plants: plotPreviewPlants)

        var gridPreviewPlants = plants
        if plantHeld && plants[playerPosition] == nil {
            gridPreviewPlants[playerPosition] = nextPlant
        }
        dirtGridPreview.displayPlants(plants: gridPreviewPlants)
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

    func deductLives() {
        guard lives > 0 else {
            gameSceneDelegate?.gameDidFinish(score: score)
            return
        }
        lives -= 1

        updateLivesLabel(lives: lives)
    }

    func updateLivesLabel(lives: Int) {
        var livesText = "Lives: "
        for _ in 0..<(max(0, lives)) {
            livesText.append("🌱")
        }
        livesLabel.text = livesText
    }

    func cutPlant(position: Int) {
        if gameMode == .endless {
            if lives > 0 {
                deductLives()
            } else {
                return
            }
        }
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
        if isPaused {
            titleLabel?.isHidden = true
            helpLabel?.isHidden = true
            scoreLabel?.isHidden = false
            levelLabel?.isHidden = false
            livesLabel?.isHidden = false
            isPaused = false
            return
        }

        let touchLocation = touches.first!.location(in: scene!)
        let position = positionForXPos(xPos: touchLocation.x)

        let touchedAPlot = scene?.nodes(at: touchLocation).contains(where: { node in
            return node is PlotTileNode
        }) ?? false
        if touchedAPlot, let touchedPlant = garden.plantPlots[position] {
            if touchedPlant.grownRootSegments == touchedPlant.rootSegments {
                harvestPlant(position: position)
                return
            } else if touchedPlant.stunted {
                cutPlant(position: position)
                return
            }
        }
        if playerPosition != position {
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

