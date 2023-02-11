//
//  GameViewController.swift
//  how-does-your-garden-grow
//
//  Created by Adam Christopher Smith on 2/3/23.
//

import UIKit
import SpriteKit
import GameplayKit

enum GameMode {
    case puzzle
    case endless
}

class GameViewController: UIViewController, GameSceneDelegate {

    var skView: SKView!
    var scene: GameScene!
    var gameMode = GameMode.endless
    var levelNumber = 0
    var totalScore = 0

    var hasShownTutorial = false

    @IBOutlet weak var gameOverLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var startSeasonsButton: UIButton!
    @IBOutlet weak var startEndlessButton: UIButton!

    @IBAction func startSeasons(_ sender: Any) {
        levelNumber = 0
        startGame(nextGameMode: .puzzle)
    }

    @IBAction func startEndless(_ sender: Any) {
        startGame(nextGameMode: .endless)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        skView = view as? SKView
        startGame(nextGameMode: .endless)
    }

    func startGame(nextGameMode: GameMode) {
        gameMode = nextGameMode
        gameOverLabel.isHidden = true
        scoreLabel.isHidden = true

        startSeasonsButton?.isHidden = hasShownTutorial
        startEndlessButton?.isHidden = hasShownTutorial

        scene = GameScene(
            size: skView.frame.size,
            delegate: self,
            showTutorial: !hasShownTutorial,
            level: gameMode == .puzzle ? Level.levels[levelNumber] : nil
        )
        scene.scaleMode = .aspectFill
        scene.view?.ignoresSiblingOrder = true
        skView.presentScene(scene)
        hasShownTutorial = true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    func gameDidFinish(score: Int) {
        levelNumber += 1
        totalScore += score
        if gameMode == .puzzle && levelNumber < Level.levels.count {
            startGame(nextGameMode: .puzzle)
        } else {
            scene?.isPaused = true
            scoreLabel.text = "Total Score: \(totalScore)"
            totalScore = 0
            gameOverLabel.isHidden = false
            scoreLabel.isHidden = false
            startSeasonsButton.isHidden = false
            startEndlessButton.isHidden = false
        }
    }
}
