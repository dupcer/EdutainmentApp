//
//  Flow.swift
//  EdutainmentEngineTwo
//
//  Created by Damie on 08.07.2022.
//

import Foundation

class Flow {
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
    private let game = Game()
    
    func setGameRange(min: UInt, max: UInt) throws {
        if max <= min { throw GameError.wrongRange }
        game.rangeMin = min
        game.rangeMax = max
    }
    
    func getGameRange() -> [String: UInt] {
        [
            "rangeMin": game.rangeMin,
            "rangeMax": game.rangeMax
        ]
    }
    
    func setAmountOfAllIterations(_ number: UInt) {
        game.allIterations = number
    }
    
    func getAmountOfAllIterations() -> UInt {
        game.allIterations
    }
    
    func setOperationType(_ value: Game.OperationType) {
        game.operation = value
    }
    
    func getOperationType() -> Game.OperationType {
        game.operation
    }
    
    func start() {
        currentStatus = Status.started
    }
    
    /// TASK interactions 👇
    func getNewTask() throws -> Task {
        try checkNewTaskAllowed()
        
        let newTask = Task(game: game)
        currentTaskCorrectAnswer = newTask.correctAnswer
        return newTask
    }
    
    private func checkNewTaskAllowed() throws {
        if game.currentIteration >= game.allIterations {
            throw GameError.noNewTaskAsAllIterationsComplete
        
        } else if currentStatus != .started {
            throw GameError.currentStatusIsNotStarted }
    }

    /// RESULT interactions 👇
    private let result = Result()
    private var currentTaskCorrectAnswer: Float? = nil
    
    func answer(_ answer: Float) throws -> Bool {
        if answer < 0 { throw GameError.givenAnswerIsInvalid }
        
        game.currentIteration += 1

        if game.allIterations == game.currentIteration {
            currentStatus = .finished
        }

        let isCorrect = answer == currentTaskCorrectAnswer
        if isCorrect {
            result.score += 1
        }
        
        return isCorrect
    }
    
    func getResult() -> [String: UInt] {
        [
            "allIterations": game.allIterations,
            "currentIteration": game.currentIteration,
            "score": result.score
        ]
    }
}
