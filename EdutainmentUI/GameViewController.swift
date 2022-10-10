//
//  GameViewController.swift
//  EdutainmentUI
//
//  Created by Damie on 30.09.2022.
//

import UIKit

class GameViewController: UIViewController, GameVCDelegate {
    let decimalPoint = 2
    
    private var flow: Flow?
    var isFlowNil: Bool {
        get {
            (flow == nil)
        }
    }
    
    var task: Task?
    
    func updateFlow(_ newFlow: Flow) {
        flow = newFlow
    }
    
//    let progressBar = GameProgressView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SettingsViewController.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if isFlowNil {
            startNewGameLabel.isHidden = false
        } else {
            startNewGameLabel.isHidden = true
            triggerUIRefresh.toggle()
        }
        addChild(errorMessageController)
    }
    
    //    var initialState: UIButton? = nil
    
    let errorMessageController = ErrorMessagesController()
    
    
    @IBOutlet weak var startNewGameLabel: UILabel!
    
    @IBOutlet weak var progressBar: UIProgressView!
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
    
    
    private var triggerUIRefresh: Bool = true {
        willSet {
            loadViewIfNeeded()
            
            let currentResult = flow?.getResult()
            if let currentIteration = currentResult?["currentIteration"] {
                if let allIterations = currentResult?["allIterations"] {
                    if currentIteration >= allIterations {
                        return showResults()
                    }
                }
            }
            
            do {
                try task = flow?.getNewTask()
            } catch let error as Flow.GameError {
                self.errorMessageController.gameErrorMsg(for: error)
            } catch {
                NSLog("AN ERROR OCCURED REFRESHING AND GETTING A NEW TASK")
            }
            
            guard let currentTask = task else {
                return
            }
            startNewGameLabel.isHidden = true
            
            varOneLabel.text = String(currentTask.varOne)
            varTwoLabel.text = String(currentTask.varTwo)
            
            operationSignLabel.text = currentTask.operation.rawValue
            
            let options = getOptionsAsString(for: currentTask)
            option1Label.setTitle(options[0], for: .normal)
            option2Label.setTitle(options[1], for: .normal)
            option3Label.setTitle(options[2], for: .normal)
            
            if let currentIteration = flow?.getResult()["currentIteration"], let all = flow?.getResult()["allIterations"] {
                let currentProgress: Float = 100 * Float(currentIteration) / Float(all) / 100
                progressBar.setProgress(currentProgress, animated: true)
            }
        }
    }
    
    private func optionButtonAnimation(isCorrect: Bool, sender: UIButton) {
        let tagTapped = sender.tag
        optionButtons.forEach({ if $0.tag != tagTapped {$0.isEnabled = false} })
        let initialState = option1Label
        
        
        UIView.animate(withDuration: 0.75, delay: 0.2, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [UIView.AnimationOptions.curveEaseIn], animations: {
            
            sender.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
            sender.setTitleColor(.purple, for: .normal)
        }, completion: { _ in
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.setButtonsToInitialState(initialState)
            self.triggerUIRefresh.toggle()
        }
        
    }
    
    private func getOptionsAsString(for task: Task) -> [String] {
        if task.options.filter( {floor($0) != $0} ).isEmpty {
            return task.options.map({ String(format: "%.0f", $0) })
        } else {
            return task.options.map({ String(format: "%.\(decimalPoint)f", $0) })
        }
    }
    
    private func setButtonsToInitialState(_ initialState: UIButton?) {
        optionButtons.forEach( {
            $0.isEnabled = true
            $0.transform = CGAffineTransform(a: 1.0, b: 0.0, c: 0.0, d: 1.0, tx: 0.0, ty: 0.0)
            $0.tintColor = UIColor.systemPurple
            $0.setTitleColor(UIColor.systemPurple, for: .normal)
        })
    }
    
    private func showResults() {
        let vc = ResultsTableViewController()
        if let flow = flow {vc.updateFlow(flow)}
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}

