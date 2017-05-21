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
    
    //MARK: - Core Data
    
    var type: DetailTypeReflection = .new
    var callback: ((String, String, Date, Bool, Bool)->Void)?
    
    //MARK: - Properties

    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var reflectionText: UITextView!
    
      var reflection: DailyLogReflection?
    
    //MARK: - View

    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false

        
        reflectionText.delegate = self
        reflectionText.becomeFirstResponder()
    
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tap(gesture:)))
        self.view.addGestureRecognizer(tapGesture)
        
        
        // Do any additional setup after loading the view.
        switch(type){
        case .new:
            break
        case let .updatingReflection(text):
            navigationItem.title = text
            reflectionText.text = text
        }
        saveButton.isEnabled = false
        reloadInputViews()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK - Gesture

    func tap(gesture: UITapGestureRecognizer) {
        reflectionText.resignFirstResponder()
    }


    
//MARK: - Actions
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        if (text == "\n") {
//            reflectionText.resignFirstResponder()
//            if (!reflectionText.text.isEmpty) {
//                saveButton.isEnabled = true
//            }
//            return false
//        }
//        return true
//    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView == self.reflectionText {
            self.saveButton.isEnabled = !reflectionText.text.isEmpty
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let button = sender as? UIBarButtonItem, button === saveButton else{
            return
        }
        let text = reflectionText.text ?? ""
        let type = "reflection"
        let startDate = Date.init()

        let completed = false
        let alert = false
        
        if callback != nil{
            callback!(text, type, startDate, completed, alert)
        }
    }
}

enum DetailTypeReflection{
    case new
    case updatingReflection(String)
}
