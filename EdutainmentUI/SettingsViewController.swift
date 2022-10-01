//
//  SettingsViewController.swift
//  EdutainmentUI
//
//  Created by Damie on 30.09.2022.
//

import UIKit

class SettingsViewController: UIViewController {
    let flow = Flow()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        rangeFrom = UInt(sender.value)
    }
    
    @IBOutlet weak var rangeToLabel: UILabel!
    @IBAction func rangeToStepper(_ sender: UIStepper) {
        rangeTo = UInt(sender.value)
    }
}
