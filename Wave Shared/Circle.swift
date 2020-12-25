//
//  Circle.swift
//  Wave
//
//  Created by Breno on 24/12/20.
//

import Foundation
import SpriteKit

class Circle: SKShapeNode {
    let radius: CGFloat = 10

    init(color: SKColor, position: CGPoint) {
        super.init()
        
//        let rect = CGRect(x: 0, y: 0, width: 2 * radius, height: 2 * radius)
//
//        self.path = CGPath(ellipseIn: rect, transform: nil)
//        self.fillColor = color
//        self.strokeColor = color
//        self.position = position
        
        let path = CGMutablePath()
        path.addArc(center: CGPoint(x: 0, y: 0), radius: radius, startAngle: 0, endAngle: CGFloat.pi * 2.0, clockwise: true)
        self.path = path
        self.position = position
        self.fillColor = color
        self.strokeColor = color
        
        physicsBody = SKPhysicsBody(circleOfRadius: radius)
        physicsBody?.affectedByGravity = false
        physicsBody?.categoryBitMask = 0b0001
        physicsBody?.contactTestBitMask = 0b0010
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func toggleGravity() {
        physicsBody?.affectedByGravity.toggle()
    }
    
    func toggleDynamic() {
        physicsBody?.isDynamic.toggle()
    }
    
    func applyImpulse(_ impulse: CGVector) {
        physicsBody?.applyImpulse(impulse)
    }
}
