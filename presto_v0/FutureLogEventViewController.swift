//
//  FutureLogEventViewController.swift
//  presto_v0
//
//  Created by Ellen Sartorelli on 4/24/17.
//  Copyright © 2017 Ellen Sartorelli. All rights reserved.
//

import UIKit
import os.log


class FutureLogEventViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIPickerViewDelegate {
    

    var event: FutureLogEvent?
    
    
    //Outlets
    @IBOutlet weak var eventLabelTF: UITextField!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    @IBOutlet weak var saveButton: UIBarButtonItem!

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventLabelTF.delegate = self
        startDatePicker.minimumDate = Date.init()
        
        if let event = event {
            navigationItem.title = event.title
            eventLabelTF.text = event.title
            startDatePicker.date = event.startDate
            endDatePicker.date = event.endDate
        }

        updateSaveButtonState()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    //MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        super.prepare(for: segue, sender: sender)
        
        guard let button = sender as? UIBarButtonItem, button === saveButton else{
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let title = eventLabelTF.text ?? ""
        let startDate = startDatePicker.date
        let endDate = endDatePicker.date
        
        event = FutureLogEvent(title: title, startDate: startDate, endDate: endDate, notes: "")
        
        print(startDate)
        
    }
    
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        let isPresentingInAddEventMode = presentingViewController is
            UINavigationController
        
        if isPresentingInAddEventMode{
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The FutureLogEventViewController is not inside a navigation controller.")
        }

    }
    
    
    
    //MARK: Actions

    @IBAction func pickStartDate(_ sender: UIDatePicker) {
        endDatePicker.minimumDate = startDatePicker.date
    }
    

    
    @IBAction func pickEndDate(_ sender: UIDatePicker) {
        
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
    
    private func updateSaveButtonState(){
        let text = eventLabelTF.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    

    
    
}





