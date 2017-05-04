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
        
        reflectionText.delegate = self

        reflectionText.becomeFirstResponder()
    
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tap(gesture:)))
        self.view.addGestureRecognizer(tapGesture)
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
    
//    func textViewShouldReturn(_ textView: UITextView) -> Bool {
//        textView.resignFirstResponder()
//        return true
//    }
    
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
//        if segue.identifier == "refTabReflectionSegue" {
//            if myTextField.text = "words inside text field" {
//                let controller = segue.destination as! ReflectionTableViewController
//            } else if myTextField.text = "different words in text field" {
//                let controller = segue.destination as! DailyLogReflectionViewController
//            }
//        }
//    
        
    
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
            
        }
        
        let refText = reflectionText.text ?? ""
        
        // Set the meal to be passed to MealTableViewController after the unwind segue.
        reflection = DailyLogReflection(reflection: refText, date: Date.init())
    }
    

}
