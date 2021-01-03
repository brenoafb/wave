//
//  Colors.swift
//  Wave
//
//  Created by Breno on 25/12/20.
//

import Foundation
import SpriteKit

var colorData: ColorData = load("colors.json")

#if os(iOS)
typealias Color = UIColor
#elseif os(macOS)
typealias Color = NSColor
#endif


struct ColorData: Decodable {
  let jsonColors: [String : JSONColor]
  let pairs: [[String]]
  
  #if os(iOS)
  var colors: [String : Color] {
    jsonColors.mapValues(toUIColor)
  }
  #elseif os(macOS)
  var colors: [String : Color] {
    jsonColors.mapValues(toNSColor)
  }
  #endif

  var skColors: [String : SKColor] {
    jsonColors.mapValues(toSKColor)
  }
}

struct JSONColor: Decodable {
  let red: Double
  let green: Double
  let blue: Double
}

func toSKColor(_ color: JSONColor) -> SKColor {
  return SKColor(red: CGFloat(color.red), green: CGFloat(color.green), blue: CGFloat(color.blue), alpha: 1.0)
}

#if os(iOS)
func toUIColor(_ color: JSONColor) -> UIColor {
  return UIColor(red: CGFloat(color.red), green: CGFloat(color.green), blue: CGFloat(color.blue), alpha: 1.0)
}
#elseif os(macOS)
func toNSColor(_ color: JSONColor) -> NSColor {
  return NSColor(red: CGFloat(color.red), green: CGFloat(color.green), blue: CGFloat(color.blue), alpha: 1.0)
}
#endif


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
