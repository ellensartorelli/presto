//
//  ReflectionTableViewController.swift
//  presto_v0
//
//  Created by Ellen Sartorelli on 5/3/17.
//  Copyright © 2017 Ellen Sartorelli. All rights reserved.
//
import os.log
import UIKit
import CoreData

class ReflectionTableViewController: UITableViewController, UITextViewDelegate, NSFetchedResultsControllerDelegate {
    
    private var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!
    
    private let reflections = ItemCollection(){
        print("Core Data connected")
        print("reflection tab")
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
        request.predicate = NSPredicate(format: "type == %@", "reflection")
        
        let moc = reflections.managedObjectContext
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
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController?.sections else{
            return 0
        }
        
        let sectionInfo = sections[section]
        
        return sectionInfo.numberOfObjects
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("populating tableview in reflection tab")
        guard let item = self.fetchedResultsController.object(at: indexPath) as? Item else{
            fatalError("Cannot find item")
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "reflectionTabReflection", for: indexPath) as? DailyLogReflectionTableViewCell
            else{
                fatalError("Can't get cell of the right kind")
        }
        print("reflectioncell")
        cell.configureCellRefTab(item: item)
        return cell
        

    }
    

    
    //Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    //Return false if you do not want the specified item to be editable.
        return true
    }


 
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            guard let item = self.fetchedResultsController?.object(at: indexPath) as? Item else{
                fatalError("Cannot find item")
            }
            
            reflections.delete(item)
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
        //        updateView()
    }

    //MARK: -Actions

    
    @IBAction func unwindToReflection(sender: UIStoryboardSegue) {
        print("clicked save from ref tab")

        tableView.reloadData()
        

    }
    

    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        switch(segue.identifier ?? ""){
        case "AddItem":
            guard let navController = segue.destination as? UINavigationController else{
                fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let destination = navController.topViewController as? DailyLogReflectionViewController else{
                fatalError("Unexpected destination: \(segue.destination)")
            }
            destination.type = .new
            destination.callback = { (text, type, time, completed, alert) in
                self.reflections.add(text:text, type:type, time: time, completed:completed, alert:alert)
            }
        case "ShowDetail":
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
                self.reflections.updateReflection(oldItem: item, text: text, time: time, completed: completed, alert: alert)
            }
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier)")
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
