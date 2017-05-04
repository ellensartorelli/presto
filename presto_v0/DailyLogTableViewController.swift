//
//  DailyLogTableViewController.swift
//  presto_v0
//
//  Created by Ellen Sartorelli on 4/26/17.
//  Copyright © 2017 Ellen Sartorelli. All rights reserved.
//

import UIKit

class DailyLogTableViewController: UITableViewController {
    
    
    
    
    
    
    
    
    
    
    
    
    
    // UnUSED
    
    
    
    
    
    
    
    
    
    
    //drag in table view
    var reflections = [DailyLogReflection]()
    var events = [DailyLogEvent]()
    var tasks = [DailyLogTask]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        loadSampleReflections()
        loadSampleTasks()
        loadSampleEvents()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //MARK: - Action
    
    
    @IBAction func showAlert() {
        
        
        let alertController = UIAlertController(title: "Select an item to add to your Daily Log", message: nil, preferredStyle: .actionSheet)
        
        
        let taskAction = UIAlertAction(title: "Task", style: .default, handler: { action in self.performSegue(withIdentifier: "taskSegue", sender: self)})
        let eventAction = UIAlertAction(title: "Event", style: .default, handler: { action in self.performSegue(withIdentifier: "eventSegue", sender: self)})
        let reflectionAction = UIAlertAction(title: "Reflection", style: .default, handler:{ action in self.performSegue(withIdentifier: "reflectionSegue", sender: self)})
        
        let defaultAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        alertController.addAction(taskAction)
        alertController.addAction(eventAction)
        alertController.addAction(reflectionAction)
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
    


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (tasks.count + events.count + reflections.count)
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("tableview reached")
        if indexPath.row < tasks.count{
            let cell:DailyLogTaskTableViewCell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! DailyLogTaskTableViewCell
            let task = tasks[indexPath.row]
            cell.taskLabel.text = task.title
            
            return cell
            
        } else if indexPath.row < tasks.count+events.count{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as? DailyLogEventTableViewCell  else {
                fatalError("The dequeued cell is not an instance of DailyLogTaskTableViewCell.")
            }
            let event = events[indexPath.row - tasks.count]
            cell.eventLabel.text = event.title
            
            return cell
            
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "reflectionCell", for: indexPath) as? DailyLogReflectionTableViewCell  else {
                fatalError("The dequeued cell is not an instance of DailyLogReflectionTableViewCell.")
            }
            let reflection = reflections[indexPath.row - tasks.count - events.count]
            cell.reflectionText.text = reflection.reflection
            
            return cell
        }
//        let cellIdentifier = "DailyLogReflection"
//        
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? DailyLogReflectionTableViewCell else {
//            fatalError("The dequeued cell is not a DailyLogReflectionTVCell")
//        }
//        
//        let reflection = reflections[indexPath.row]
//        
//        cell.reflectionText.text = reflection.reflection
//    
//        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    //MARK: Private methods
    
    private func loadSampleReflections(){

        guard let ref1 = DailyLogReflection(reflection: "Hello World", date: Date.init()) else {
            fatalError("Unable to instantiate reflection")
        }
        
        reflections += [ref1]
        
    }
    private func loadSampleEvents(){
        print("called Events")
        
        guard let ev1 = DailyLogEvent(title: "Hello World", time: Date.init()) else {
            fatalError("Unable to instantiate event")
        }
        
        events += [ev1]
        print(events.count)
    }
    private func loadSampleTasks(){
        print("called Tasks")
        
        guard let task1 = DailyLogTask(title: "task", alert: false, alertTime: Date.init()) else {
            fatalError("Unable to instantiate task")
        }
        guard let task2 = DailyLogTask(title: "task2", alert: false, alertTime: Date.init()) else {
            fatalError("Unable to instantiate task")
        }
        
        tasks += [task1, task2]
        print(tasks.count)
    }
    


}
