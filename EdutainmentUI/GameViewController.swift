//
//  GameViewController.swift
//  EdutainmentUI
//
//  Created by Damie on 30.09.2022.
//

import UIKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func viewDidAppear(_ animated: Bool) {
        if flow != nil {
            do {
                try task = flow?.getNewTask()
                setValuesToLabels(task: task!)
            } catch let error as Flow.GameError {
                self.errorMessageController.gameErrorMsg(for: error)
            } catch {
                NSLog("")
            }
            
        }
    }
    
    let errorMessageController = ErrorMessagesController()
    var flow: Flow?
    var task: Task?

    @IBOutlet weak var varOneLabel: UILabel!
    @IBOutlet weak var operationSignLabel: UILabel!
    @IBOutlet weak var varTwoLabel: UILabel!
    
    
    @IBOutlet weak var option1Label: UIButton!
    @IBOutlet weak var option2Label: UIButton!
    @IBOutlet weak var option3Label: UIButton!
    
    private func setValuesToLabels(task: Task) {
        varOneLabel.text = String(task.varOne)
        varTwoLabel.text = String(task.varTwo)
        
        switch task.operation {
        case .addition: operationSignLabel.text = "+"
        case .subtraction: operationSignLabel.text = "-"
        case .division: operationSignLabel.text = "÷"
        case .multiplication: operationSignLabel.text = "×"
        default: operationSignLabel.text = "+"
        }
        
    }
    
}
