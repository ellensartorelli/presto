//
//  DailyLogTaskTableViewCell.swift
//  presto_v0
//
//  Created by Ellen Sartorelli on 4/26/17.
//  Copyright © 2017 Ellen Sartorelli. All rights reserved.
//

import UIKit

class DailyLogTaskTableViewCell: UITableViewCell {

    @IBOutlet weak var taskLabel: UILabel!
    
    @IBOutlet weak var taskButtonDone: UIButton!
    
    @IBOutlet weak var taskButtonDo: UIButton!
    
    //replaced in viewDidLoad - read variable
//    taskButtonDone.isHidden = true
    //    func setButtons()
//    {
//        taskButtonDo.setImage(UIImage(named: "Unchecked Checkbox_28.png"),  for:.normal)
//        taskButtonDone.setImage(UIImage(named: "Checked Checkbox_28"),  for:.normal)
//        taskButtonDone.isHidden = true
//    }
    
 
    @IBAction func playTapped(sender: AnyObject)
    {
        taskButtonDo.isHidden = true
        taskButtonDone.isHidden = false
        
        //do other stuff
    }
    
    @IBAction func pauseTapped(sender: AnyObject)
    {
        taskButtonDo.isHidden = false
        taskButtonDone.isHidden = true
        
        //do other stuff 
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
