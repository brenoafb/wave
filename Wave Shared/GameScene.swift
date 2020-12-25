//
//  GameScene.swift
//  Wave Shared
//
//  Created by Breno on 24/12/20.
//

import SpriteKit

class GameScene: SKScene {
    
    fileprivate var upperSine: Sine?
    fileprivate var lowerSine: Sine?
    fileprivate var circle: Circle?
    fileprivate var counter: Int = 0
    
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
//        let width: CGFloat = frame.width
//        let height: CGFloat = frame.height

        let width: CGFloat = view!.bounds.width
        let height: CGFloat = view!.bounds.height
        print("width: \(width), height: \(height)")
        
        backgroundColor = .white
        upperSine = Sine(width: 2 * width, height: 2 * height, color: .black, position: CGPoint(x: 0, y: height / 2.0))
        addChild(upperSine!)
        lowerSine = Sine(width: 2 * width, height: 2 * height, color: .black, position: CGPoint(x: 0, y: -height / 2.0))
        addChild(lowerSine!)
        
        circle = Circle(color: .black, position: CGPoint(x: -width / 4.0 , y: 0.0))
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
        upperSine!.update(counter)
        lowerSine!.update(counter)
        
        counter += 1
    }
}

#if os(iOS) || os(tvOS)
// Touch-based event handling
extension GameScene {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let position = t.location(in: view)
            let circle = Circle(color: .black, position: position)
            self.addChild(circle)
        }
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

