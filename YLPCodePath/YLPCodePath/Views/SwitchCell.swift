//
//  SwitchCell.swift
//  YLPCodePath
//
//  Created by Niraj Pendal on 4/6/17.
//  Copyright © 2017 codepath. All rights reserved.
//

import UIKit

protocol SwitchCellDelegate: class {
    func yelpCategoryValueChanged(cell:SwitchCell, yelpCategory: YelpCategory)
}

struct YelpCategory {
    var name:String
    var isOn: Bool
}

class SwitchCell: UITableViewCell {

    var delegate : SwitchCellDelegate?
    //var isOn:Bool = false
    
    var category:YelpCategory! {
        didSet{
            self.nameLabel.text = category.name
            self.switchComponent.isOn = category.isOn
        }
    }
    
    @IBOutlet weak var switchComponent: UISwitch!
    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func valueChanged(_ sender: Any) {
        self.delegate?.yelpCategoryValueChanged(cell: self, yelpCategory: YelpCategory(name: self.category.name, isOn: self.switchComponent.isOn))
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
