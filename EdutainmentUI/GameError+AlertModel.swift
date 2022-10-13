//
//  ErrorMessagesController.swift
//  EdutainmentUI
//
//  Created by Damie on 02.10.2022.
//

import UIKit

extension GameFlow.GameError {
    func toAlertModel() -> (title: String, message: String, buttonText: String) {
        switch self {
        case .wrongRange:
            return (title: "Error", message: "Hmm, seems like set range is not correct. Please try again", buttonText: "OK")
        case .currentStatusIsNotStarted:
            return (title: "Error", message: "Oops, the game hasn't been started yet. Please try again", buttonText: "OK")
        case .noNewTaskAsAllIterationsComplete:
            return (title: "Error", message: "Oh, seems like you've done all tasks for now", buttonText: "OK")
        case .givenAnswerIsInvalid:
            return (title: "Error", message: "Something went wrong. Please start a new game", buttonText: "OK")
        }
    }
}
