//
//  DailyLogEventTableViewCell.swift
//  presto_v0
//
//  Created by Ellen Sartorelli on 4/26/17.
//  Copyright © 2017 Ellen Sartorelli. All rights reserved.
//

import UIKit

class DailyLogEventTableViewCell: UITableViewCell {
    
    //MARK: - Properties

    @IBOutlet weak var eventLabel: UILabel!
    @IBOutlet weak var eventButtonIncomplete: UIButton!
    @IBOutlet weak var eventButtonComplete: UIButton!
    
    func configureCell(item: Item){
        let calendar = Calendar.current
        let hour = (calendar.component(.hour, from: item.time as! Date)-1) % 12 + 1
        let minutes = calendar.component(.minute, from: item.time as! Date)
        eventLabel.text = "\(item.text!), at \(hour):" + String(format: "%02d", minutes)
        eventButtonIncomplete.isHidden = item.completed
        eventButtonComplete.isHidden = !(item.completed)
    }
    
    
    @IBAction func IncompleteTapped(sender: AnyObject)
    {
        //this button is tapped when the event has just been completed
        eventButtonIncomplete.isHidden = true
        eventButtonComplete.isHidden = false
    }
    
    @IBAction func CompletedTapped(sender: AnyObject)
    {
        //this button is tapped to uncomplete an event
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
