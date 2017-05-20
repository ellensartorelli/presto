//
//  DailyLogViewController.swift
//  presto_v0
//
//  Created by Ellen Sartorelli on 4/26/17.
//  Copyright © 2017 Ellen Sartorelli. All rights reserved.
//

import UIKit
import CoreData
import JTAppleCalendar

class DailyLogViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    private var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!
    
    var request = NSFetchRequest<NSFetchRequestResult>(entityName:"Item")
    
    private let items = ItemCollection(){
        print("Core Data connected")
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

        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem
        editButtonItem.tintColor = UIColorFromRGB(rgbValue: 2781306)
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
    
    
    //MARK: - setting color
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    
    //MARK: - disable past dates in future log
    func dateInPast() -> Bool{
        return date < Date()
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
    
        print("date in past is \(dateInPast())")
        if(dateInPast() == true){
            //if past date
            if(sectionInfo.numberOfObjects == 0){
                //if empty
                print("hiding table, showing label")
                tableView.isHidden = true
                messageLabel.text = "You had no items on your Daily Log this day."
                addButton.isEnabled = false
                messageLabel.isHidden = false
            }else{
                print("hiding label, showing table")
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
                messageLabel.text = "Tap '+' to add an item!"
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
        
        
        
        switch item.type! {
        case "task":
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as? DailyLogTaskTableViewCell else{
                fatalError("Can't get cell of the right kind")
            }
            
//            self.items.updateTask(oldItem: item, text: item.text!, time: item.time as! Date, completed: cell.taskButtonDone.isHidden, alert: item.alert)
            
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
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as? DailyLogEventTableViewCell else{
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

            destination.type = .updating(item.text!, item.time as Date? ?? Date.init(), item.completed, item.alert)
            destination.callback = { (text, type, time, completed, alert) in
                self.items.updateTask(oldItem: item, text: text, time: time, completed: completed, alert: alert)
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
            
            destination.type = .updatingEvent(item.text! as String, (item.time! as NSDate) as Date)
            destination.callback = { (text, type, time, completed, alert) in
                self.items.updateTask(oldItem: item, text: text, time: time, completed: completed, alert: alert)
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
    
    /* This is here so that we have something to return to. It doesn't actually provide much functionality since the tableView is already tied to the fetched results controller. */
    @IBAction func unwindFromEdit(sender: UIStoryboardSegue){
        tableView.reloadData()
    }
    
    @IBAction func unwindFromEvent(sender: UIStoryboardSegue){
        tableView.reloadData()
    }
    
    @IBAction func unwindFromReflection(sender: UIStoryboardSegue){
        tableView.reloadData()
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
        
        //update Daily log property date
        self.date = date
        
        //reload data
        handleDateChange(date: date)

        
    }
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        guard let validCell = cell as? MiniCalendarCustomCell else {return}
        validCell.selectedView.isHidden = true
        validCell.dateLabel.textColor = UIColor.black
    }
    
    
}
