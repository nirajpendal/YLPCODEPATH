//
//  SearchCell.swift
//  YLPCodePath
//
//  Created by Niraj Pendal on 4/5/17.
//  Copyright © 2017 codepath. All rights reserved.
//

import UIKit

class SearchCell: UITableViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var ratingsImageView: UIImageView!
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    
    
    var business:Business! {
        didSet{
            self.iconImageView.setImageWith(business.imageURL!)
            self.nameLabel.text = business.name
            self.distanceLabel.text = business.distance
            self.ratingsImageView.setImageWith(business.ratingImageURL!)
            self.reviewLabel.text = "\(business.reviewCount ?? 0) Reviews"
            self.addressLabel.text = business.address
            self.categoriesLabel.text = business.categories
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.iconImageView.clipsToBounds = true
        self.iconImageView.layer.cornerRadius = 3
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
