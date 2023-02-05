//
//  GameViewController.swift
//  how-does-your-garden-grow
//
//  Created by Adam Christopher Smith on 2/3/23.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    @IBAction func restart(_ sender: Any) {
        presentScene()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presentScene()
    }

    func presentScene() {
        let view = self.view as! SKView
        let scene = GameScene(size: view.frame.size)
        scene.scaleMode = .aspectFill
        scene.view?.ignoresSiblingOrder = true
        view.presentScene(scene)
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
}
