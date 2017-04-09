//
//  RadioTableViewCell.swift
//  YLPCodePath
//
//  Created by Niraj Pendal on 4/8/17.
//  Copyright © 2017 codepath. All rights reserved.
//

import UIKit

class RadioTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    var model:FilterModel!{
        
        didSet{
            self.nameLabel.text = model.name
            if model.isOn {
                self.accessoryType = .checkmark
            } else {
                self.accessoryType = .none
            }
        }
        
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
