//
//  DailyLogEventTableViewCell.swift
//  presto_v0
//
//  Created by Ellen Sartorelli on 4/26/17.
//  Copyright © 2017 Ellen Sartorelli. All rights reserved.
//

import UIKit

class DailyLogEventTableViewCell: UITableViewCell {

    @IBOutlet weak var eventLabel: UILabel!
    
    @IBOutlet weak var eventButtonIncomplete: UIButton!
    
    @IBOutlet weak var eventButtonComplete: UIButton!
    
    func configureCell(item: Item){
        eventLabel.text = item.text
        eventButtonIncomplete.isHidden = item.completed
        eventButtonComplete.isHidden = !(item.completed)
    }
    
    
    @IBAction func IncompleteTapped(sender: AnyObject)
    {
        eventButtonIncomplete.isHidden = true
        eventButtonComplete.isHidden = false
        
    }
    
    @IBAction func CompletedTapped(sender: AnyObject)
    {
        eventButtonIncomplete.isHidden = false
        eventButtonComplete.isHidden = true
    
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
