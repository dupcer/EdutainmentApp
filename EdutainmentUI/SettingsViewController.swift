//
//  SettingsViewController.swift
//  EdutainmentUI
//
//  Created by Damie on 30.09.2022.
//

import UIKit

class SettingsViewController:
        UIViewController,
        UISplitViewControllerDelegate,
        AlertPresentable
{
    
    var flow: GameFlow = GameFlow()
        
    override func awakeFromNib() {
        super.awakeFromNib()
        splitViewController?.delegate = self
    }
    
    func splitViewController(
        _ splitViewController: UISplitViewController,
        collapseSecondary secondaryViewController: UIViewController,
        onto primaryViewController: UIViewController) -> Bool {
            if let gameVC = secondaryViewController as? GameViewController {
                if gameVC.isFlowNil {
                    return true
                }
            }
            return false
        }

    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "StartGame" {
            if let vc = segue.destination as? GameViewController {
                prepareFlow()
                vc.updateFlow(flow)
                lastSeguedToGameVewController = vc
            }
        }
    }
    
    // MARK: Operation Task Setting
    var operation: GameData.OperationType = .addition
    
    @IBAction func operationSegmentedControl(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            operation = GameData.OperationType.addition
        case 1:
            operation = GameData.OperationType.subtraction
        case 2:
            operation = GameData.OperationType.multiplication
        case 3:
            operation = GameData.OperationType.division
        case 4:
            operation = GameData.OperationType.any
        default:
            operation = GameData.OperationType.addition
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
//        prepareFlow()
    }
    
    private func prepareFlow() {
        print(operation, rangeFrom, rangeTo, numberOfTasks)
        do {
            flow = GameFlow()
            flow.setAmountOfAllIterations(numberOfTasks)
            flow.setOperationType(operation)
            try flow.setGameRange(min: rangeFrom, max: rangeTo)
            flow.start()
        } catch let error as GameFlow.GameError {
            let alertModel = error.toAlertModel()
            self.presentAlert(title: alertModel.title, message: alertModel.message, buttonTitle: alertModel.buttonText)
        } catch {
            NSLog("THE ERROR OCURED WHILE STARTING THE GAME")
        }
    }
    
    static var delegate: GameVCDelegate?
    
    private var splitViewGameViewController: GameViewController? {
        splitViewController?.viewControllers.forEach({print($0 is GameViewController)})
        return splitViewController?.viewControllers.last as? GameViewController
    }
    
    private var lastSeguedToGameVewController: GameViewController?
    
    private func sendFlowToGameVC(sender: Any) {
        if let splitViewGameVC = SettingsViewController.delegate as? GameViewController { // for iPad
            splitViewController?.showDetailViewController(splitViewGameVC, sender: sender)
            splitViewGameVC.updateFlow(flow)
        } else if let splitViewGameVC = lastSeguedToGameVewController { // for iPhone
            performSegue(withIdentifier: "StartGame", sender: sender)
            splitViewGameVC.updateFlow(flow)
        }
    }
}

protocol GameVCDelegate {
    func updateFlow(_ newFlow: GameFlow)
}

