//
//  TutorialViewController.swift
//  presto_v0
//
//  Created by Shannia Fu on 5/21/17.
//  Copyright © 2017 Ellen Sartorelli. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController {

    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var instructions: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        instructions.numberOfLines = 0
        instructions.text = "Thanks for using our app! This is the mobile version of a bullet journal. In here, you can keep your daily tasks, events, reflections, and all the events you have planned in the future. You can also track all your habits to ensure your healthy lifestyle."
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
