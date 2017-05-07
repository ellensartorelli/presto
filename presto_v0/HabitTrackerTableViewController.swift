//
//  HabitTrackerTableViewController.swift
//  HabitTracker
//
//  Created by Joy A Wood on 4/26/17.
//  Copyright © 2017 Joy A Wood. All rights reserved.
//

import UIKit

class HabitTrackerTableViewController: UITableViewController {
    //MARK: Properties
    
    var habits = [Habit]()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem
        loadSampleHabits()


    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Private Methods
    
    private func loadSampleHabits() {
     
        guard let habit1 = Habit(name: "Running", startDate: Date()) else {
            fatalError("Unable to instantiate habit1")
        }
        
        guard let habit2 = Habit(name: "Drinking", startDate: Date()) else {
            fatalError("Unable to instantiate habit2")
        }
        
        
        habits += [habit1, habit2]
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return habits.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        // Configure the cell
        let cellIdentifier = "HabitTrackerHabitTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? HabitTrackerHabitTableViewCell  else {
            fatalError("The dequeued cell is not an instance of HabitTrackerHabitTableViewCell.")
        }
        
        // Fetches the appropriate meal for the data source layout.
        let habit = habits[indexPath.row]
        
        cell.HabitLabel.text = habit.name
        
        return cell
    }
    
    
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     
    
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            habits.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "Add Item":
            print("adding a habit")
        case "SequeToHabitView":
            guard let habitDetailViewController = segue.destination as? HabitViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedHabitCell = sender as? HabitTrackerHabitTableViewCell else {
                fatalError("Unexpected sender: \(sender)")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedHabitCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedHabit = habits[indexPath.row]
            habitDetailViewController.habit = selectedHabit
            
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier)")
        }
    }
    
    @IBAction func unwindToHabitList(sender: UIStoryboardSegue) {
        
        if let sourceViewController = sender.source as? HabitTrackerDetailViewController, let habit = sourceViewController.habit {
            print("unwinding "+habit.name)
            
            // Add a new habit.
            let newIndexPath = IndexPath(row: habits.count, section: 0)
            
            habits.append(habit)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
        if let sourceViewController = sender.source as? HabitViewController, let habit = sourceViewController.habit {
            print("unwinding "+habit.name)
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing habit.
                habits[selectedIndexPath.row] = habit
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
                print("unwinding "+habit.name)
            }
            
        }
        
    }
    @IBAction func unwindToHabitListFromEdit(sender: UIStoryboardSegue) {
        
        if let sourceViewController = sender.source as? HabitViewController, let habit = sourceViewController.habit {
            print("unwinding "+habit.name)
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing habit.
                habits[selectedIndexPath.row] = habit
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
                print("unwinding "+habit.name)
            }
            
        }
        
    }
}
