//
//  ReflectionTableViewController.swift
//  presto_v0
//
//  Created by Ellen Sartorelli on 5/3/17.
//  Copyright © 2017 Ellen Sartorelli. All rights reserved.
//

import UIKit

class ReflectionTableViewController: UITableViewController, UITextViewDelegate {
    
    
    var reflections = [DailyLogReflection]()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadSampleReflections()
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return reflections.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        

        // Configure the cell...

        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "reflectionTabReflection"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? DailyLogReflectionTableViewCell  else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        
        // Fetches the appropriate meal for the data source layout.
        let reflection = reflections[indexPath.row]
        
        cell.reflectionTextLong.text = reflection.reflection
        let calendar = Calendar.current
        let month = calendar.component(.month, from:Date.init())
         let monthName = calendar.monthSymbols[month - 1]
        let day = calendar.component(.day, from:Date.init())
        let year = calendar.component(.year, from: Date.init())
        let hour = calendar.component(.hour, from:Date.init()) % 12
        let minute = calendar.component(.minute, from:Date.init())

        
        cell.dateTime.text = String(monthName) + " " + String(day) + ", " + String(year)
        cell.timeLabel.text = "\(hour):" + String(format: "%02d", minute)
        
        
        return cell
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

    //MARK: -Actions

    
    @IBAction func unwindToReflection(sender: UIStoryboardSegue) {
        print("clicked save from ref tab")

        
        
        if let sourceViewController = sender.source as? DailyLogReflectionViewController, let reflection = sourceViewController.reflection {
            
            // Add a new meal.
            let newIndexPath = IndexPath(row: reflections.count, section: 0)
            
            reflections.append(reflection)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
//        self.performSegue(withIdentifier: "unwindFromDailyLogReflectionViewController", sender: self)

    }
    
    
    private func loadSampleReflections(){
        print("called Reflections from reftab")
        
        guard let ref1 = DailyLogReflection(reflection: "hello this is a long asdfjkl; fghjfghjdxcfgvbh ", date: Date.init()) else {
            fatalError("Unable to instantiate reflection")
        }
        
        reflections += [ref1]
        print(reflections.count)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
