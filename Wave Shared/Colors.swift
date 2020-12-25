//
//  Colors.swift
//  Wave
//
//  Created by Breno on 25/12/20.
//

import Foundation
import SpriteKit

struct Color: Decodable {
    var red: Double
    var green: Double
    var blue: Double
}

func toSKColor(_ color: Color) -> SKColor {
    return SKColor(red: CGFloat(color.red), green: CGFloat(color.green), blue: CGFloat(color.blue), alpha: 1.0)
}

func toUIColor(_ color: Color) -> UIColor {
    return UIColor(red: CGFloat(color.red), green: CGFloat(color.green), blue: CGFloat(color.blue), alpha: 1.0)
}

var colors: [String:Color] = load("colors.json")
var skColors: [String:SKColor] = colors.mapValues { toSKColor($0) }
var uiColors: [String:UIColor] = colors.mapValues { toUIColor($0) }

func load<T: Decodable>(_ filename: String) -> T {
    let data: Data
    
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
    else {
        fatalError("Couldn't find \(filename) in main bundle.")
    }
    
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }
    
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}
