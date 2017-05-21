//
//  DailyTaskTableViewController.swift
//  presto_v0
//
//  Created by Ellen Sartorelli on 4/25/17.
//  Copyright © 2017 Ellen Sartorelli. All rights reserved.
//

import UIKit
import UserNotifications

class DailyTaskTableViewController: UITableViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UNUserNotificationCenterDelegate {
    
    //MARK: - Core Data
    
    var type: DetailType = .new
    var callback: ((String, String, Date, Bool, Bool)->Void)?
    
    //MARK: - PROPERTIES
    
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
    
        switch(type){
        case .new:
            break
        case let .updating(text, startDate, _, alert):
            navigationItem.title = text
            taskTextField.text = text
            timePicker.date = startDate
            
            toggle.isOn = alert
        }
        if(taskTextField.text?.isEmpty)!{
            save.isEnabled = false
        }else{
            save.isEnabled = true
        }
        UNUserNotificationCenter.current().requestAuthorization(options: [[.alert, .sound]], completionHandler: { (granted, error) in
            // Handle Error
        })
        UNUserNotificationCenter.current().delegate = self
        
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
        
    }
    
    // MARK: - NAVIGATION
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let button = sender as? UIBarButtonItem, button === save else{
            return
        }
        
        let text = taskTextField.text ?? ""
        let type = "task"
        let startDate = timePicker.date
        let completed = false
        let alert = toggle.isOn
        
        if callback != nil{
            callback!(text, type, startDate, completed, alert)
        }
        sendNotification()
    }
    
    //MARK: - LOCAL NOTIFICATIONS
    
    func sendNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Task Reminder"
        content.body = taskTextField.text!
        
        let date = timePicker.date
        let dateCompenents = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second], from: date)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateCompenents, repeats: false)

        
        let requestIdentifier = taskTextField.text!
        let request = UNNotificationRequest(identifier: requestIdentifier,
                                            content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request,
                                               withCompletionHandler: { (error) in
                                                // Handle error
        })
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.alert, .sound])
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
        let hour = (calendar.component(.hour, from: timePicker.date)-1) % 12 + 1
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

