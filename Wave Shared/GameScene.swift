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
    
    var primaryColor: UIColor = uiColors["White"]!
    var secondaryColor: UIColor = uiColors["Black"]!
    
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
    
    func setUpScene() {
        physicsWorld.contactDelegate = self
        
        let width: CGFloat = size.width
        let height: CGFloat = size.height

        scoreLabel = SKLabelNode(fontNamed: "Avenir")
        scoreLabel?.fontSize = 20
        scoreLabel?.text = "0.00"
        scoreLabel?.fontColor = primaryColor
        scoreLabel?.position = CGPoint(x: frame.midX, y: frame.midY + height / 3.0)
        addChild(scoreLabel!)
        
        backgroundColor = secondaryColor
        upperSine = Sine(width: width, height: height, color: primaryColor, position: CGPoint(x: frame.midX, y: frame.midY + height / 3.0))
        lowerSine = Sine(width: width, height: height, color: primaryColor, position: CGPoint(x: frame.midX, y: frame.midY - height / 3.0))
        
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
            let yDec: CGFloat = 0.1 * sin(CGFloat(counter) / (240 * CGFloat.pi))
//            if upperSine!.position.y - lowerSine!.position.y > 5 * circle!.radius {
//                yDec = 0.05
//            }
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
        counter = pow(x, 1.15) + pow(5 * sin(delta), 2)
        print(counter)
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
            
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
        
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
        for t in touches {
            if !began {
                began = true
                circle?.toggleGravity()
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touching = false
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
extension GameScene {

    override func mouseDown(with event: NSEvent) {
//        if let label = self.label {
//            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
//        }
//        self.makeSpinny(at: event.location(in: self), color: SKColor.green)
    }
    
    override func mouseDragged(with event: NSEvent) {
//        self.makeSpinny(at: event.location(in: self), color: SKColor.blue)
    }
    
    override func mouseUp(with event: NSEvent) {
//        self.makeSpinny(at: event.location(in: self), color: SKColor.red)
    }

}
#endif

