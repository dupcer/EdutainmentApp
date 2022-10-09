//
//  Result.swift
//  EdutainmentEngineTwo
//
//  Created by Damie on 09.07.2022.
//

import Foundation

class Result {
    var score: UInt = 0
    
    private var resultsTable: [
        (
            varOne: Int,
            varTwo: Int,
            operation: Game.OperationType,
            correctAnswer: Float,
            wasCorrectAnswerGiven: Bool
        )
    ] = []
    
    func addTask(_ task: Task?, isCorrect: Bool) {
        guard let task = task else {
            return
        }
        resultsTable.append( (
            varOne: task.varOne,
            varTwo: task.varTwo,
            operation: task.operation,
            correctAnswer: task.correctAnswer,
            wasCorrectAnswerGiven: isCorrect
        ))
    }
    
    func getResultsTable() -> [ (
        varOne: Int,
        varTwo: Int,
        operation: Game.OperationType,
        correctAnswer: Float,
        wasCorrectAnswerGiven: Bool
    )] {
        resultsTable
    }
}
