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

    var type: DetailTypeEvent = .new
    var callback: ((String, String, Date, Bool, Bool)->Void)?

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
        
        
        // Do any additional setup after loading the view.
        switch(type){
        case .new:
            break
        case let .updatingEvent(text, startDate):
            navigationItem.title = text
            titleTextField.text = text
            timePicker.date = startDate
        }

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        //start with save button false if new event
        if(titleTextField.text?.isEmpty)!{
            saveButton.isEnabled = false
        }else{
            saveButton.isEnabled = true
        }
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
        return 70.0
    }
    
    
    //TextField delegate functions
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }




    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let button = sender as? UIBarButtonItem, button === saveButton else{
            print("The save button was not pressed")
            return
        }
        
        let text = titleTextField.text ?? ""
        let type = "event"
        let startDate = timePicker.date
        let completed = true //CHANGE CHANGE CHANGE CHANGE CHANGE
        let alert = false
        
        if callback != nil{
            callback!(text, type, startDate, completed, alert)
        }
        
    }
    //TextField delegate functions
    
//    func textFieldShouldReturn(textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        saveButton.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        navigationItem.title = textField.text
    }
    
    private func updateSaveButtonState(){
        let text = titleTextField.text ?? ""
        print("button shoould be disabled if ", String(!text.isEmpty))
        saveButton.isEnabled = !text.isEmpty
    }
 

}

enum DetailTypeEvent{
    case new
    case updatingEvent(String, Date)
}
