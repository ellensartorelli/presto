//
//  DailyLogReflectionViewController.swift
//  presto_v0
//
//  Created by Ellen Sartorelli on 4/26/17.
//  Copyright © 2017 Ellen Sartorelli. All rights reserved.
//

import UIKit
import os.log

class DailyLogReflectionViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var reflectionText: UITextView!
    
      var reflection: DailyLogReflection?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false

        
        reflectionText.delegate = self
        reflectionText.becomeFirstResponder()
    
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tap(gesture:)))
        self.view.addGestureRecognizer(tapGesture)
        
    
        // Set up views if editing an existing Reflection.
        if let reflection = reflection {
            let myFormatter = DateFormatter()
            myFormatter.dateStyle = .long
            navigationItem.title = myFormatter.string(from: reflection.date)
            reflectionText.text = reflection.reflection
        }
        
    }

    func tap(gesture: UITapGestureRecognizer) {
        reflectionText.resignFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//MARK: - Actions
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            reflectionText.resignFirstResponder()
            return false
        }
        return true
    }
    
    
    //TextField delegate functions
    
//    //this does nothing? THESE do nothing?
//    func textViewShouldReturn(_ textField: UITextView) -> Bool {
//        reflectionText.resignFirstResponder()
//        return true
//    }
//    
//    func textViewDidBeginEditing(_ textField: UITextView) {
//        saveButton.isEnabled = false
//    }
//
//    func textViewDidEndEditing(_ textField: UITextView) {
//        updateSaveButtonState()
//        navigationItem.title = textField.text
//    }
    
//    func updateSaveButtonState(){
//        let text = reflectionText.text ?? ""
//        saveButton.isEnabled = !text.isEmpty
//    }
//    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
            
        }
        
        let refText = reflectionText.text ?? ""
        print("refelction text: \(refText)")
        
        // Set the meal to be passed to MealTableViewController after the unwind segue.
        reflection = DailyLogReflection(reflection: refText, date: Date.init())
    }
    

}
