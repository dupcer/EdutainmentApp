//
//  EdutainmentUnitTests.swift
//  EdutainmentUnitTests
//
//  Created by Damie on 12.10.2022.
//

import XCTest
@testable import EdutainmentUI

class GameFlowTests: XCTestCase {
    let incorrectAnswer: Float = 999999999
    
    func test_noSettingAnything_defaultSettingsApplied() {
        let sut = GameFlow()

        let range = sut.getGameRange()
        XCTAssertEqual(range["rangeMin"], 2)
        XCTAssertEqual(range["rangeMax"], 5)
        XCTAssertEqual(sut.getAmountOfAllIterations(), 1)
    }
    
    func test_setIlligalGameRange_getError() {
        let sut = GameFlow()
        
        XCTAssertThrowsError(try sut.setGameRange(min: 1, max: 1)) { error in
            XCTAssertEqual(error as! GameFlow.GameError, GameFlow.GameError.wrongRange)
        }
    }
    
    func test_setGameValues_settingsApplied() {
        let sut = GameFlow()
        try! sut.setGameRange(min: 10, max: 15)

        let range = sut.getGameRange()
        XCTAssertEqual(range["rangeMin"], 10)
        XCTAssertEqual(range["rangeMax"], 15)

        sut.setAmountOfAllIterations(30)
        XCTAssertEqual(sut.getAmountOfAllIterations(), 30)
        
        sut.setOperationType(GameData.OperationType.any)
        XCTAssertEqual(sut.getOperationType(), GameData.OperationType.any)
    }
    
    func test_getTaskInAccordanceWithRange() {
        let sut = GameFlow()
        try! sut.setGameRange(min: 1, max: 15)
        sut.start()
        let task = try! sut.getNewTask()
        XCTAssertGreaterThanOrEqual(task.varOne, 1)
        XCTAssertLessThanOrEqual(task.varOne, 15)
        
        XCTAssertGreaterThanOrEqual(task.varTwo, 1)
        XCTAssertLessThanOrEqual(task.varTwo, 15)
        
        XCTAssertEqual(Float(task.varOne + task.varTwo), task.correctAnswer)
        XCTAssertTrue(task.options.contains(task.correctAnswer))
        
        let wrongOptions = task.options.filter({$0 != task.correctAnswer})
        XCTAssertTrue(wrongOptions[0] >= 1 && wrongOptions[0] <= 17)
        print("\n \(wrongOptions)\n ")
        XCTAssertTrue(wrongOptions[1] >= 1 && wrongOptions[1] <= 17)
        XCTAssertTrue(wrongOptions[0] != wrongOptions[1])
    }
    
    func test_cannotGetNewTaskIfStatusIsNotStarted() {
        let sut = GameFlow()

        XCTAssertThrowsError(try sut.getNewTask()) { error in
            XCTAssertEqual(error as!  GameFlow.GameError,  GameFlow.GameError.currentStatusIsNotStarted)
        }
    }
    
    func test_getAsManyTasksAsSetAmountOfIterations() {
        let sut = GameFlow()
        sut.setAmountOfAllIterations(1)
        sut.start()
        let task = try! sut.getNewTask();
        try! sut.answer(task.options[0]);
        
        XCTAssertThrowsError(try sut.getNewTask()) { error in
            XCTAssertEqual(error as!  GameFlow.GameError,  GameFlow.GameError.noNewTaskAsAllIterationsComplete)
        }
    }
    
    func test_allTasksAreDifferent() {
        let sut = GameFlow()
        sut.setAmountOfAllIterations(3)
        sut.start()
        let firstTask = try! sut.getNewTask()
        let secondTask = try! sut.getNewTask()
        XCTAssertFalse(firstTask.correctAnswer == secondTask.correctAnswer && firstTask.options == secondTask.options)

        let thirdTask = try! sut.getNewTask()
        XCTAssertFalse(thirdTask.correctAnswer == secondTask.correctAnswer && thirdTask.options == secondTask.options)
    }
    
