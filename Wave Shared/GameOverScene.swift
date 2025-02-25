//
//  GameOverScene.swift
//  Wave
//
//  Created by Breno on 25/12/20.
//

import SpriteKit

class GameOverScene: SKScene {
  
  private var touched: Bool = false
  var primaryColor: Color = .black
  var secondaryColor: Color = .white
  
  init(size: CGSize, time: TimeInterval, primaryColor: Color, secondaryColor: Color) {
    super.init(size: size)
    
    self.primaryColor = primaryColor
    self.secondaryColor = secondaryColor
    
    backgroundColor = primaryColor
    
    let label = SKLabelNode(fontNamed: "Avenir")
    label.text = String(format: "%.2f", time)
    label.fontSize = 50
    label.fontColor = secondaryColor
    label.position = CGPoint(x: size.width / 2.0, y: size.height / 2.0)
    addChild(label)
  }
  
  required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setUpScene() {
  }
  
  #if os(watchOS)
  override func sceneDidLoad() {
    self.setUpScene()
  }
  #else
  override func didMove(to view: SKView) {
    self.setUpScene()
  }
  #endif
  
  override func update(_ currentTime: TimeInterval) {
    if touched {
      let action = SKAction.run() { [weak self] in
        guard let `self` = self else { return }
        let transition = SKTransition.doorsCloseHorizontal(withDuration: 0.5)
        let gameScene = GameScene(size: self.size)
        gameScene.primaryColor = self.primaryColor
        gameScene.secondaryColor = self.secondaryColor
        gameScene.scaleMode = .aspectFill
        self.view?.presentScene(gameScene, transition: transition)
      }
      run(action)
    }
  }
}

#if os(iOS) || os(tvOS)
// Touch-based event handling
extension GameOverScene {
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    touched = true
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    for t in touches {
    }
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    for t in touches {
    }
  }
  
  override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    for t in touches {
    }
  }
  
  
}
#endif

#if os(OSX)
// Mouse-based event handling
extension GameOverScene {
  
  override func mouseDown(with event: NSEvent) {
    touched = true
  }
  
  override func mouseDragged(with event: NSEvent) {
    //        self.makeSpinny(at: event.location(in: self), color: SKColor.blue)
  }
  
  override func mouseUp(with event: NSEvent) {
    //        self.makeSpinny(at: event.location(in: self), color: SKColor.red)
  }
  
}
#endif

