//
//  SwitchCell.swift
//  YLPCodePath
//
//  Created by Niraj Pendal on 4/6/17.
//  Copyright © 2017 codepath. All rights reserved.
//

import UIKit

protocol SwitchCellDelegate: class {
    func yelpCategoryValueChanged(cell:SwitchCell, filterModel: FilterModel)
}

protocol FilterModel {
    var name:String {get set}
    var isOn: Bool {get set}
    var isExpandable: Bool {get set}
    var isExpanded: Bool {get set}
    var isVisible: Bool {get set}
    var additionalRows: Int {get set}
    
}

struct FilterDealsModel: FilterModel {
    
    var name:String
    var isOn: Bool
    var isExpanded: Bool = false
    var isExpandable: Bool = false
    var additionalRows: Int = 0
    var isVisible: Bool = true
    
    init(name: String, isOn: Bool) {
        self.name = name
        self.isOn = isOn
    }
}

struct FilterCategoriesModel: FilterModel {
    
    var name:String
    var isOn: Bool
    var isExpanded: Bool = false
    var isExpandable: Bool = false
    var additionalRows: Int = 0
    var isVisible: Bool = true
    
    init(name: String, isOn: Bool) {
        self.name = name
        self.isOn = isOn
    }
}

struct FilterSortByModel: FilterModel {
    
    var name:String
    var isOn: Bool
    var isExpanded: Bool
    var isExpandable: Bool
    var additionalRows: Int
    var isVisible: Bool
}


struct FilterDistanceModel: FilterModel {
    
    var name:String
    var isOn: Bool
    var isExpanded: Bool
    var isExpandable: Bool
    var additionalRows: Int
    var isVisible: Bool
}

class SwitchCell: UITableViewCell {

    weak var delegate : SwitchCellDelegate?
    //var isOn:Bool = false
    
    var model:FilterModel! {
        didSet{
            self.nameLabel.text = model.name
            self.switchComponent.isOn = model.isOn
        }
    }
    
    @IBOutlet weak var switchComponent: UISwitch!
    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func valueChanged(_ sender: Any) {
        self.model.isOn = self.switchComponent.isOn
       self.delegate?.yelpCategoryValueChanged(cell: self, filterModel: self.model)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
