//
//  DailyLogEventTableViewCell.swift
//  presto_v0
//
//  Created by Ellen Sartorelli on 4/26/17.
//  Copyright © 2017 Ellen Sartorelli. All rights reserved.
//

import UIKit

class DailyLogEventTableViewCell: UITableViewCell {
    
    var event:DailyLogEvent?

    @IBOutlet weak var eventLabel: UILabel!
    
    @IBOutlet weak var eventButtonIncomplete: UIButton!
    
    @IBOutlet weak var eventButtonComplete: UIButton!
    
    
    
    @IBAction func IncompleteTapped(sender: AnyObject)
    {
        eventButtonIncomplete.isHidden = true
        eventButtonComplete.isHidden = false
        event?.completed = true
        
    }
    
    @IBAction func CompletedTapped(sender: AnyObject)
    {
        eventButtonIncomplete.isHidden = false
        eventButtonComplete.isHidden = true
        event?.completed = false

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
