//
//  Ball.swift
//  Wave
//
//  Created by Breno on 24/12/20.
//

import Foundation
import SpriteKit

class Circle: SKShapeNode {
    let radius: CGFloat = 35
    
    init(color: SKColor, position: CGPoint) {
        super.init()
        let rect = CGRect(x: position.x, y: position.y, width: radius, height: radius)
        self.path = CGPath(ellipseIn: rect, transform: nil)
        self.fillColor = color
        self.strokeColor = color
        self.position = position
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
