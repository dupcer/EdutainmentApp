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
        //        if flow != nil {
        //            do {
        //                try task = flow?.getNewTask()
        //                refreshUI(task: task!)
        //            } catch let error as Flow.GameError {
        //                self.errorMessageController.gameErrorMsg(for: error)
        //            } catch {
        //                NSLog("")
        //            }
        //
        //        }
    }
    
    let errorMessageController = ErrorMessagesController()
    var flow: Flow? {
        didSet {
            do {
                try task = flow?.getNewTask()
            } catch let error as Flow.GameError {
                self.errorMessageController.gameErrorMsg(for: error)
            } catch {
                NSLog("Error was cought, but not properly handeled")
            }
            refreshUI()
        }
    }
    var task: Task? {
        didSet {
            
        }
    }
    
    @IBOutlet weak var startNewGameLabel: UILabel! {
        didSet {
            if flow != nil {
                startNewGameLabel.isHidden = false
            } else {
                startNewGameLabel.isHidden = true
            }
        }
    }
    @IBOutlet weak var varOneLabel: UILabel!
    @IBOutlet weak var operationSignLabel: UILabel!
    @IBOutlet weak var varTwoLabel: UILabel!
    
    @IBOutlet weak var option1Label: UIButton!
    @IBOutlet weak var option2Label: UIButton!
    @IBOutlet weak var option3Label: UIButton!
    
    private func refreshUI() {
        loadViewIfNeeded()
        
        if flow == nil {
            startNewGameLabel.isHidden = false
        } else {
            startNewGameLabel.isHidden = true
            
            varOneLabel.text = String(task?.varOne ?? 0)
            varTwoLabel.text = String(task?.varTwo ?? 0)
            
            switch task?.operation {
            case .addition: operationSignLabel.text = "+"
            case .subtraction: operationSignLabel.text = "-"
            case .division: operationSignLabel.text = "÷"
            case .multiplication: operationSignLabel.text = "×"
            default: operationSignLabel.text = "+"
            }
            
            // TODO: update buttons
        }
        
        
        
    }
    
}
