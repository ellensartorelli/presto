//
//  DailyLogEventTableViewController.swift
//  presto_v0
//
//  Created by Ellen Sartorelli on 4/26/17.
//  Copyright © 2017 Ellen Sartorelli. All rights reserved.
//

import UIKit
import os.log

class DailyLogEventTableViewController: UITableViewController, UITextFieldDelegate {


    var event: DailyLogEvent?
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var dateDisplay: UILabel!

    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var pickerVisible = false

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField.delegate = self
        let calendar = Calendar.current
        
        let day = calendar.component(.day, from: Date.init())
        let month = calendar.component(.month, from: Date.init())
        let monthName = calendar.monthSymbols[month - 1]
        
        dateDisplay.text = "At: \(monthName) \(day)"
        
        timePicker.minimumDate = Date.init()

        
        tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0)
        tableView.tableFooterView = UIView(frame: .zero)
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - Actions
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func timeChanged(_ sender: UIDatePicker) {
        setTime()
    }
    
    
    
    //MARK:- Date and time
    
    
    func setTime() {
        let calendar = Calendar.current
        
//        let day = calendar.component(.day, from: Date.init())
//        let month = calendar.component(.month, from: Date.init())
//        let monthName = calendar.monthSymbols[month - 1]
//        
//        dateDisplay.text = "At: \(monthName) \(day)"

  
        let hour = calendar.component(.hour, from: timePicker.date) % 12
        let minutes = calendar.component(.minute, from: timePicker.date)
        
        
        timeLabel.text = "\(hour):" + String(format: "%02d", minutes)
        
        
    }
    
    // MARK: - Table view data source
    
    override  func tableView(_ tableView: UITableView, didSelectRowAt
        indexPath: IndexPath){
        
        if indexPath.row == 2 {
            pickerVisible = !pickerVisible
            tableView.reloadData()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    @objc(tableView:heightForRowAtIndexPath:)
    override func tableView(_ tableView: UITableView,
                            heightForRowAt indexPath: IndexPath) -> CGFloat {
        print(pickerVisible)
        if indexPath.row == 2 && pickerVisible == false {
            return 165.0
        }
//        if indexPath.row == 3 {
//            if pickerVisible == true {
//                return 165.0
//            }
//            return 0.0
//        }
        return 44.0
    }
    
    
    //TextField delegate functions
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    
    
    // MARK: - Table view data source
//
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let title = titleTextField.text
        event = DailyLogEvent(title:title!, time: timePicker.date)!
        
    }
    //TextField delegate functions
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        saveButton.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        navigationItem.title = textField.text
    }
    
    private func updateSaveButtonState(){
        let text = titleTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
 

}
