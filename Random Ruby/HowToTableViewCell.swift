//
//  HowToTableViewCell.swift
//  Random Ruby
//
//  Created by Levi on 10/11/17.
//  Copyright © 2017 App Volks. All rights reserved.
//

import UIKit

class HowToTableViewCell: UITableViewCell {

    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupHowToLabel()
    }
    
    func setupHowToLabel() {
        let newFontSize = Utilities().screenBasedFontSize(minimumFontSize: 15)
        
        let text: String = "Believe it or not, Ruby isn't crazy… \n\nHer comment might seem completely out of nowhere - but there is a “common thread” between what she’s saying and Bobbi and Bill’s conversation - though it might take some outside-of-the-box thinking to make the connection.  It's your job to uncover the one word that represents this common thread.  It’s easy… \n\n1.  Read Bobbi, Bill, and Ruby’s comments.\n2.  Use the scrambled tiles below to form the word that represents the common thread.\n\nIt's that simple!  Now, get into that crazy... ahem... random mind of Ruby and start solving those puzzles!"
        contentLabel.text = text
        contentLabel.font = contentLabel.font.withSize(newFontSize)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
