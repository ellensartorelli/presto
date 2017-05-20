//
//  DailyTaskTableViewController.swift
//  presto_v0
//
//  Created by Ellen Sartorelli on 4/25/17.
//  Copyright © 2017 Ellen Sartorelli. All rights reserved.
//

import UIKit

class DailyTaskTableViewController: UITableViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIPickerViewDelegate {
    
    var type: DetailType = .new
    var callback: ((String, String, Date, Bool, Bool)->Void)?
    
    
    //MARK: - PROPERTIES
    
//    var managedObjectContext: NSManagedObjectContext?
    var pickerVisible = false
    
    @IBOutlet weak var toggle: UISwitch!
    @IBOutlet weak var taskTextField: UITextField!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var save: UIBarButtonItem!
    

    
    // MARK: - VIEW 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setMinDate()
        taskTextField.delegate = self
        
        
        // Do any additional setup after loading the view.
        switch(type){
        case .new:
            break
        case let .updating(text, startDate, _, alert):
            navigationItem.title = text
            taskTextField.text = text
            timePicker.date = startDate
            
            toggle.isOn = alert
        }
        
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        if presentingViewController is UINavigationController{
            dismiss(animated: true, completion: nil)
        }else if let owningNavController = navigationController{
            owningNavController.popViewController(animated: true)
        }else{
            fatalError("View is not contained by a navigation controller")
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let button = sender as? UIBarButtonItem, button === save else{
            print("The save button was not pressed")
            return
        }
        
        let text = taskTextField.text ?? ""
        let type = "task"
        let startDate = timePicker.date
        let completed = false //change change change change
        let alert = toggle.isOn
        
        if callback != nil{
            callback!(text, type, startDate, completed, alert)
        }
    }
    

    // MARK: - ACTIONS
    
    @IBAction func pickAlertTime(_ sender: UIDatePicker) {
        setMinDate()
    }
    

    @IBAction func toggleValueChanged(_ sender: UISwitch) {
        tableView.reloadData()
    }
    
    @IBAction func timeChanged(_ sender: UIDatePicker) {
        setTime()
    }
    
    
    
    //MARK:- DATE AND TIME
    
    func setMinDate(){
        //for picker (interval of 5)
        let calendar = Calendar.current
        let minCurrent = (Float(calendar.component(.minute, from: Date.init())))
        let minFuture = (Float(Float(calendar.component(.minute, from: Date.init()))/Float(5))).rounded(.up) * 5
        let newDate = Date(timeIntervalSinceNow: TimeInterval(Int((minFuture - minCurrent)*60)))
        timePicker.minimumDate = newDate
    }

    
    func setTime() {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: timePicker.date) % 12
        let minutes = calendar.component(.minute, from: timePicker.date)
        let time = "\(hour):" + String(format: "%02d", minutes)
    }
    
    
    // MARK: - TABLE VIEW DELEGATE
    
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
    
    
    //MARK: - TEXT FIELD DELEGATE
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        save.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        navigationItem.title = textField.text
    }

    func updateSaveButtonState(){
        let text = taskTextField.text ?? ""
        save.isEnabled = !text.isEmpty
    }
    
}


enum DetailType{
    case new
    case updating(String, Date, Bool, Bool)
}

