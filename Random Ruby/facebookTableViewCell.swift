//
//  facebookTableViewCell.swift
//  Random Ruby
//
//  Created by Levi on 10/11/17.
//  Copyright © 2017 App Volks. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class facebookTableViewCell: UITableViewCell {

    @IBOutlet weak var facebookButton: FBSDKLoginButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        facebookButton.readPermissions = ["public_profile","email"]
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
