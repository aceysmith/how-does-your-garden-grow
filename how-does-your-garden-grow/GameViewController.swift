//
//  GameViewController.swift
//  how-does-your-garden-grow
//
//  Created by Adam Christopher Smith on 2/3/23.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController, GameSceneDelegate {

    var skView: SKView!
    var scene: GameScene?
    var levelNumber = 0
    var totalScore = 0
    var started = false
    
    @IBOutlet weak var gameOverLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var restartButton: UIButton!
    @IBAction func restart(_ sender: Any) {
        levelNumber = 0
        gameOverLabel.isHidden = true
        scoreLabel.isHidden = true
        restartButton.isHidden = true
        presentScene()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        skView = view as? SKView
        presentScene()
    }

    func presentScene() {
        let scene = GameScene(size: skView.frame.size)
        scene.gameSceneDelegate = self
        scene.level = Level.levels[levelNumber]
        scene.levelNumber = levelNumber
        scene.started = started
        scene.scaleMode = .aspectFill
        scene.view?.ignoresSiblingOrder = true
        skView.presentScene(scene)
        self.scene = scene
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
    
    func gameDidStart(_ started: Bool) {
        self.started = started
    }
    
    func gameDidFinish(score: Int) {
        levelNumber += 1
        totalScore += score
        if levelNumber < Level.levels.count {
            presentScene()
        } else {
            started = false
            scene?.isPaused = true
            scoreLabel.text = "Total Score: \(totalScore)"
            gameOverLabel.isHidden = false
            scoreLabel.isHidden = false
            restartButton.isHidden = false
            print(totalScore)
        }
    }
}
