//
//  ErrorMessagesController.swift
//  EdutainmentUI
//
//  Created by Damie on 02.10.2022.
//

import UIKit

class ErrorMessagesController: UIAlertController {
    
    func gameErrorMsg(for error: Flow.GameError) {
        switch error {
        case .wrongRange:
            alert(title: "Error", message: "Hmm, seems like set range is not correct. Please try again", btnText: "OK")
        case .currentStatusIsNotStarted:
            alert(title: "Error", message: "Oops, the game hasn't been started yet. Please try again", btnText: "OK")
        case .noNewTaskAsAllIterationsComplete:
            alert(title: "Error", message: "Oh, seems like you've done all tasks for now", btnText: "OK")
        }
    }

    private func alert(title: String, message: String, btnText: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString(btnText, comment: "\(btnText) is Default action"), style: .default, handler: { _ in
            NSLog("Alert occured. Title: \(title), and msg: \(message)")
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
