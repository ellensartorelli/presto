//
//  DailyLogReflectionTableViewCell.swift
//  presto_v0
//
//  Created by Ellen Sartorelli on 4/26/17.
//  Copyright © 2017 Ellen Sartorelli. All rights reserved.
//

import UIKit

class DailyLogReflectionTableViewCell: UITableViewCell {
    
    //PROPERTIES
    
    @IBOutlet weak var dateTime: UILabel!
    @IBOutlet weak var reflectionTextLong: UITextView!
    @IBOutlet weak var reflectionText: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    func configureCell(item: Item){
        reflectionText.text = item.text
    }
    
    func configureCellRefTab (item:Item) {
        reflectionTextLong.text = item.text
        let calendar = Calendar.current
        let day = calendar.component(.day, from:item.time as! Date)
        let month = calendar.component(.month, from:item.time as! Date)

        let monthName = DateFormatter().monthSymbols[month - 1]
        let year = calendar.component(.year, from:item.time as! Date)
        
        let hour = (calendar.component(.hour, from: item.time as! Date)-1) % 12 + 1
        let minutes = calendar.component(.minute, from: item.time as! Date)
        let time = "\(hour):" + String(format: "%02d", minutes)
        
        dateTime.text = monthName + " \(day), \(year)"
        timeLabel.text = time
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
