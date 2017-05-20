//
//  FutureLogTableViewController.swift
//  presto_v0
//
//  Created by Ellen Sartorelli on 4/24/17.
//  Copyright © 2017 Ellen Sartorelli. All rights reserved.
//

import UIKit
import CoreData
import os.log


class FutureLogTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    private var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!
    
    private let events = ItemCollection(){
        print("Core Data connected")
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.initializeFetchResultsController()
        
        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem
        editButtonItem.tintColor = UIColorFromRGB(rgbValue: 2781306)
   
    }

    func initializeFetchResultsController(){
        
        // Create Fetch Request
        let request = NSFetchRequest<NSFetchRequestResult>(entityName:"Item")
        
        // Configure Fetch Request
        request.sortDescriptors = [NSSortDescriptor(key: "time", ascending: true)]
        
        let moc = events.managedObjectContext
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
    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController?.sections else{
            return 0
        }
        
        let sectionInfo = sections[section]
        
        return sectionInfo.numberOfObjects
    }
    
    
    // SECTION HEADERS
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        let monthName = DateFormatter().monthSymbols[section]
//        return monthName
//    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let item = self.fetchedResultsController.object(at: indexPath) as? Item else{
            fatalError("Cannot find item")
        }
        
        if item.type! == "futureLogEvent" {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FutureLogTableViewCell", for: indexPath) as? FutureLogTableViewCell
                else{
                fatalError("Can't get cell of the right kind")
            }
            cell.configureCell(item: item)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FutureLogTableViewCell", for: indexPath) as? FutureLogTableViewCell
                else{
                    fatalError("Can't get cell of the right kind")
            }
            cell.configureCell(item: item)
            return cell
        }
        
    }
    
    
    //MARK: Actions
    @IBAction func unwindToEventList(sender: UIStoryboardSegue){

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
            guard let item = self.fetchedResultsController?.object(at: indexPath) as? Item else{
                fatalError("Cannot find item")
            }
            
            events.delete(item)
        }
    }
    
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
        //        updateView()
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
                guard let navController = segue.destination as? UINavigationController else{
                    fatalError("Unexpected destination: \(segue.destination)")
                }
                guard let destination = navController.topViewController as? FutureLogEventViewController else{
                    fatalError("Unexpected destination: \(segue.destination)")
                }
                destination.type = .new
                destination.callback = { (text, type, time, completed, alert) in
                    self.events.add(text:text, type:type, time: time, completed:completed, alert:alert)
                }
            case "ShowDetail":
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
                
                destination.type = .updating(item.text!, item.time! as Date, item.completed, item.alert)
                destination.callback = { (text, type, time, completed, alert) in
                    self.events.updateTask(oldItem: item, text: text, time: time, completed: completed, alert: alert)
            }
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier)")

        
        }
        
    }
 
    
    
    //MARK: - Private Methods
    



    
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