    func test_resultScoreIsCorrect() {
        let sut = GameFlow()
        sut.setAmountOfAllIterations(4)
        sut.start()
        let firstTask = try! sut.getNewTask()
        try! sut.answer(firstTask.correctAnswer)
        let firstResult = sut.getCurrentResult()
        XCTAssertEqual(firstResult["allIterations"], 4)
        XCTAssertEqual(firstResult["currentIteration"], 1)
        XCTAssertEqual(firstResult["score"], 1)
        
        let secondTask = try! sut.getNewTask()
        try! sut.answer(incorrectAnswer)
        let secondResult = sut.getCurrentResult()
        XCTAssertEqual(secondResult["allIterations"], 4)
        XCTAssertEqual(secondResult["currentIteration"], 2)
        XCTAssertEqual(secondResult["score"], 1)

        let thirdTask = try! sut.getNewTask()
        
        try! sut.answer(thirdTask.correctAnswer)
        let thirdResult = sut.getCurrentResult()
        XCTAssertEqual(thirdResult["allIterations"], 4)
        XCTAssertEqual(thirdResult["currentIteration"], 3)
        XCTAssertEqual(thirdResult["score"], 2)

        let task = try! sut.getNewTask();
        try! sut.answer(incorrectAnswer);
        let forthResult = sut.getCurrentResult()
        XCTAssertEqual(forthResult["allIterations"], 4)
        XCTAssertEqual(forthResult["currentIteration"], 4)
        XCTAssertEqual(forthResult["score"], 2)
    }
    
    func test_operationTypeIsAny() {
        let sut = GameFlow()
        sut.start()
        sut.setOperationType(.any)
        var operations = Set <GameData.OperationType>()
        var i = 0
        repeat {
            let task = try! sut.getNewTask()
            operations.insert(task.operation)
            print(task.operation)
            i += 1
        } while i < 100
        XCTAssertTrue(operations.count > 1 && operations.count < 5)
        
    }
    
    func test_operationTypeIsSubtraction() {
        let sut = GameFlow()
        sut.start()
        sut.setOperationType(.subtraction)
        let task = try! sut.getNewTask()
        XCTAssertEqual(Float(task.varOne - task.varTwo), task.correctAnswer)
    }

    func test_operationTypeIsDivision() {
        let sut = GameFlow()
        sut.start()
        sut.setOperationType(.division)
        let task = try! sut.getNewTask()
        print(task.varOne, task.varTwo, "=", Float(task.varOne) / Float(task.varTwo), task.correctAnswer)
        XCTAssertGreaterThanOrEqual(Float(task.varOne) / Float(task.varTwo), floor(task.correctAnswer))
        XCTAssertLessThanOrEqual(Float(task.varOne) / Float(task.varTwo), ceil(task.correctAnswer))
    }
    
    func test_optionsWithOneOrMoreDicimalPoint() {
        let sut = GameFlow()
        try! sut.setGameRange(min: 8, max: 505)
        sut.start()
        sut.setOperationType(.division)
        let task = try! sut.getNewTask()
        print(task.options)
        print(task.varOne,  "/", task.varTwo, "=", Float(task.varOne) / Float(task.varTwo), task.correctAnswer)
        XCTAssertGreaterThanOrEqual(Float(task.varOne) / Float(task.varTwo), floor(task.correctAnswer))
        XCTAssertLessThanOrEqual(Float(task.varOne) / Float(task.varTwo), ceil(task.correctAnswer))
    }
    
    
    func test_operationTypeIsMultiplication() {
        let sut = GameFlow()
        sut.start()
        sut.setOperationType(.multiplication)
        let task = try! sut.getNewTask()
        XCTAssertEqual(Float(task.varOne * task.varTwo), task.correctAnswer)
    }
    
    func test_statusIsFinishedOnceAllIterationsComplete() {
        let sut = GameFlow()
        sut.setAmountOfAllIterations(4)
        XCTAssertEqual(sut.currentStatus,  GameFlow.Status.setting)
        sut.start()
        XCTAssertEqual(sut.currentStatus,  GameFlow.Status.started)
        for _ in 1...4 {
            XCTAssertEqual(sut.currentStatus,  GameFlow.Status.started)
            let task = try! sut.getNewTask();
            try! sut.answer(task.options[0]);
        }
        print(sut.getCurrentResult())
        XCTAssertEqual(sut.currentStatus,  GameFlow.Status.finished)
    }
    
