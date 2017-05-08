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
    
    var events = [FutureLogEvent]()


    override func viewDidLoad() {
        super.viewDidLoad()
        events = events.sorted(by: { $0.startDate.compare($1.startDate) == .orderedAscending })

        if let savedEvents = loadFutureLogEvents(){
            events += savedEvents
        }else{
            loadSampleEvents()
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
//        tableView.reloadData()
        if(events.count == 0){
            return 1
        }
        return events.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                
        if(events.count == 0){
            
            let cellIdentifier = "EmptyCellTableViewCell"
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? EmptyCellTableViewCell  else {
                fatalError("The dequeued cell is not an instance of EmptyCellTableViewCell.")
            }
            return cell
        }
        
        let cellIdentifier = "FutureLogTableViewCell"

        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? FutureLogTableViewCell  else {
            fatalError("The dequeued cell is not an instance of FutureLogEventTableViewCell.")
        }
        
        // Fetches the appropriate meal for the data source layout.
        let event = events[indexPath.row]
        
        let calendar = Calendar.current
        let day = calendar.component(.day, from:event.startDate)
        let month = calendar.component(.month, from:event.startDate)
        let year = calendar.component(.year, from:event.startDate)
        
        cell.eventLabel.text = event.title
        cell.dayLabel.text = "\(month)/\(day)/\(year%100)"
        
        print(event.title)

        return cell
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
    
    private func loadSampleEvents(){
        
        guard let event1 = FutureLogEvent(title:"Graduation",  startDate: Date.init(), endDate: Date.init(), notes:"It can't come soon enough") else {
            fatalError("Unable to instantiate event1")
        }
        
        guard let event2 = FutureLogEvent(title:"Job Starts",  startDate: Date.init(), endDate: Date.init(), notes:"It can't come soon enough") else {
            fatalError("Unable to instantiate event1")
        }
        
        guard let event3 = FutureLogEvent(title:"School Starts",  startDate: Date.init(), endDate: Date.init(), notes:"It can't come soon enough") else {
            fatalError("Unable to instantiate event1")
        }
        
        
        events += [event1, event2, event3]
        events.sorted(by: { $0.startDate.compare($1.startDate) == .orderedAscending })
    }

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
