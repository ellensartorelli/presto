//
//  DailyLogViewController.swift
//  presto_v0
//
//  Created by Ellen Sartorelli on 4/26/17.
//  Copyright © 2017 Ellen Sartorelli. All rights reserved.
//

import UIKit
import os.log

class DailyLogViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var reflections = [DailyLogReflection]()
    var events = [DailyLogEvent]()
    var tasks = [DailyLogTask]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(self.tableView)
        
        // Do any additional setup after loading the view.
        
        loadSampleTasks()
        loadSampleEvents()
        loadSampleReflections()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Table View Data Source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count + events.count + reflections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < tasks.count {
            let cell: DailyLogTaskTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! DailyLogTaskTableViewCell
            //set the data here
            let task = tasks[indexPath.row]
            cell.taskLabel.text = task.title
            
            return cell
        }
        else if indexPath.row >= tasks.count && indexPath.row < tasks.count + events.count {
            let cell: DailyLogEventTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! DailyLogEventTableViewCell
            //set the data here
            let event = events[indexPath.row - tasks.count]
            cell.eventLabel.text = event.title
            
            return cell
        }
        else {
            let cell: DailyLogReflectionTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "reflectionCell", for: indexPath) as! DailyLogReflectionTableViewCell
            //set the data here
            let reflection = reflections[indexPath.row - tasks.count - events.count]
            cell.reflectionText.text = reflection.reflection
            
            return cell
        }
    }
    
    
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
    
    

   
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
 
    
    
    //MARK: Private methods
    
    private func loadSampleReflections(){
        print("called Reflections")
        
        guard let ref1 = DailyLogReflection(reflection: "ref", date: Date.init()) else {
            fatalError("Unable to instantiate reflection")
        }
        
        reflections += [ref1]
        print(reflections.count)
    }
    
    
    private func loadSampleEvents(){
        print("called Events")
        
        guard let ev1 = DailyLogEvent(title: "ev", time: Date.init()) else {
            fatalError("Unable to instantiate event")
        }
        guard let ev2 = DailyLogEvent(title: "ev2", time: Date.init()) else {
            fatalError("Unable to instantiate event")
        }
        
        events += [ev1, ev2]
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
        guard let task3 = DailyLogTask(title: "task3", alert: false, alertTime: Date.init()) else {
            fatalError("Unable to instantiate task")
        }
        
        tasks += [task1, task2, task3]
        print(tasks.count)
    }
    
    
// MARK: Actions
    @IBAction func unwindToDailyLogEvent(sender: UIStoryboardSegue) {
        
        if let sourceViewController = sender.source as?
            DailyLogEventTableViewController, let event = sourceViewController.event{
            
            // Add a new meal.
            if let selectedIndexPath = tableView.indexPathForSelectedRow{
                events[selectedIndexPath.row] = event
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else{
                let newIndexPath = IndexPath(row: events.count, section: 0)
                
                events.append(event)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        }
    }
    
    @IBAction func unwindToReflection(sender: UIStoryboardSegue) {
        print("clicked save from daily log")
        if let sourceViewController = sender.source as? DailyLogReflectionViewController, let reflection = sourceViewController.reflection {
            
            // Add a new meal.
            let newIndexPath = IndexPath(row: reflections.count, section: 0)
            
            reflections.append(reflection)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
//        self.performSegue(withIdentifier: "unwindFromDailyLogReflectionViewController", sender: self)
    }

}