    func test_cannotGetTaskIfStatusIsPaused() {
        let sut = GameFlow()
        sut.start()
        sut.currentStatus = .paused
        XCTAssertEqual(sut.currentStatus,  GameFlow.Status.paused)
        XCTAssertThrowsError(try sut.getNewTask()) { error in
            XCTAssertEqual(error as!  GameFlow.GameError,  GameFlow.GameError.currentStatusIsNotStarted)
        }
        sut.currentStatus = .started
        XCTAssertEqual(sut.currentStatus,  GameFlow.Status.started)
        let task = try! sut.getNewTask();
        try! sut.answer(task.options[0]);
        XCTAssertEqual(sut.currentStatus,  GameFlow.Status.finished)
    }

    func test_answerFalse() {
        let sut = GameFlow()
        sut.start()
        try! sut.getNewTask()
        XCTAssertThrowsError(try sut.answer(-1)) { error in
            XCTAssertEqual(error as!  GameFlow.GameError,  GameFlow.GameError.givenAnswerIsInvalid)
        }
    }
    
    func test_resultScoreTableIsCorrect() {
        let sut = GameFlow()
        let amountOfIterations: UInt = 5
        sut.setAmountOfAllIterations(amountOfIterations)
        sut.start()
        
        let firstTask = try! sut.getNewTask()
        try! sut.answer(firstTask.correctAnswer)
        let firstResult = sut.getCurrentResult()
        XCTAssertEqual(firstResult["allIterations"], amountOfIterations)
        XCTAssertEqual(firstResult["currentIteration"], 1)
        XCTAssertEqual(firstResult["score"], 1)
        
        let secondTask = try! sut.getNewTask()
        try! sut.answer(incorrectAnswer)
        let secondResult = sut.getCurrentResult()
        XCTAssertEqual(secondResult["allIterations"], amountOfIterations)
        XCTAssertEqual(secondResult["currentIteration"], 2)
        XCTAssertEqual(secondResult["score"], 1)

        let thirdTask = try! sut.getNewTask()
        try! sut.answer(thirdTask.correctAnswer)
        let thirdResult = sut.getCurrentResult()
        XCTAssertEqual(thirdResult["allIterations"], amountOfIterations)
        XCTAssertEqual(thirdResult["currentIteration"], 3)
        XCTAssertEqual(thirdResult["score"], 2)

        let forthTask = try! sut.getNewTask();
        try! sut.answer(incorrectAnswer);
        let forthResult = sut.getCurrentResult()
        XCTAssertEqual(forthResult["allIterations"], amountOfIterations)
        XCTAssertEqual(forthResult["currentIteration"], 4)
        XCTAssertEqual(forthResult["score"], 2)
        
        let fifthTask = try! sut.getNewTask()
        try! sut.answer(fifthTask.correctAnswer)
        let fifthResult = sut.getCurrentResult()
        XCTAssertEqual(fifthResult["allIterations"], amountOfIterations)
        XCTAssertEqual(fifthResult["currentIteration"], 5)
        XCTAssertEqual(fifthResult["score"], 3)
        
        let resultTable = sut.getResultsTable()
        
        var i = 0
        for task in [firstTask, secondTask, thirdTask, forthTask, fifthTask] {
            XCTAssertEqual(resultTable[i].varOne, task.varOne)
            XCTAssertEqual(resultTable[i].varTwo, task.varTwo)
            XCTAssertEqual(resultTable[i].operation, task.operation)
            XCTAssertEqual(resultTable[i].correctAnswer, task.correctAnswer)
            if i % 2 == 0 {
                XCTAssertTrue(resultTable[i].wasCorrectAnswerGiven)
            } else {
                XCTAssertFalse(resultTable[i].wasCorrectAnswerGiven)
            }
            
            i += 1
        }
        

    }
}
