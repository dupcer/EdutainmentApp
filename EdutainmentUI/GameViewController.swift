//
//  GameViewController.swift
//  EdutainmentUI
//
//  Created by Damie on 30.09.2022.
//

import UIKit

class GameViewController: UIViewController, GameVCDelegate {
    func updateFlow(_ newFlow: Flow) {
        flow = newFlow
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SettingsViewController.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    let errorMessageController = ErrorMessagesController()
    var flow: Flow? {
        didSet {
            if flow != nil, flow?.currentStatus == .started {try! task = flow?.getNewTask()}
            refreshUI()
        }
    }
    
    var task: Task?
    
    @IBOutlet weak var startNewGameLabel: UILabel!
//    {
//        didSet {
//            if flow != nil {
//                startNewGameLabel.isHidden = false
//            } else {
//                startNewGameLabel.isHidden = true
//            }
//        }
//    }
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
