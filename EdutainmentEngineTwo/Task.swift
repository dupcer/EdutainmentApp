//
//  Task.swift
//  EdutainmentEngineTwo
//
//  Created by Damie on 08.07.2022.
//

import Foundation

struct Task {
    private let game: Game

    var varOne: Int = -1
    var varTwo: Int = -1
    var correctAnswer: Int = -1
    var options: [Int] = []
    var operation = Game.OperationType.addition
    
    init(game: Game) {
        self.game = game
        populateTaskData()
    }
    
    private mutating func populateTaskData() {
        switch game.operation {
        case .any:
            operation = [
                Game.OperationType.addition,
                Game.OperationType.subtraction,
                Game.OperationType.division,
                Game.OperationType.multiplication
            ].randomElement()!
        default:
            operation = game.operation
        }
        
        varOne = getRandomNumberWithinRange()
        varTwo = getRandomNumberWithinRange()
        if varOne < varTwo { (varOne, varTwo) = (varTwo, varOne) }
        
        setCorrectOption()
        setAllOptions()
        
    }
    
    private func getRandomNumberWithinRange() -> Int {
        let range = [game.rangeMin, game.rangeMax].sorted()
        return Int.random(in: Int(range[0])...Int(range[1]))
    }
    
    private mutating func setCorrectOption() {
        switch operation {
        case .subtraction : correctAnswer = varOne - varTwo
        case .multiplication: correctAnswer = varOne * varTwo
        case .division: correctAnswer = varOne / varTwo
        default: correctAnswer = varOne + varTwo

        }
    }
    
    private mutating func setAllOptions() {
        let wrongOptions = getWrongOptions(amountOfOptions: 2, correctOption: correctAnswer)
        options = [
            correctAnswer,
            wrongOptions[0],
            wrongOptions[1]
        ].shuffled()
    }
    
    private func getWrongOptions(amountOfOptions: Int, correctOption except: Int) -> [Int] {
        var arrayToReturn: [Int] = []
        var arrayOfAll: [Int] = [except]
        var i = 0
        while i < amountOfOptions {
            let randomNumber = getRandomNumberWithinRange()
            if (arrayOfAll.firstIndex(of: randomNumber) == nil) {
                arrayOfAll.append(randomNumber)
                arrayToReturn.append(randomNumber)
            } else {
                var numberToAdd = arrayOfAll.sorted().last ?? 1
                numberToAdd += 1
                arrayOfAll.append(numberToAdd)
                arrayToReturn.append(numberToAdd)
            }
            i += 1
        }
        return arrayToReturn
    }
}
