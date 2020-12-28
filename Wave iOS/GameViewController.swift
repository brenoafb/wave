//
//  GameViewController.swift
//  Wave iOS
//
//  Created by Breno on 24/12/20.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // let scene = GameScene.newGameScene()
    let scene = GameScene(size: view.bounds.size)
    scene.scaleMode = .aspectFill
    // Present the scene
    let skView = self.view as! SKView
    skView.presentScene(scene)
    
    skView.ignoresSiblingOrder = true
    skView.showsFPS = false
    skView.showsNodeCount = false
  }
  
  override var shouldAutorotate: Bool {
    return true
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
