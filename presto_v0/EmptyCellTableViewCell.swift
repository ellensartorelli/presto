//
//  EmptyCellTableViewCell.swift
//  presto_v0
//
//  Created by Ellen Sartorelli on 5/8/17.
//  Copyright © 2017 Ellen Sartorelli. All rights reserved.
//

import UIKit

class EmptyCellTableViewCell: UITableViewCell {

    @IBOutlet weak var instructionLabel: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
