//
//  DailyTaskTableViewController.swift
//  presto_v0
//
//  Created by Ellen Sartorelli on 4/25/17.
//  Copyright © 2017 Ellen Sartorelli. All rights reserved.
//

import UIKit
import os.log

class DailyTaskTableViewController: UITableViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIPickerViewDelegate {
    
    
    @IBOutlet weak var toggle: UISwitch!
    @IBOutlet weak var taskTextField: UITextField!
    @IBOutlet weak var timePicker: UIDatePicker!
    
    var pickerVisible = false
    
    var task:DailyLogTask?
    
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    //set min date
    
    @IBAction func pickAlertTime(_ sender: UIDatePicker) {
        setMinDate()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        toggle.setOn(false, animated: true)
        updateSaveButtonState()
        
        setMinDate()
        
        taskTextField.delegate = self
        timePicker.minimumDate = Date.init()
    
        
        tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0)
        tableView.tableFooterView = UIView(frame: .zero)
        
        if let task = task {       
            
            navigationItem.title = task.title
            taskTextField.text = task.title
            timePicker.date = task.alertTime!
            toggle.isOn = task.alert
        }else{
            toggle.setOn(false, animated: true)
        }
        
        //keep at end
        if(taskTextField.text?.isEmpty)!{
            saveButton.isEnabled = false
        }else{
            saveButton.isEnabled = true
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //MARK: Actions
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddTaskMode = presentingViewController is UINavigationController
        
        if isPresentingInAddTaskMode {
            dismiss(animated: true, completion: nil)
        } else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        } else {
            fatalError("The TaskViewController is not inside a navigation controller.")
        }
    }
    
    @IBAction func toggleValueChanged(_ sender: UISwitch) {
        tableView.reloadData()
    }
    
    @IBAction func timeChanged(_ sender: UIDatePicker) {
        setTime()
    }
    
    //MARK:- Date and time
    
    func setMinDate(){
        //for picker (interval of 5)
        let calendar = Calendar.current
        let minCurrent = (Float(calendar.component(.minute, from: Date.init())))
        let minFuture = (Float(Float(calendar.component(.minute, from: Date.init()))/Float(5))).rounded(.up) * 5
        print(Float(Float(calendar.component(.minute, from: Date.init()))/Float(5)).rounded(.up))
        
        
        let newDate = Date(timeIntervalSinceNow: TimeInterval(Int((minFuture - minCurrent)*60)))
        print(newDate)
        timePicker.minimumDate = newDate
    }

    
    func setTime() {
        let calendar = Calendar.current
        
        let hour = calendar.component(.hour, from: timePicker.date) % 12
        let minutes = calendar.component(.minute, from: timePicker.date)
    
        
        let time = "\(hour):" + String(format: "%02d", minutes)
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
        if indexPath.row == 2 && toggle.isOn == false {
            return 0.0
        }
        if indexPath.row == 2 {
            if toggle.isOn == true {
                
                return 165.0
            }
            return 0.0
        }
        return 70.0
    }
   

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
   
        super.prepare(for: segue, sender: sender)
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        let taskText = taskTextField.text ?? ""
        let time = timePicker.date
        let isAlertOn = toggle.isOn
        
        //set completed when edting or adding new task
        let completedBool = (task?.completed != nil) ? (task?.completed) : false
        
        task = DailyLogTask(title: taskText, alert: isAlertOn, alertTime: time, completed: completedBool!)
        
    }
 
    
    //TextField delegate functions
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
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
    
    func updateSaveButtonState(){
        let text = taskTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    


}
