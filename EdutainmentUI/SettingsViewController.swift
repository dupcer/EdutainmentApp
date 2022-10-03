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
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        addChild(errorMessageController)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "StartGame" {
            if let vc = segue.destination as? GameViewController {
                vc.flow = flow
                lastSeguedToGaveVewController = vc
            }
        }
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
    var numberOfTasks: UInt = 50 {
        didSet {
            numberOfTasksLabel.text = "\(numberOfTasks)"
        }
    }
    
    @IBOutlet weak var numberOfTasksLabel: UILabel!
    
    @IBAction func numberOfTasksSlider(_ sender: UISlider) {
        numberOfTasks = UInt(sender.value)
    }
    
    
    // MARK: Start Button
    @IBAction func startButton(_ sender: UIButton) {
        print(operation, rangeFrom, rangeTo, numberOfTasks)
        do {
            flow.setAmountOfAllIterations(numberOfTasks)
            try flow.setGameRange(min: rangeFrom, max: rangeTo)
            flow.currentStatus = .started
            flow.start()
            sendFlowToGameVC(flow, sender: sender)
        } catch let error as Flow.GameError {
            self.errorMessageController.gameErrorMsg(for: error)
        } catch {
            NSLog("unknown error")
        }
    }
    
    static var delegate: GameVCDelegate?
    
    private var splitViewGameViewController: GameViewController? {
        splitViewController?.viewControllers.forEach({print($0 is GameViewController)})
        return splitViewController?.viewControllers.last as? GameViewController
    }
    
    private var lastSeguedToGaveVewController: GameViewController?
    
    private func sendFlowToGameVC(_ newFlow: Flow, sender: Any) {
        if let splitViewGameVC = SettingsViewController.delegate as? GameViewController { // for iPad
            splitViewController?.showDetailViewController(splitViewGameVC, sender: sender)
            splitViewGameVC.flow = flow
        } else if let splitViewGameVC = lastSeguedToGaveVewController { // for iPhone
            splitViewGameVC.flow = flow
            navigationController?.pushViewController(splitViewGameVC, animated: true)
        } else {
            performSegue(withIdentifier: "StartGame", sender: sender)
        }
    }
}

protocol GameVCDelegate {
    func updateFlow(_ newFlow: Flow)
}
