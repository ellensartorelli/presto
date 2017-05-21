//  DailyLogViewController.swift
//  presto_v0
//
//  Created by Ellen Sartorelli on 4/26/17.
//  Copyright © 2017 Ellen Sartorelli. All rights reserved.
//

import UIKit
import CoreData
import JTAppleCalendar
import UserNotifications

class DailyLogViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate, UNUserNotificationCenterDelegate {
    
    //MARK: - Core Data
    
    private var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!
    var request = NSFetchRequest<NSFetchRequestResult>(entityName:"Item")
    
    private let items = ItemCollection(){
        //print("Core Data connected")
    }
    
    // MARK: - Properties
    
    var date = Date()
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var messageLabel: UILabel!
    
    //miniCalendar properties
    let formatter = DateFormatter()
    @IBOutlet weak var currentDateLabel: UILabel!
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    // MARK: - View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCalendar()
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(self.tableView)
        self.initializeFetchResultsController()
        calendarView.scrollToDate(Date())

        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem
        editButtonItem.tintColor = UIColorFromRGB(rgbValue: 2781306)
        print(launch)
        if (launch == "first time launch") {
            let alertController = UIAlertController(title: "Welcome to your Daily Log!", message: "Tap ‘+’ to add items and swipe left to delete them. Won’t get to a task today? Swipe left to migrate the task to tomorrow.", preferredStyle: UIAlertControllerStyle.alert)
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
            {
                (result : UIAlertAction) -> Void in
                print("You pressed OK")
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    // MARK: - Core data

    func initializeFetchResultsController(){
        
        self.request.predicate = generatePredicate(date: Date())

        self.request.sortDescriptors = [NSSortDescriptor(key: "type", ascending: true)]
        
        let moc = items.managedObjectContext
        // Create Fetched Results Controller
        fetchedResultsController = NSFetchedResultsController(fetchRequest: self.request, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        
        //fetch data
        do {
            try fetchedResultsController.performFetch()
        }catch{
            fatalError("Failed to fetch data")
        }
    }
    
    func generatePredicate(date: Date) -> NSPredicate {
        /*
            Make predicate to fetch items for correct date
        */
        //Seting up predicate formatting
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        
        let dateFrom = calendar.startOfDay(for: date) // eg. 2016-10-10 00:00:00
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute],from: dateFrom)
        components.day! += 1
        let dateTo = calendar.date(from: components)! // eg. 2016-10-11 00:00:00
        
        // Set predicate as date being selected date
        let datePredicate = NSPredicate(format: "(%@ <= time) AND (time < %@)", argumentArray: [dateFrom, dateTo])
        
        return datePredicate
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
    
    func handleDateChange(date: Date) {
        
        //Send predicate to request
        self.request.predicate = generatePredicate(date: date)
        
        //Fetch data
        do {
            try fetchedResultsController.performFetch()
        }catch{
            fatalError("Failed to fetch data")
        }
        //Reload view with new data
        tableView.reloadData()
    }

    
    //MARK: - Actions
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        if presentingViewController is UINavigationController{
            dismiss(animated: true, completion: nil)
        }else if let owningNavController = navigationController{
            owningNavController.popViewController(animated: true)
        }else{
            fatalError("View is not contained by a navigation controller")
        }
    }
    
    
    //MARK: - Alerts
    @IBAction func showAlert() {
        //alert sheet to allow user to pick between task, event and reflection
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
    
    
    //MARK: - setting color
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    
    //MARK: Private Functions
    
    func dateInPast() -> Bool{
        //disables '+' button for dates in past -- can't add items to a day that's past
        let selectedDate = date
        let today = Date.init()
        
     
        if(isDate(date1: selectedDate, date2: today)){
            return false
        }else{
            return date < Date.init()
        }

    }
    
    func isDate(date1: Date, date2: Date) -> Bool{
        //function for comparing 2 dates, complicated between Date includes time
        let calendar = Calendar.current
        let Day1 = calendar.component(.day, from: date1)
        let Month1 = calendar.component(.month, from: date1)
        let Year1 = calendar.component(.year, from: date1)
        
        let Day2 = calendar.component(.day, from: date2)
        let Month2 = calendar.component(.month, from: date2)
        let Year2 = calendar.component(.year, from: date2)
        
        if (Day1 == Day2 && Month1 == Month2 && Year1 == Year2){
            return true
        }
        else{
            return false
        }
    }

    
    // MARK: - Table view data source functions
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController?.sections else{
            return 0
        }

        let sectionInfo = sections[section]
    
        if(dateInPast() == true){
            //if past date
            if(sectionInfo.numberOfObjects == 0){
                //if empty
                tableView.isHidden = true
                messageLabel.text = "You had no items on your Daily Log this day."
                addButton.isEnabled = false
                messageLabel.isHidden = false
            }else{
                tableView.isHidden = false
                addButton.isEnabled = false
                messageLabel.isHidden = true
            }
        }else{
            //future or today
            if(sectionInfo.numberOfObjects == 0){
                //if empty
                addButton.isEnabled = true
                tableView.isHidden = true
                messageLabel.text = "Tap '+' to add an item"
                messageLabel.isHidden = false
            }else{
                addButton.isEnabled = true
                tableView.isHidden = false
                messageLabel.isHidden = true
            }
        }
        

        
        return sectionInfo.numberOfObjects

    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // get one of our custom cells, building or reusing as needed
        guard let item = self.fetchedResultsController.object(at: indexPath) as? Item else{
            fatalError("Cannot find item")
        }
        
        //select cell type depending on item "type"
        switch item.type! {
        case "task":
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as? DailyLogTaskTableViewCell else{
                fatalError("Can't get cell of the right kind")
            }
            
            cell.configureCell(item: item)
            
            return cell
        case "event":
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as? DailyLogEventTableViewCell else{
                fatalError("Can't get cell of the right kind")
            }
            
            cell.configureCell(item: item)
            
            return cell
        case "reflection":
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "reflectionCell", for: indexPath) as? DailyLogReflectionTableViewCell else{
                fatalError("Can't get cell of the right kind")
            }

            cell.configureCell(item: item)
            
            return cell
        default:
            print("Cannot read cell type")
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "reflectionCell", for: indexPath) as? DailyLogReflectionTableViewCell else{
                fatalError("Can't get cell of the right kind")
            }
            
            cell.configureCell(item: item)
            return cell
        }

 
    }
    

    /* Provides the edit functionality (deleting rows) */
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            guard let item = self.fetchedResultsController?.object(at: indexPath) as? Item else{
                fatalError("Cannot find item")
            }
            items.delete(item)
        }
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        guard let item = self.fetchedResultsController.object(at: indexPath) as? Item else{
            fatalError("Cannot find item")
        }
        
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            self.items.delete(item)
            
            if(item.type == "task" && item.alert == true){
                //delete notification
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers:[item.text!])
            }

            
        }
        delete.backgroundColor = UIColor.red
        
        switch item.type! {
        case "task":
        
            let migrate = UITableViewRowAction(style: .normal, title: "Migrate") { action, index in

                var dateComponent = DateComponents()
                
                dateComponent.day = 1
                
                let futureDate = Calendar.current.date(byAdding: dateComponent, to: item.time as! Date)
                item.time = futureDate as NSDate?
                
                if(item.alert == true){
                    //delete notification
                    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers:[item.text!])
                }
            }
            migrate.backgroundColor = UIColor.lightGray
            
            
            return [delete, migrate]
       
        default:
            return [delete]
        }
    }
    
    
    // MARK: Connect tableview to fetched results controller

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }

    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
        
    }
    

    // MARK: - Navigation
    
    // prepare to go to the detail view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        switch(segue.identifier ?? ""){
        case "taskSegue":
            guard let navController = segue.destination as? UINavigationController else{
                fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let destination = navController.topViewController as? DailyTaskTableViewController else{
                fatalError("Unexpected destination: \(segue.destination)")
            }
            destination.type = .new
            destination.callback = { (text, type, time, completed, alert) in
                self.items.add(text:text, type:type, time: time, completed:completed, alert:alert)
            }
            
        case "ShowDetailTask":
            
            guard let destination = segue.destination as? DailyTaskTableViewController else{
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let cell = sender as? DailyLogTaskTableViewCell else{
                fatalError("Unexpected sender: \(sender)")
            }
            
            guard let indexPath = tableView.indexPath(for: cell) else{
                fatalError("The selected cell can't be found")
            }
            
            
            guard let item = fetchedResultsController?.object(at: indexPath) as? Item else{
                fatalError("fetched object was not an Item")
            }
            item.completed = cell.taskButtonDo.isHidden

            destination.type = .updating(item.text!, item.time as Date? ?? Date.init(), item.completed, item.alert)
            destination.callback = { (text, type, time, completed, alert) in
                self.items.updateTask(oldItem: item, text: text, time: time, completed: cell.taskButtonDo.isHidden, alert: alert)
            }
        case "eventSegue":
            guard let navController = segue.destination as? UINavigationController else{
                fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let destination = navController.topViewController as? DailyLogEventTableViewController else{
                fatalError("Unexpected destination: \(segue.destination)")
            }
            destination.type = .new
            destination.callback = { (text, type, time, completed, alert) in
                self.items.add(text:text, type:type, time: time, completed:completed, alert:alert)
            }
        case "ShowDetailEvent":
            
            guard let destination = segue.destination as? DailyLogEventTableViewController else{
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let cell = sender as? DailyLogEventTableViewCell else{
                fatalError("Unexpected sender: \(sender)")
            }
            
            guard let indexPath = tableView.indexPath(for: cell) else{
                fatalError("The selected cell can't be found")
            }
            
            
            guard let item = fetchedResultsController?.object(at: indexPath) as? Item else{
                fatalError("fetched object was not an Item")
            }
            item.completed = cell.eventButtonIncomplete.isHidden
            destination.type = .updatingEvent(item.text! as String, (item.time! as NSDate) as Date)
            destination.callback = { (text, type, time, completed, alert) in
                self.items.updateTask(oldItem: item, text: text, time: time, completed: cell.eventButtonIncomplete.isHidden, alert: alert)
            }
        case "reflectionSegue":
            guard let navController = segue.destination as? UINavigationController else{
                fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let destination = navController.topViewController as? DailyLogReflectionViewController else{
                fatalError("Unexpected destination: \(segue.destination)")
            }
            destination.type = .new
            destination.callback = { (text, type, time, completed, alert) in
                self.items.add(text:text, type:type, time: time, completed:completed, alert:alert)
            }
        case "ShowDetailReflection":
            
            guard let destination = segue.destination as? DailyLogReflectionViewController else{
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let cell = sender as? DailyLogReflectionTableViewCell else{
                fatalError("Unexpected sender: \(sender)")
            }
            
            guard let indexPath = tableView.indexPath(for: cell) else{
                fatalError("The selected cell can't be found")
            }
            
            
            guard let item = fetchedResultsController?.object(at: indexPath) as? Item else{
                fatalError("fetched object was not an Item")
            }
            
            destination.type = .updatingReflection(item.text!)
            destination.callback = { (text, type, time, completed, alert) in
                self.items.updateReflection(oldItem: item, text: text, time: time, completed: completed, alert: alert)
            }
            
     
        default:
            fatalError("Unexpected segue identifier: \(segue.identifier)")
        }
    
    }
    

    @IBAction func unwindFromEdit(sender: UIStoryboardSegue){
        //unwindFromTask^
        tableView.reloadData()
    }
    
    @IBAction func unwindFromEvent(sender: UIStoryboardSegue){
        tableView.reloadData()
    }
    
    @IBAction func unwindFromReflection(sender: UIStoryboardSegue){
        tableView.reloadData()
    }
    
}


//MARK: - Mini Calendar

extension DailyLogViewController: JTAppleCalendarViewDelegate{
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        let startDate = Date()
        
        let minute:TimeInterval = 60.0
        let hour:TimeInterval = 60.0 * minute
        let day:TimeInterval = 24 * hour
        let month:TimeInterval = 31*day
        let year:TimeInterval = 12*month
        let endDate =  Date(timeInterval: year, since: Date())
        
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate, numberOfRows: 1)
        return parameters
    }
    
    
}

extension DailyLogViewController: JTAppleCalendarViewDataSource{
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "MiniCalendarCustomCell", for: indexPath) as! MiniCalendarCustomCell
        cell.dateLabel.text = cellState.text

        if cellState.isSelected{
            cell.dateLabel.font = UIFont.systemFont(ofSize: 17.0)
            cell.selectedView.backgroundColor = UIColor(red:0.84, green:0.71, blue:0.32, alpha:1.0)
            cell.selectedView.isHidden = false
            cell.dateLabel.textColor = UIColor.white
            
        }else{
            cell.dateLabel.font = UIFont.systemFont(ofSize: 17.0)
            cell.selectedView.isHidden = true
            cell.dateLabel.textColor = UIColor.black
            
        }
        
        if (isDate(date1: date, date2: Date())){
            cell.dateLabel.textColor = UIColorFromRGB(rgbValue: 2781306)
            cell.dateLabel.font = UIFont.boldSystemFont(ofSize: 17.0)
        }
        return cell
    }
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        guard let validCell = cell as? MiniCalendarCustomCell else {return}
        validCell.selectedView.isHidden = false
        validCell.selectedView.backgroundColor = UIColor(red:0.84, green:0.71, blue:0.32, alpha:1.0)
        validCell.dateLabel.textColor = UIColor.white
        if (isDate(date1: date, date2: Date())){
            validCell.selectedView.backgroundColor = UIColorFromRGB(rgbValue: 2781306)
            validCell.dateLabel.font = UIFont.boldSystemFont(ofSize: 17.0)

        }
        //setup labels
        formatter.dateStyle = .long
        currentDateLabel.text = formatter.string(from:date)
        
        //update Daily log property date
        self.date = date
        
        //reload data
        handleDateChange(date: date)

        
    }
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        guard let validCell = cell as? MiniCalendarCustomCell else {return}
        validCell.selectedView.isHidden = true
        validCell.dateLabel.textColor = UIColor.black
        if (isDate(date1: date, date2: Date())){
            validCell.dateLabel.textColor = UIColorFromRGB(rgbValue: 2781306)
            validCell.dateLabel.font = UIFont.boldSystemFont(ofSize: 17.0)

        }
    }
    
    
}
