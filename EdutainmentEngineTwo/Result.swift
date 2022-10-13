//
//  Result.swift
//  EdutainmentEngineTwo
//
//  Created by Damie on 09.07.2022.
//

import Foundation

class Result {
    var score: UInt = 0
    
    private(set) var resultItems: [ResultItem] = []
    
    func addTask(_ task: Task?, isCorrect: Bool) {
        guard let task = task else {
            return
        }
        let resultItem = ResultItem(
            varOne: task.varOne,
            varTwo: task.varTwo,
            operation: task.operation,
            correctAnswer: task.correctAnswer,
            wasCorrectAnswerGiven: isCorrect
        )
        resultItems.append(resultItem)
    }

}

struct ResultItem {
    let varOne: UInt
    let varTwo: UInt
    let operation: GameData.OperationType
    let correctAnswer: Float
    let wasCorrectAnswerGiven: Bool
}
