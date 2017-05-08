//
//  DailyLogTaskTableViewCell.swift
//  presto_v0
//
//  Created by Ellen Sartorelli on 4/26/17.
//  Copyright © 2017 Ellen Sartorelli. All rights reserved.
//

import UIKit

class DailyLogTaskTableViewCell: UITableViewCell {
    
    
    var task:DailyLogTask?
    
    @IBOutlet weak var taskLabel: UILabel!
    
    @IBOutlet weak var taskButtonDone: UIButton!
    
    @IBOutlet weak var taskButtonDo: UIButton!
    
 
    @IBAction func DoTapped(sender: AnyObject)
    {
        print("task completed was \(task?.completed)")
        taskButtonDo.isHidden = true
        taskButtonDone.isHidden = false
        task?.completed = true
        print("task completed is now \(task?.completed)")

    
    }
    
    @IBAction func DoneTapped(sender: AnyObject)
    {
        print("task completed was \(task?.completed)")
        taskButtonDo.isHidden = false
        taskButtonDone.isHidden = true
        task?.completed = false
        print("task completed is now \(task?.completed)")


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
