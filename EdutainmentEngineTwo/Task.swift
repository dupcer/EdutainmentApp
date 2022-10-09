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
    var correctAnswer: Float = -1
    var options: [Float] = []
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

    
    private func getRandomNumberWithinRange() -> Float {
        let range = [game.rangeMin, game.rangeMax].sorted()
        return Float.random(in: Float(range[0])...Float(range[1]))
    }

    
    private mutating func setCorrectOption() {
        let varOne: Float = Float(varOne)
        let varTwo: Float = Float(varTwo)
        
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
    
    
    private mutating func getWrongOptions(amountOfOptions: Int, correctOption except: Float) -> [Float] {
        let remainder = except.truncatingRemainder(dividingBy: 2)
        if remainder == 0.0 || remainder == 1 { // round
            return getRandomNumbersWithinRange(
                amountOfOptions: amountOfOptions,
                except: except,
                roundType: .fullRound
            )
        } else if remainder >= 1.1 { // round for 0.5
            return getRandomNumbersWithinRange(
                amountOfOptions: amountOfOptions,
                except: except,
                roundType: .oneDigitRound
            )
        } else { // round for 0.88
            return getRandomNumbersWithinRange(
                amountOfOptions: amountOfOptions,
                except: except,
                roundType: .twoDigitsRound
            )
        }
    }
    
    
    private mutating func getRandomNumbersWithinRange(amountOfOptions: Int, except: Float, roundType: NumberRoundType) -> [Float] {
        var arrayToReturn: [Float] = [except]
        
        
        var i = 0
        while i < amountOfOptions {
            var newNumber: Float = getRandomNumberWithinRange()
            
            switch roundType {
            case .fullRound:
                newNumber = newNumber.rounded()
                var roundedArray: [Float] = arrayToReturn.map({ $0.rounded() })
                if roundedArray.contains(newNumber) {
                    newNumber = roundedArray.sorted(by: >)[0] + 1
                }
                roundedArray.append(newNumber)
                arrayToReturn = roundedArray
                correctAnswer = correctAnswer.rounded()
                
            case .oneDigitRound:
                newNumber = oneDigitRounded(newNumber)
                var roundedArray: [Float] = arrayToReturn.map({ oneDigitRounded($0) })
                if roundedArray.contains(newNumber) {
                    newNumber = roundedArray.sorted(by: >)[0] + 0.5
                }
                roundedArray.append(newNumber)
                arrayToReturn = roundedArray
                correctAnswer = oneDigitRounded(correctAnswer)
                
            case .twoDigitsRound:
                newNumber = twoDigitRounded(newNumber)
                var roundedArray: [Float] = arrayToReturn.map({ twoDigitRounded($0) })
                if roundedArray.contains(newNumber) {
                    newNumber = roundedArray.sorted(by: >)[0] + 0.25
                }
                roundedArray.append(newNumber)
                arrayToReturn = roundedArray
                correctAnswer = twoDigitRounded(correctAnswer)
            }
            
            i += 1
        }
        return arrayToReturn.filter{$0 != correctAnswer}

    }
    
    
    private func oneDigitRounded(_ number: Float) -> Float {
        return round(number * 10) / 10.0
    }

    private func twoDigitRounded(_ number: Float) -> Float {
        round(number * 100) / 100.0
    }
    
    enum NumberRoundType {
        case fullRound, oneDigitRound, twoDigitsRound
    }
}

