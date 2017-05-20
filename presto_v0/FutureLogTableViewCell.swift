//
//  FutureLogTableViewCell.swift
//  presto_v0
//
//  Created by Ellen Sartorelli on 4/24/17.
//  Copyright © 2017 Ellen Sartorelli. All rights reserved.
//

import UIKit

class FutureLogTableViewCell: UITableViewCell {
    
        
    @IBOutlet weak var dayLabel: UILabel!

    @IBOutlet weak var eventLabel: UILabel!

    
    func configureCell(item: Item){
        eventLabel.text = item.text
        let calendar = Calendar.current
        let day = calendar.component(.day, from:item.time as! Date)
        let month = calendar.component(.month, from:item.time as! Date)
        let year = calendar.component(.year, from:item.time as! Date)
        
        dayLabel.text = "\(month)/\(day)/\(year%100)"
        
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

