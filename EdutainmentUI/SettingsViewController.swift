//
//  SettingsViewController.swift
//  EdutainmentUI
//
//  Created by Damie on 30.09.2022.
//

import UIKit

class SettingsViewController: UIViewController {
    let flow = Flow()
    
    let errorMessageController = ErrorMessagesController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let errorMessageController = ErrorMessagesController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        addChild(errorMessageController)
    }

    
    // MARK: Operation Task Setting
    var operation: Game.OperationType {
        get {
            flow.getOperationType()
        } set {
            flow.setOperationType(newValue)
        }
    }
    
    @IBAction func operationSegmentedControl(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            operation = Game.OperationType.addition
        case 1:
            operation = Game.OperationType.subtraction
        case 2:
            operation = Game.OperationType.multiplication
        case 3:
            operation = Game.OperationType.division
        case 4:
            operation = Game.OperationType.any
        default:
            operation = Game.OperationType.addition
        }
    }
    
    
    // MARK: Range Setting
    var rangeFrom: UInt = 2 {
        didSet {
            rangeFromLabel.text = "\(rangeFrom)"
        }
    }
    
    var rangeTo: UInt = 5 {
        didSet {
            rangeToLabel.text = "\(rangeTo)"
        }
    }
    
    
    @IBOutlet weak var rangeFromLabel: UILabel!
    @IBAction func rangeFromStepper(_ sender: UIStepper) {
        rangeToStepperOutlet.minimumValue = sender.value + 2
        rangeFrom = UInt(sender.value)
    }
    @IBOutlet weak var rangeFromStepperOutlet: UIStepper!
    
    
    @IBOutlet weak var rangeToLabel: UILabel!
    @IBAction func rangeToStepper(_ sender: UIStepper) {
        rangeFromStepperOutlet.maximumValue = sender.value - 2
        rangeTo = UInt(sender.value)
    }
    @IBOutlet weak var rangeToStepperOutlet: UIStepper!
    
    
    // MARK: Number of tasks Setting
    var numberOfTasks: UInt {
        get {
            let n = flow.getAmountOfAllIterations()
            numberOfTasksLabel.text = "\(n)"
            return n
        } set {
            let n = UInt(newValue)
            flow.setAmountOfAllIterations(n)
            numberOfTasksLabel.text = "\(n)"
        }
    }
    
    @IBOutlet weak var numberOfTasksLabel: UILabel!
    
    @IBAction func numberOfTasksSlider(_ sender: UISlider) {
        numberOfTasks = UInt(sender.value)
    }
    
    
    // MARK: Start Button
    @IBAction func startBtn() {
        print(operation, rangeFrom, rangeTo, numberOfTasks)
        do {
            try flow.setGameRange(min: rangeFrom, max: rangeTo)
            flow.currentStatus = .started
            flow.start()
        } catch let error as Flow.GameError {
            self.errorMessageController.gameErrorMsg(for: error)
            
        } catch {
            NSLog("unknown error")
        }
        
        
    }
}
