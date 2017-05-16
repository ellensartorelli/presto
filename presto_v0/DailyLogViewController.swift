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
    
    
    // MARK: - View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCalendar()
        updateView()
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(self.tableView)
        print("initilize FRC")
        self.initializeFetchResultsController()

        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem
        editButtonItem.tintColor = UIColorFromRGB(rgbValue: 2781306)
    }
    
    /*
     Initialize the fetched results controller
     
     We configure this to fetch all of the items
     */
    func initializeFetchResultsController(){
        
        // Create Fetch Request
        let request = NSFetchRequest<NSFetchRequestResult>(entityName:"Item")
        
        // Configure Fetch Request
        request.sortDescriptors = [NSSortDescriptor(key: "type", ascending: true)]
        
        let moc = items.managedObjectContext
        // Create Fetched Results Controller
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        }catch{
            fatalError("Failed to fetch data")
        }
    }
    

    
    // MARK: - Private Functions
   
    fileprivate func updateView() {
        var hasItems = false
        
        if let items = fetchedResultsController.fetchedObjects {
            hasItems = items.count > 0
        }
        
        tableView.isHidden = !hasItems
        messageLabel.isHidden = hasItems
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
    

    
    // MARK: - Table view data source functions
    
    /* Report the number of sections (managed by fetched results controller) */
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController?.sections else{
           return 0
        }
        
        let sectionInfo = sections[section]
        
        return sectionInfo.numberOfObjects

    }
    
    
    /* Get a table cell loaded with the right data for the entry at indexPath (section/row)*/
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // get one of our custom cells, building or reusing as needed
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as? DailyLogTaskTableViewCell else{
            fatalError("Can't get cell of the right kind")
        }
        
        guard let item = self.fetchedResultsController.object(at: indexPath) as? Item else{
            fatalError("Cannot find item")
        }
        
        cell.configureCell(item: item)
        
        return cell
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
        updateView()
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
            destination.callback = { (text, type, startDate) in
                self.items.add(text:text, type: type, startDate: startDate)
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
            
            destination.type = .update(item.text!, item.type!, item.startDate as! Date)
            destination.callback = { (text, type, startDate) in
                self.items.update(oldItem: item, text: text, type: type, startDate: startDate)
            }
            
            
        default:
            fatalError("Unexpeced segue identifier: \(segue.identifier)")
        }
    
    }
    
    /* This is here so that we have something to return to. It doesn't actually provide much functionality since the tableView is already tied to the fetched results controller. */
    @IBAction func unwindFromEdit(sender: UIStoryboardSegue){
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
        
    }
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        guard let validCell = cell as? MiniCalendarCustomCell else {return}
        validCell.selectedView.isHidden = true
        validCell.dateLabel.textColor = UIColor.black
    }
    
    
}
