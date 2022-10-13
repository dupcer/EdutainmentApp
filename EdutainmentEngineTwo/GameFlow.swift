//
//  Flow.swift
//  EdutainmentEngineTwo
//
//  Created by Damie on 08.07.2022.
//

import Foundation

class GameFlow {
    enum Status {
        case setting, started, paused, finished
    }
    
    enum GameError: Error {
        case wrongRange,
             currentStatusIsNotStarted,
             noNewTaskAsAllIterationsComplete,
             givenAnswerIsInvalid
    }
    
    var currentStatus = Status.setting
    
    /// GAME interactions 👇
    private let game = GameData()
    
    func setGameRange(min: UInt, max: UInt) throws {
        if max <= min { throw GameError.wrongRange }
        game.rangeMin = min
        game.rangeMax = max
    }
    
    func getGameRange() -> [String: UInt] {
        return [
            "rangeMin": game.rangeMin,
            "rangeMax": game.rangeMax
        ]
    }
    
    func setAmountOfAllIterations(_ number: UInt) {
        game.allIterations = number
    }
    
    func getAmountOfAllIterations() -> UInt {
        return game.allIterations
    }
    
    func setOperationType(_ value: GameData.OperationType) {
        game.operation = value
    }
    
    func getOperationType() -> GameData.OperationType {
        return game.operation
    }
    
    func start() {
        currentStatus = Status.started
    }
    
    /// TASK interactions 👇
    func getNewTask() throws -> Task {
        if game.currentIteration >= game.allIterations {
            throw GameError.noNewTaskAsAllIterationsComplete
        }
        if currentStatus != .started {
            throw GameError.currentStatusIsNotStarted
        }
        
        let newTask = Task(game: game)
        currentTask = newTask
        return newTask
    }

    /// RESULT interactions 👇
    private let result = Result()
    private var currentTask: Task? = nil
    
    func answer(_ answer: Float) throws -> Bool {
        guard answer >= 0
        else {
            throw GameError.givenAnswerIsInvalid
        }
        
        game.currentIteration += 1

        if game.allIterations == game.currentIteration {
            currentStatus = .finished
        }

        let isCorrect = answer == currentTask?.correctAnswer
        if isCorrect {
            result.score += 1
        }
        result.addTask(currentTask ?? nil,
                       isCorrect: isCorrect)
        return isCorrect
    }
    
    func getCurrentResult() -> [String: UInt] { // TODO: refactor
        return [
            "allIterations": game.allIterations,
            "currentIteration": game.currentIteration,
            "score": result.score
        ]
    }
    
    func getResultsTable() -> [ResultItem] {
        return result.resultItems
    }
}
