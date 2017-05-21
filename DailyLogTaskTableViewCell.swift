//
//  DailyLogTaskTableViewCell.swift
//  presto_v0
//
//  Created by Ellen Sartorelli on 4/26/17.
//  Copyright © 2017 Ellen Sartorelli. All rights reserved.
//

import UIKit
import CoreData


class DailyLogTaskTableViewCell: UITableViewCell {

    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var taskButtonDone: UIButton!
    @IBOutlet weak var taskButtonDo: UIButton!
    
    
    func configureCell(item: Item){
        taskLabel.text = item.text

        taskButtonDo.isHidden = item.completed
        taskButtonDone.isHidden = !(item.completed)
    }
    
 
    @IBAction func DoTapped(sender: AnyObject)
    {
        //this button is tapped when the task is not completed, is on a "to DO" list
        taskButtonDo.isHidden = true
        taskButtonDone.isHidden = false
    }
    
    @IBAction func DoneTapped(sender: AnyObject)
    {
        //this button is tapped when the task is completed, is DONE
        taskButtonDo.isHidden = false
        taskButtonDone.isHidden = true
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
