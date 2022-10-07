//
//  GameViewController.swift
//  EdutainmentUI
//
//  Created by Damie on 30.09.2022.
//

import UIKit

class GameViewController: UIViewController, GameVCDelegate {
    let decimalPoint = 2
    
    func updateFlow(_ newFlow: Flow) {
        flow = newFlow
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SettingsViewController.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if flow != nil {
            updateFlow(flow!)
        }
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
    
    @IBOutlet weak var varOneLabel: UILabel!
    @IBOutlet weak var operationSignLabel: UILabel!
    @IBOutlet weak var varTwoLabel: UILabel!
    
    @IBOutlet weak var option1Label: UIButton!
    @IBOutlet weak var option2Label: UIButton!
    @IBOutlet weak var option3Label: UIButton!
    lazy var optionButtons: [UIButton] = [option1Label, option2Label, option3Label]
    
    @IBAction func optionButtonAction(_ sender: UIButton) {
        let answer = sender.currentTitle ?? ""
        let floatAnswer = Float(answer) ?? -1.0
        var isCorrect: Bool = false
        do {
            isCorrect = try flow?.answer(floatAnswer) ?? false
        } catch let error as Flow.GameError {
            self.errorMessageController.gameErrorMsg(for: error)
        } catch {
            NSLog("AN ERROR OCCURED WHILE SUBMITTING THE ANSWER TO TASK")
        }
        optionButtonAnimation(isCorrect: isCorrect, sender: sender)
        
    }
    
    
    private func refreshUI() {
        loadViewIfNeeded()
        
        if flow == nil {
            startNewGameLabel.isHidden = false
        } else {
            guard let currentTask = task else {
                return
            }
            startNewGameLabel.isHidden = true
            
            varOneLabel.text = String(currentTask.varOne)
            varTwoLabel.text = String(currentTask.varTwo)
            
            switch currentTask.operation {
            case .addition: operationSignLabel.text = "+"
            case .subtraction: operationSignLabel.text = "-"
            case .division: operationSignLabel.text = "÷"
            case .multiplication: operationSignLabel.text = "×"
            default: operationSignLabel.text = "+"
            }
            
            let options = getOptionsAsString(for: currentTask)
            option1Label.setTitle(options[0], for: .normal)
            option2Label.setTitle(options[1], for: .normal)
            option3Label.setTitle(options[2], for: .normal)
            
            optionButtons.forEach({ $0.isEnabled = true })
        }
    }
    
    private func optionButtonAnimation(isCorrect: Bool, sender: UIButton){
        let tagTapped = sender.tag
        optionButtons.forEach({ if $0.tag != tagTapped {$0.isEnabled = false} })
        
        UIView.animate(withDuration: 0.75, delay: 0.2, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [], animations: {
            sender.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
            sender.setTitleColor(.purple, for: .normal)
        }, completion: {_ in
            if isCorrect {
                UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 10, initialSpringVelocity: 25, options: [], animations: {
                    sender.transform = CGAffineTransform(scaleX: 2, y: 2)
                    sender.tintColor = UIColor.green
                }) }
            else {
                sender.transform = CGAffineTransform(scaleX: 1, y: 1)
                sender.tintColor = UIColor.red
                
                let animation = CABasicAnimation(keyPath: "position")
                animation.duration = 0.07
                animation.repeatCount = 3
                animation.autoreverses = true
                animation.fromValue = NSValue(cgPoint: CGPoint(x: sender.center.x - 12, y: sender.center.y))
                animation.toValue = NSValue(cgPoint: CGPoint(x: sender.center.x + 12, y: sender.center.y))
                
                sender.layer.add(animation, forKey: "position")
            }
        }
        )
        
    }
    
    private func getOptionsAsString(for task: Task) -> [String] {
        if task.options.filter( {floor($0) != $0} ).isEmpty {
            return task.options.map({ String(format: "%.0f", $0) })
        } else {
            return task.options.map({ String(format: "%.\(decimalPoint)f", $0) })
        }
    }
}

