//
//  GameScene.swift
//  Wave Shared
//
//  Created by Breno on 24/12/20.
//

import SpriteKit
import AudioToolbox

class GameScene: SKScene, SKPhysicsContactDelegate {
  
  fileprivate var godMode: Bool = false
  fileprivate var easyMode: Bool = false
  fileprivate var upperSine: Sine?
  fileprivate var lowerSine: Sine?
  fileprivate var scoreLabel: SKLabelNode?
  fileprivate var circle: Circle?
  fileprivate var counter: Double = 0
  fileprivate var increment: Int = 1
  fileprivate var began: Bool = false
  fileprivate var ended: Bool = false
  fileprivate var startTime: TimeInterval?
  fileprivate var currentTime: TimeInterval?
  fileprivate var touching: Bool = false
  fileprivate var impulse: CGVector = CGVector(dx: 0, dy: 5)
  fileprivate var defaults: UserDefaults = UserDefaults.standard
  
  var primaryColor: Color = .white
  var secondaryColor: Color = .black
  
  class func newGameScene() -> GameScene {
    // Load 'GameScene.sks' as an SKScene.
    guard let scene = SKScene(fileNamed: "GameScene") as? GameScene else {
      print("Failed to load GameScene.sks")
      abort()
    }
    
    // Set the scale mode to scale to fit the window
    scene.scaleMode = .aspectFill
    
    return scene
  }
  
  func randomColors() {
    let shuffledPairs = colorData.pairs.shuffled()
    if shuffledPairs.count < 1 {
      return
    }
    if shuffledPairs.first!.count != 2 {
      return
    }
    
    let primaryColor = shuffledPairs.first![0]
    let secondaryColor = shuffledPairs.first![1]
    
    self.primaryColor = colorData.colors[primaryColor]!
    self.secondaryColor = colorData.colors[secondaryColor]!
    
    defaults.set(primaryColor, forKey: "Primary Color")
    defaults.set(secondaryColor, forKey: "Secondary Color")
  }
  
  func setUpScene() {
    
    let random = Double.random(in: 0..<1)
    if random <= 0.2 {
      easyMode = true
      print("easy mode")
    }
    
    if !defaults.bool(forKey: "Not First Launch") {
      print("first launch")
      defaults.set(true, forKey: "Not First Launch")
      easyMode = true
    }
    
    if let primaryColor = defaults.string(forKey: "Primary Color"),
       let color = colorData.colors[primaryColor]
    {
      self.primaryColor = color
    } else {
      self.primaryColor = .white
      defaults.set("White", forKey: "Primary Color")
    }
    
    if let secondaryColor = defaults.string(forKey: "Secondary Color"),
       let color = colorData.colors[secondaryColor]
    {
      self.secondaryColor = color
    } else {
      self.secondaryColor = .black
      defaults.set("Black", forKey: "Secondary Color")
    }
    
    randomColors()
    
    physicsWorld.contactDelegate = self
    
    scoreLabel = SKLabelNode(fontNamed: "Avenir")
    scoreLabel?.fontSize = 30
    scoreLabel?.text = "0.00"
    scoreLabel?.fontColor = primaryColor
    scoreLabel?.position = CGPoint(x: frame.midX, y: frame.midY + size.height / 3.0)
    addChild(scoreLabel!)
    
    backgroundColor = secondaryColor
    upperSine = Sine(width: size.width, height: size.height, color: primaryColor, position: CGPoint(x: frame.midX, y: frame.midY + size.height / 3.0))
    lowerSine = Sine(width: size.width, height: size.height, color: primaryColor, position: CGPoint(x: frame.midX, y: frame.midY - size.height / 3.0))
    
    addChild(upperSine!)
    addChild(lowerSine!)
    
    circle = Circle(color: primaryColor, position: CGPoint(x: frame.midX / 3.0, y: frame.midY))
    addChild(circle!)
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
    self.currentTime = currentTime
    if began && !ended {
      let yDec: CGFloat = easyMode ? 0.05 * sin(CGFloat(counter) / (240 * CGFloat.pi)) : 0.1 * sin(CGFloat(counter) / (240 * CGFloat.pi))
      upperSine!.update(counter)
      lowerSine!.update(counter)
      upperSine!.position.y -= yDec
      lowerSine!.position.y += yDec
      
      if startTime == nil {
        startTime = currentTime
      }
    }
    
    if began && touching && !ended {
      circle?.applyImpulse(impulse)
    }
    
    updateCounter()
  }
  
  func updateCounter() {
    guard let t0 = startTime else {
      return
    }
    
    guard let t1 = currentTime else {
      return
    }
    
    let delta = t1 - t0
    
    if !ended {
      scoreLabel?.text = String(format: "%.2f", delta)
    }
    
    let x: Double = 60 * delta
    // counter = easyMode ? pow(x, 1.10) + pow(5 * sin(delta), 2) : pow(x, 1.15) + pow(5 * sin(delta), 2)
    counter = easyMode ? pow(x, 1.12) : pow(x, 1.15)
  }
  
  func didBegin(_ contact: SKPhysicsContact) {
    if godMode {
      return
    }
    ended = true
    circle?.toggleGravity()
    circle?.toggleDynamic()
    let point = SKShapeNode(circleOfRadius: 5.0)
    point.fillColor = primaryColor
    point.position = circle!.position
    addChild(point)
    
    let scaleAction = SKAction.scale(to: 500, duration: 0.3)
    scaleAction.timingMode = .easeInEaseOut
    
    #if os(iOS)
    let generator = UIImpactFeedbackGenerator(style: .heavy)
    generator.impactOccurred()
    #endif
    
    let endAction = SKAction.run() { [weak self] in
      guard let `self` = self else { return }
      let gameOverScene = GameOverScene(size: self.size,
                                        time: self.currentTime! - self.startTime!,
                                        primaryColor: self.primaryColor,
                                        secondaryColor: self.secondaryColor)
      gameOverScene.scaleMode = .aspectFill
      self.view?.presentScene(gameOverScene)
    }
    
    point.run(SKAction.sequence([scaleAction, endAction]))
  }
}

#if os(iOS) || os(tvOS)
// Touch-based event handling
extension GameScene {
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    touching = true
    let generator = UIImpactFeedbackGenerator(style: .light)
    generator.impactOccurred()
    for _ in touches {
      if !began {
        began = true
        circle?.toggleGravity()
      }
    }
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    touching = false
  }
  
  override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
  }
  
  
}
#endif

#if os(OSX)
// Mouse-based event handling
extension GameScene {
  
  override func mouseDown(with event: NSEvent) {
    touching = true
    if !began {
      began = true
      circle?.toggleGravity()
    }
  }
  
  override func mouseDragged(with event: NSEvent) {
    //        self.makeSpinny(at: event.location(in: self), color: SKColor.blue)
  }
  
  override func mouseUp(with event: NSEvent) {
    touching = false
  }
  
}
#endif

