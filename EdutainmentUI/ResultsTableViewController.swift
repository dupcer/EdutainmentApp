//
//  ResultsTableViewController.swift
//  EdutainmentUI
//
//  Created by Damie on 08.10.2022.
//

import UIKit

class ResultsTableViewController: UITableViewController, GameVCDelegate {
    
    private var flow: Flow?
    var isFlowNil: Bool {
        get {
            (flow == nil)
        }
    }
    
    func updateFlow(_ newFlow: Flow) {
        flow = newFlow
        if let results = flow?.getResultsTable() {
            resultTabel = results
        }
    }
    
    private var resultTabel: [ (
        varOne: Int,
        varTwo: Int,
        operation: Game.OperationType,
        correctAnswer: Float,
        wasCorrectAnswerGiven: Bool
    )] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        resultTabel.count
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection
                            section: Int) -> String? {
        if let score = flow?.getResult()["score"], let all = flow?.getResult()["allIterations"] {
            let percent: Double = Double((100 * score) / all)
            return "Result: \(score) / \(all) (\(Int(percent))%)"
        }
        return "Result"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ResultCell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell", for: indexPath)
        
        let textForCell: String =
        String(resultTabel[indexPath.row].varOne) + " " +
        String(resultTabel[indexPath.row].operation.rawValue) + " " +
        String(resultTabel[indexPath.row].varTwo) + " = " +
        String(resultTabel[indexPath.row].correctAnswer)
        
        var content = cell.defaultContentConfiguration()
        content.text = textForCell
        
        if resultTabel[indexPath.row].wasCorrectAnswerGiven {
            content.textProperties.color = .green
        } else {
            content.textProperties.color = .red
        }
        
        cell.contentConfiguration = content
        
        return cell
    }
    
    
}
