//
//  Sine.swift
//  Wave
//
//  Created by Breno on 24/12/20.
//

import Foundation
import SpriteKit

class Sine: SKShapeNode {
    
    
    let amplitude: CGFloat = 100.0
    let frequency: CGFloat = 1.0
    let numPoints: Int = 48
    var centered = true
    
    var width: CGFloat = 1050
    var height: CGFloat = 350
    
    init(width: CGFloat, height: CGFloat, color: UIColor, position: CGPoint) {
        self.width = width
        self.height = height
        
        super.init()
        lineWidth = 7
        strokeColor = color
        self.position = position

        self.path = computePath(0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func update(_ offset: Int) {
        self.path = computePath(offset)
    }
    
    func computePath(_ offset: Int) -> CGMutablePath {
        var offsetX: CGFloat = CGFloat(offset)
        var offsetY: CGFloat = amplitude
        
        if centered {
            offsetX = -width / 2
            offsetY = 0
        }
        
        let path = CGMutablePath()
        
        path.move(to: CGPoint(x: offsetX, y: offsetY))
        
        let xIncr: CGFloat = width / (CGFloat(numPoints) - 1)
        
        let factor: CGFloat = 2.0 * CGFloat.pi * frequency
        let denom: CGFloat = CGFloat(numPoints) - 1
        
        for i in 0..<numPoints {
            let x: CGFloat = CGFloat(i) * xIncr
            let y: CGFloat = amplitude * sin((factor * CGFloat(i) + CGFloat(offset)) / denom)
            path.addLine(to: CGPoint(x: x + offsetX, y: y + offsetY))
            // print("sine: x: \(x), y: \(y)")
        }
        
        return path
    }
}
