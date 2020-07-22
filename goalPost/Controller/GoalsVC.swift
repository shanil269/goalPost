//
//  GoalsVC.swift
//  goalPost
//
//  Created by Muhaimin on 3/7/20.
//  Copyright © 2020 Muhaimin. All rights reserved.
//

import UIKit
import CoreData
let appDelegate = UIApplication.shared.delegate as? AppDelegate

class GoalsVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var goals: [Goal] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isHidden = false
        fetchCoreDataObject {
            DispatchQueue.main.async {
                print("view will appear")
                self.fetchCoreDataObject() {
                    self.tableView.reloadData()
                    
                }
                
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func fetchCoreDataObject(completion: () -> ()) {
        self.fetch { (complete) in
            if complete {
                if goals.count >= 1 {
                    tableView.isHidden = false
                    
                }else {
                    tableView.isHidden = true
                }
            }
            completion()
        }
    }
    
    @IBAction func addGoalBtnPressed(_ sender: Any) {
        guard let createGoalVC = storyboard?.instantiateViewController(withIdentifier: "CreateGoalVC") as? CreateGoalVC else {
            return
        }
        //        presentDetail(createGoalVC)
        present(createGoalVC, animated: true) {
            createGoalVC.dismissClosure = {
                DispatchQueue.main.async {
                    print("view will appear")
                    self.dismiss(animated: true) {
                        self.fetchCoreDataObject() {
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
}
extension GoalsVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goals.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "goalCell") as? GoalCell
            else { return UITableViewCell() }
        let goal = goals[indexPath.row]
        cell.configureCell(goal: goal)
        return cell
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "DELETE") { (rowAction, IndexPath) in
            self.removeGoal(atIndexPath: IndexPath)
            self.fetchCoreDataObject() {
                tableView.deleteRows(at: [IndexPath], with: .automatic)
            }
        }
        let addAction = UITableViewRowAction(style: .normal, title: "ADD 1") { (rowAction, IndexPath) in
            self.setProgress(atIndexPath: indexPath)
            tableView.reloadRows(at: [IndexPath], with: .automatic)
        }
        addAction.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        deleteAction.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        
        return [deleteAction, addAction]
    }
}
extension GoalsVC {
    func setProgress(atIndexPath indexPath: IndexPath) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {return}
        
        let chosenGoal = goals[indexPath.row]
        if chosenGoal.goalProgress < chosenGoal.goalCompletionValue {
            chosenGoal.goalProgress = chosenGoal.goalProgress + 1
        }else {
            return
        }
        do {
            try managedContext.save()
            print("successfully set progress")
        } catch  {
            debugPrint("Could not set Progress: \(error.localizedDescription)")
        }
    }
    func removeGoal(atIndexPath indexPath: IndexPath) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {return}
        managedContext.delete(goals[indexPath.row])
        
        do {
            try managedContext.save()
            print("successfully remove goal")
        } catch  {
            debugPrint("Could not remove: \(error.localizedDescription)")
        }
    }
    
    func fetch(completion: (_ complete: Bool) -> ()) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        let fetchRequest = NSFetchRequest<Goal>(entityName: "Goal")
        
        do {
            goals = try managedContext.fetch(fetchRequest)
            print("Successfully passed data")
            completion(true)
        } catch {
            debugPrint("Could not fetch: \(error.localizedDescription)")
            completion(false)
        }
    }
}
