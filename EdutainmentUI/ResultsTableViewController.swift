//
//  ResultsTableViewController.swift
//  EdutainmentUI
//
//  Created by Damie on 08.10.2022.
//

import UIKit

class ResultsTableViewController: UITableViewController, GameVCDelegate {
    
    private var flow: GameFlow?
    var isFlowNil: Bool {
        get {
            (flow == nil)
        }
    }
    
    func updateFlow(_ newFlow: GameFlow) {
        flow = newFlow
        if let results = flow?.getResultsTable() {
            self.results = results
        }
    }
    
    private var results: [ResultItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? results.count : 1
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection
                            section: Int) -> String? {
        if section == 1 {
            return "Do you want to play again?"
        }
        
        if let score = flow?.getCurrentResult()["score"], let all = flow?.getCurrentResult()["allIterations"] {
            let percent: Double = Double((100 * score) / all)
            return "Result: \(score) / \(all) (\(Int(percent))%)"
        }
        return "Result"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 { return getResultTabelViewCell(tableView, cellForRowAt: indexPath) }
        else { return getActionButtonTabelViewCell(tableView, cellForRowAt: indexPath) }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 1, let vc = storyboard?.instantiateViewController(withIdentifier: "SettingsViewController") as? SettingsViewController {
//                // 2: success! Set its selectedImage property
//                vc.selectedImage = pictures[indexPath.row]
//
//                // 3: now push it onto the navigation controller
            navigationController?.pushViewController(vc, animated: true)
            }
    }
    
    private func getResultTabelViewCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ResultCell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell", for: indexPath)
        
        let textForCell: String =
        String(results[indexPath.row].varOne) + " " +
        String(results[indexPath.row].operation.rawValue) + " " +
        String(results[indexPath.row].varTwo) + " = " +
        String(results[indexPath.row].correctAnswer)
        
        var content = cell.defaultContentConfiguration()
        content.text = textForCell
        
        if results[indexPath.row].wasCorrectAnswerGiven {
            content.textProperties.color = .green
        } else {
            content.textProperties.color = .red
        }
        
        cell.contentConfiguration = content
        
        return cell
    }
    
    private func getActionButtonTabelViewCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ActionBtnCell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActionBtnCell", for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        content.text = "PLAY AGAIN"
        content.textProperties.color = .systemRed
        content.textProperties.alignment = .center
        content.textProperties.font = .boldSystemFont(ofSize: 30)
        content.textProperties.numberOfLines = 3
        
        cell.contentConfiguration = content
        return cell
    }
}
