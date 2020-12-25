//
//  Utils.swift
//  Wave
//
//  Created by Breno on 25/12/20.
//

import Foundation

func sigmoid(_ x: Double) -> Double {
    return 1.0 / (1.0 + exp(-x))
}
