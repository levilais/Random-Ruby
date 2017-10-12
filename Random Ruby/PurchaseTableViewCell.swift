//
//  PurchaseTableViewCell.swift
//  Random Ruby
//
//  Created by Levi on 10/12/17.
//  Copyright © 2017 App Volks. All rights reserved.
//

import UIKit

class PurchaseTableViewCell: UITableViewCell {

    @IBOutlet weak var rubyAmountLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
