//
//  FutureLogTableViewController.swift
//  presto_v0
//
//  Created by Ellen Sartorelli on 4/24/17.
//  Copyright © 2017 Ellen Sartorelli. All rights reserved.
//

import UIKit
import os.log


class FutureLogTableViewController: UITableViewController {
    
    //MARK: - Properties
    
    var events = [FutureLogEvent]()

    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var emptyView: UIView!
    
    //MARK: - View

    override func viewDidLoad() {
        super.viewDidLoad()
        events = events.sorted(by: { $0.startDate.compare($1.startDate) == .orderedAscending })

        if let savedEvents = loadFutureLogEvents(){
            events += savedEvents
            events = events.sorted(by: { $0.startDate.compare($1.startDate) == .orderedAscending })
            updateView()
        }
        
        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem
        editButtonItem.tintColor = UIColorFromRGB(rgbValue: 2781306)
   
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "FutureLogTableViewCell"

        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? FutureLogTableViewCell  else {
            fatalError("The dequeued cell is not an instance of FutureLogEventTableViewCell.")
        }
        
        // Fetches the appropriate event for the data source layout.
        let event = events[indexPath.row]
        
        let calendar = Calendar.current
        let day = calendar.component(.day, from:event.startDate)
        let month = calendar.component(.month, from:event.startDate)
        let year = calendar.component(.year, from:event.startDate)
        
        cell.eventLabel.text = event.title
        cell.dayLabel.text = "\(month)/\(day)/\(year%100)"
        
        if(dateInPast(date: event.startDate) == true){
            cell.eventLabel.textColor = UIColor.lightGray
            cell.dayLabel.textColor = UIColor.lightGray
            
            events.remove(at: indexPath.row)
            saveFutureLogEvents()
            tableView.reloadData()
        }

        return cell
    }
    
    //MARK: - Private Functions
    
    func dateInPast(date: Date) -> Bool{
        /*
         Determine if a date is less than another date. *complicated due to time aspect in Date type*
         */
        let selectedDate = date
        let today = Date.init()
        
        let calendar = Calendar.current
        
        let selectedDay = calendar.component(.day, from: selectedDate)
        let selectedMonth = calendar.component(.month, from: selectedDate)
        let selectedYear = calendar.component(.year, from: selectedDate)
        
        let calendar2 = Calendar.current
        
        let todayDay = calendar2.component(.day, from: today)
        let todayMonth = calendar2.component(.month, from: today)
        let todayYear = calendar2.component(.year, from: today)
        
        if(selectedDay == todayDay && selectedMonth == todayMonth && selectedYear == todayYear){
            return false
        }else{
            return date < Date.init()
        }
    }
    
    func updateView(){
        /*
        Show empty set instruction if no events in Future Log
        */
        if(events.count == 0){
            messageLabel.isHidden = false
            emptyView.isHidden = false
        }else{
            messageLabel.isHidden = true
            emptyView.isHidden = true
        }
    }
    
    
    
    //MARK: Actions
    @IBAction func unwindToEventList(sender: UIStoryboardSegue){
        
        if let sourceViewController = sender.source as?
            FutureLogEventViewController, let event = sourceViewController.event{
        
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow{
                events[selectedIndexPath.row] = event
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else{
                let newIndexPath = IndexPath(row: events.count, section: 0)
                
                events.append(event)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
                
            }
            saveFutureLogEvents()
        }
        //sort months
        events = events.sorted(by: { $0.startDate.compare($1.startDate) == .orderedAscending })

        updateView()
        tableView.reloadData()
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
            events.remove(at: indexPath.row)
            saveFutureLogEvents()
            tableView.deleteRows(at: [indexPath], with: .fade)
            updateView()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
 

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? ""){
            case "AddItem":
                os_log("Adding a new event", log: OSLog.default, type: .debug)
            
            case "ShowDetail":
                guard let eventDetailViewController = segue.destination as? FutureLogEventViewController else {
                    fatalError("Unexpected destination: \(segue.destination)")
                }
            
                guard let selectedEventCell = sender as? FutureLogTableViewCell else {
                    fatalError("Unexpected sender: \(sender)")
                }
            
                guard let indexPath = tableView.indexPath(for: selectedEventCell) else {
                    fatalError("The selected cell is not being displayed by the table")
                }
            
                let selectedEvent = events[indexPath.row]
                eventDetailViewController.event = selectedEvent
            
            default:
                fatalError("Unexpected Segue Identifier; \(segue.identifier)")
            
        }
 
    }
    
    //MARK: - Private Methods


    private func saveFutureLogEvents(){
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(events, toFile: FutureLogEvent.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Events successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save events...", log: OSLog.default, type: .error)
        }
    }
    
    
    private func loadFutureLogEvents() -> [FutureLogEvent]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: FutureLogEvent.ArchiveURL.path) as? [FutureLogEvent]
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
