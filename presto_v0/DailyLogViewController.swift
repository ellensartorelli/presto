//
//  DailyLogViewController.swift
//  presto_v0
//
//  Created by Ellen Sartorelli on 4/26/17.
//  Copyright © 2017 Ellen Sartorelli. All rights reserved.
//

import UIKit
import os.log
import JTAppleCalendar

class DailyLogViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var reflections = [DailyLogReflection]()
    var events = [DailyLogEvent]()
    var tasks = [DailyLogTask]()
    var date = Date()
    
    //miniCalendar properties
    let formatter = DateFormatter()
    @IBOutlet weak var currentDateLabel: UILabel!
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCalendar()

        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(self.tableView)
        
        // Do any additional setup after loading the view.
        

        if let savedDailyLogEvents = loadDailyLogEvents() {
            events += savedDailyLogEvents
        }
        else {
            // Load the sample data.
            loadSampleEvents()
        }
        

        if let savedTasks = loadDailyLogTasks() {
            tasks += savedTasks
        } else{
            loadSampleTasks()
        }

        loadSampleReflections()
        
        
        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem
        editButtonItem.tintColor = UIColorFromRGB(rgbValue: 2781306)
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - MiniCalendar
    func setupCalendar(){
        calendarView.minimumLineSpacing=0
        calendarView.minimumInteritemSpacing=0
        
        //setup labels
        calendarView.visibleDates{(visibleDates) in

            self.formatter.dateStyle = .long
            self.currentDateLabel.text = self.formatter.string(from:self.date)
        }
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
            
            cell.taskButtonDo.isHidden = task.completed
            cell.taskButtonDone.isHidden = !task.completed
            cell.taskLabel.text = task.title
            
            return cell
        }
        else if indexPath.row >= tasks.count && indexPath.row < tasks.count + events.count {
            let cell: DailyLogEventTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! DailyLogEventTableViewCell
            //set the data here
            let event = events[indexPath.row - tasks.count]
 
            let calendar = Calendar.current
            let hour = calendar.component(.hour, from: event.time)
            
            let amPM = (hour > 11) ? "pm" : "am"
            
            let minute = calendar.component(.minute, from: event.time)
            let eventTimeString = "\(hour%12):\(String(format: "%02d", minute)) \(amPM), "
            
            cell.eventButtonIncomplete.isHidden = event.completed
            cell.eventButtonComplete.isHidden = !event.completed
            cell.eventLabel.text = eventTimeString + event.title

            return cell
        }
        else {
            let cell: DailyLogReflectionTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "reflectionCell", for: indexPath) as! DailyLogReflectionTableViewCell
            //set the data here
            let reflection = reflections[indexPath.row - tasks.count - events.count]
            cell.reflectionText.text = reflection.reflection
            print("printing the reflection.reflection from DLVC: \(reflection.reflection)")
            
            return cell
        }
    }
    
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        print("index path:")
        print(indexPath.row)
        print("")
        if editingStyle == .delete {
            // Delete the row from the data source
            if indexPath.row < tasks.count{
                tasks.remove(at: indexPath.row)
                saveDailyLogTasks()
            } else if indexPath.row >= tasks.count && indexPath.row < tasks.count + events.count {
                events.remove(at: indexPath.row - tasks.count)
                saveDailyLogEvents()
            } else{
                reflections.remove(at: indexPath.row - (events.count + tasks.count))
            }

            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    // Override to support conditional editing of the table view.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        //we don't want the user to delete the calendar
        return true
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
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
        alertController.view.tintColor = UIColorFromRGB(rgbValue: 2781306)

        present(alertController, animated: true, completion: nil)
        
    }
    
    

   
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? ""){
        case "eventSegue":
            os_log("Adding a event", log: OSLog.default, type: .debug)
        case "taskSegue":
            os_log("Adding a task", log: OSLog.default, type: .debug)
        case "reflectionSegue":
            os_log("Adding a reflection", log: OSLog.default, type: .debug)
        case "ShowDetailEvent":
            guard let eventDetailViewController = segue.destination as? DailyLogEventTableViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedEventCell = sender as? DailyLogEventTableViewCell else {
                fatalError("Unexpected sender: \(sender)")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedEventCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedEvent = events[indexPath.row - tasks.count]
            eventDetailViewController.event = selectedEvent
            
        case "ShowDetailTask":
            guard let taskDetailViewController = segue.destination as? DailyTaskTableViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedTaskCell = sender as? DailyLogTaskTableViewCell else {
                fatalError("Unexpected sender: \(sender)")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedTaskCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedTask = tasks[indexPath.row]
            taskDetailViewController.task = selectedTask
            
        case "ShowDetailReflection":
            guard let reflectionDetailViewController = segue.destination as? DailyLogReflectionViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedReflectionCell = sender as? DailyLogReflectionTableViewCell else {
                fatalError("Unexpected sender: \(sender)")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedReflectionCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedReflection = reflections[indexPath.row - events.count - tasks.count]
            reflectionDetailViewController.reflection = selectedReflection
            
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier)")
            
        }
    }
    
    //MARK: Actions
    @IBAction func unwindToTaskList(sender: UIStoryboardSegue) {
        
        if let sourceViewController = sender.source as? DailyTaskTableViewController, let task = sourceViewController.task {
        
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing meal.
                tasks[selectedIndexPath.row] = task
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else{
                let newIndexPath = IndexPath(row: tasks.count, section: 0)
                
                tasks.append(task)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
                
            }
            // Save the taks.
            saveDailyLogTasks()

        }
    
    }
    
    @IBAction func unwindToReflectionList(sender: UIStoryboardSegue) {
        
        if let sourceViewController = sender.source as? DailyLogReflectionViewController, let reflection = sourceViewController.reflection {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                reflections[selectedIndexPath.row - tasks.count - events.count] = reflection
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else{
                let newIndexPath = IndexPath(row: reflections.count + tasks.count + events.count, section: 0)
                
                reflections.append(reflection)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
                
            }
        }
        
    }
 
    
// MARK: Actions
    @IBAction func unwindToDailyLogEvent(sender: UIStoryboardSegue) {
        
        if let sourceViewController = sender.source as?
            DailyLogEventTableViewController, let event = sourceViewController.event{
            
            // Add a new meal.
            if let selectedIndexPath = tableView.indexPathForSelectedRow{
                events[selectedIndexPath.row - tasks.count] = event
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else{
                let newIndexPath = IndexPath(row: events.count+tasks.count, section: 0)
                
                events.append(event)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            saveDailyLogEvents()
        }
    }
 
    //MARK: Private methods
    
    private func loadSampleReflections(){
        print("called Reflections")
        
        guard let ref1 = DailyLogReflection(reflection: "Today was a long and overcast day", date: Date.init()) else {
            fatalError("Unable to instantiate reflection")
        }
        
        guard let ref2 = DailyLogReflection(reflection: "I wonder if Sean Kingston actually sounds good live?", date: Date.init()) else {
            fatalError("Unable to instantiate reflection")
        }
        
        
        reflections += [ref1, ref2]
        print(reflections.count)
    }
    
    
    private func loadSampleEvents(){
        print("called Events")
        
        guard let ev1 = DailyLogEvent(title: "Dinner with Joy", time: Date.init(), completed: true) else {
            fatalError("Unable to instantiate event")
        }
        guard let ev2 = DailyLogEvent(title: "Shannia thesis presentation", time: Date.init(), completed: false) else {
            fatalError("Unable to instantiate event")
        }
        
        events += [ev1, ev2]
        print(events.count)
    }
    
    
    private func loadSampleTasks(){
        print("called Tasks")
        
        guard let task1 = DailyLogTask(title: "Finish CS466 App", alert: false, alertTime: Date.init(), completed: true) else {
            fatalError("Unable to instantiate task")
        }
        guard let task2 = DailyLogTask(title: "Call Mom", alert: false, alertTime: Date.init(), completed: false) else {
            fatalError("Unable to instantiate task")
        }
        guard let task3 = DailyLogTask(title: "Buy more food", alert: false, alertTime: Date.init(), completed: true) else {
            fatalError("Unable to instantiate task")
        }
        
        tasks += [task1, task2, task3]
        print(tasks.count)
    }


    
    private func saveDailyLogEvents() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(events, toFile: DailyLogEvent.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("DLEvents successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save DLEvents...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadDailyLogEvents() -> [DailyLogEvent]?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: DailyLogEvent.ArchiveURL.path) as? [DailyLogEvent]
    }

    private func saveDailyLogTasks() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(tasks, toFile: DailyLogTask.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("DL Tasks successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save DL tasks...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadDailyLogTasks() -> [DailyLogTask]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: DailyLogTask.ArchiveURL.path) as? [DailyLogTask]

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


extension DailyLogViewController: JTAppleCalendarViewDelegate{
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        let startDate = Date()
        let endDate = formatter.date(from: "2017 12 31")!
        
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate, numberOfRows: 1)
        return parameters
    }
    
    
}

extension DailyLogViewController: JTAppleCalendarViewDataSource{
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "MiniCalendarCustomCell", for: indexPath) as! MiniCalendarCustomCell
        cell.dateLabel.text = cellState.text
        if cellState.isSelected{
            cell.selectedView.isHidden = false
            cell.dateLabel.textColor = UIColor.white
            
        }else{
            cell.selectedView.isHidden = true
            cell.dateLabel.textColor = UIColor.black
            
        }
        return cell
    }
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        guard let validCell = cell as? MiniCalendarCustomCell else {return}
        validCell.selectedView.isHidden = false
        validCell.dateLabel.textColor = UIColor.white
        
        //setup labels
        formatter.dateStyle = .long
        currentDateLabel.text = formatter.string(from:date)
        
    }
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        guard let validCell = cell as? MiniCalendarCustomCell else {return}
        validCell.selectedView.isHidden = true
        validCell.dateLabel.textColor = UIColor.black
        
        
    }
    
    
}
