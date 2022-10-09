//
//  Game.swift
//  EdutainmentEngineTwo
//
//  Created by Damie on 08.07.2022.
//

import Foundation

class Game {
    
    enum OperationType: String {
        case addition = "+",
             subtraction = "-",
             multiplication = "*",
             division = "/",
             any = "any"
    }
    
    var rangeMin: UInt = 2
    var rangeMax: UInt = 5
    var allIterations: UInt = 1
    var operation = OperationType.addition
    var currentIteration: UInt = 0
    
    
}
