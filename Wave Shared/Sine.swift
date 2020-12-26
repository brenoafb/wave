//
//  Sine.swift
//  Wave
//
//  Created by Breno on 24/12/20.
//

import Foundation
import SpriteKit

class Sine: SKShapeNode {
    
    
    let amplitude: CGFloat = 50.0
    let frequency: CGFloat = 1
    let numPoints: Int = 48
    var centered = true
    
    var width: CGFloat
    var height: CGFloat
    
    init(width: CGFloat, height: CGFloat, color: UIColor, position: CGPoint) {
        self.width = width
        self.height = height
        
        super.init()
        lineWidth = 5
        strokeColor = color
        self.position = position

        self.path = computePath(0)
        physicsBody = SKPhysicsBody(edgeChainFrom: self.path!)
        physicsBody?.affectedByGravity = false
        physicsBody?.categoryBitMask = 0b0010
        physicsBody?.contactTestBitMask = 0b0001
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.width = 0.0
        self.height = 0.0
        super.init(coder: aDecoder)
    }
    
    func update(_ offset: Double) {
        self.path = computePath(offset)
        physicsBody = SKPhysicsBody(edgeChainFrom: self.path!)
    }
    
    func computePath(_ offset: Double) -> CGMutablePath {
        var offsetX: CGFloat = CGFloat(offset)
        var offsetY: CGFloat = amplitude
        
        if centered {
            offsetX = -width / 2
            offsetY = 0
        }
        
        let path = CGMutablePath()
        
        let xIncr: CGFloat = width / (CGFloat(numPoints) - 1)
        
        let factor: CGFloat = 2.0 * CGFloat.pi * frequency
        let denom: CGFloat = CGFloat(numPoints) - 1
        
        let y0: CGFloat = amplitude * sin(CGFloat(offset) / denom)
        path.move(to: CGPoint(x: offsetX, y: y0 + offsetY))
        
        for i in 0..<numPoints {
            let x: CGFloat = CGFloat(i) * xIncr
            let y: CGFloat = amplitude * sin((factor * CGFloat(i) + CGFloat(offset)) / denom)
            path.addLine(to: CGPoint(x: x + offsetX, y: y + offsetY))
        }
        
        return path
    }
}
