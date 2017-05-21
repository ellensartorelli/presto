//
//  ReflectionTableViewController.swift
//  presto_v0
//
//  Created by Ellen Sartorelli on 5/3/17.
//  Copyright © 2017 Ellen Sartorelli. All rights reserved.
//
import os.log
import UIKit

class ReflectionTableViewController: UITableViewController, UITextViewDelegate {
    
    
    var reflections = [DailyLogReflection]()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadSampleReflections()
        

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
            fatalError("The dequeued cell is not an instance of DailyLogReflectionTableViewCell.")
        }

        // Fetches the appropriate meal for the data source layout.
        let reflection = reflections[indexPath.row]
        cell.reflectionTextLong.text = reflection.reflection

        let myFormatter = DateFormatter()
        myFormatter.dateStyle = .long
        cell.dateTime.text = myFormatter.string(from: reflection.date) // "March 10, 1876"
        myFormatter.dateStyle = .none
        myFormatter.timeStyle = .short // 1:50 PM
        cell.timeLabel.text = myFormatter.string(from: reflection.date)
        
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
            reflections.remove(at: indexPath.row)
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
    
    
    //MARK: Private Methods
//    func updateView(){
//        if(reflections.count == 0){
//            messageLabel.isHidden = false
//            emptyView.isHidden = false
//        }else{
//            messageLabel.isHidden = true
//            emptyView.isHidden = true
//        }
//    }

    //MARK: -Actions

    
    @IBAction func unwindToReflection(sender: UIStoryboardSegue) {
        print("clicked save from ref tab")

        
        
        if let sourceViewController = sender.source as? DailyLogReflectionViewController, let reflection = sourceViewController.reflection {
            
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing meal.
                reflections[selectedIndexPath.row] = reflection
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else {
                // Add a new reflection.
                let newIndexPath = IndexPath(row: reflections.count, section: 0)
                
                reflections.append(reflection)
                tableView.insertRows(at: [newIndexPath], with: .automatic)            }
        }

    }
    
    
    private func loadSampleReflections(){
        print("called Reflections from reftab")
        
        guard let ref1 = DailyLogReflection(reflection: "In 1531 the Virgin of Guadalupe’s miraculous apparition to an indigenous man, Juan Diego was quickly seen as highly symbolic and was especially celebrated and cherished by the native population of Mexico. Yet the apparition tradition is similar to the story of the Spanish statuette, Our Lady of Guadalupe in Extremadura, Spain, and the location of the apparition in Mexico was home to an Aztec mother deity.The roots of the Virgin of Guadalupe’s apparition story, like most of Mexico’s existing culture, came over with the Spanish conquistadores and Catholic clergy who coerced many of the indigenous peoples of Mexico into Catholicism. This conversion was crucial to colonizing the new country and led to new oral narratives such as the story of the apparition of the Virgin of Guadalupe, but also to Indian ambivalence toward the Spanish. Image passive and docile. The image of the Virgin of Guadalupe is responsible for fusing together both Spanish and Aztec traditions that unifies Mexico as it is today. Has also influence the role of women.", date: Date.init()) else {
            fatalError("Unable to instantiate reflection")
        }
        let minute:TimeInterval = 60.0
        let hour:TimeInterval = 60.0 * minute
        let day:TimeInterval = 24 * hour
        let month:TimeInterval = 31*day
        
        let date = Date(timeInterval: -month, since: Date())
        

        
        guard let ref2 = DailyLogReflection(reflection: "Today we are announcing the establishment and membership of a College-wide committee to explore and discuss issues relating to the events of March 2, including, but not limited to, freedom of expression, inclusivity, and the educational and civic challenges of the 21st century. The creation of this committee was among the most frequently offered suggestions in the weeks following March 2. The committee will commence its work this spring and resume in the fall semester, with the aim of completing its work by the end of 2017.", date: date) else {
            fatalError("Unable to instantiate reflection")
        }
        
        reflections += [ref2, ref1]
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? ""){
        case "AddItem":
            os_log("Adding a new reflection", log: OSLog.default, type: .debug)
            
        case "ShowDetail":
            guard let reflectionDetailViewController = segue.destination as? DailyLogReflectionViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedReflectionCell = sender as? DailyLogReflectionTableViewCell else {
                fatalError("Unexpected sender: \(sender)")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedReflectionCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedReflection = reflections[indexPath.row]
            reflectionDetailViewController.reflection = selectedReflection
            
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
