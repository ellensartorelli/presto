//
//  HabitTrackerTableViewController.swift
//  HabitTracker
//
//  Created by Joy A Wood on 4/26/17.
//  Copyright © 2017 Joy A Wood. All rights reserved.
//

import UIKit
import os.log

class HabitTrackerTableViewController: UITableViewController {
   
    //MARK: Properties
    var habits = [Habit]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem
        editButtonItem.tintColor = UIColorFromRGB(rgbValue: 2781306)
        
        // Load any saved meals, otherwise load sample data.
        if let savedHabits = loadHabits() {
            if(savedHabits == []){
                loadSampleHabits()
            }
            habits += savedHabits
        }
        else {
            // Load the sample data.
            loadSampleHabits()
        }


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
    
    private func loadHabits() -> [Habit]?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Habit.ArchiveURL.path) as? [Habit]
    }
    
    private func saveHabits() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(habits, toFile: Habit.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Habits successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save habits...", log: OSLog.default, type: .error)
        }
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
            // Save the habits.
            saveHabits()
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
            
            // Add a new habit.
            
            let newIndexPath = IndexPath(row: habits.count, section: 0)
            
            habits.append(habit)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
        if let sourceViewController = sender.source as? HabitViewController, let habit = sourceViewController.habit {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing habit.
                habits[selectedIndexPath.row] = habit
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            
        }
        // Save the habits.
        saveHabits()
        
    }
    @IBAction func unwindToHabitListFromEdit(sender: UIStoryboardSegue) {
        
        if let sourceViewController = sender.source as? HabitViewController, let habit = sourceViewController.habit {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing habit.
                habits[selectedIndexPath.row] = habit
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            saveHabits()
            
        }
        
    }
    
    
    //MARK: - setting color
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

    
}
