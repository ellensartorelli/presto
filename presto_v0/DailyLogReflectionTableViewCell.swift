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
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
