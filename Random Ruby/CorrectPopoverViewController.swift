//
//  CorrectPopoverViewController.swift
//  Random Ruby
//
//  Created by Levi on 9/20/17.
//  Copyright © 2017 App Volks. All rights reserved.
//

import UIKit

class CorrectPopoverViewController: UIViewController {

    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var plusOneImage: UIImageView!
    @IBOutlet weak var beatenEveryLevelLabel: UILabel!
    @IBOutlet weak var checkBackLaterLabel: UILabel!
    
    var messages = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utilities().setButtonShadow(button: nextButton)
        messages = ["Correct!","That's Right!","Good Job!","You're Good!","Amazing!"]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let randomMessage = arc4random_uniform(UInt32(messages.count))
        messageLabel.text = messages[Int(randomMessage)]
        if GameLevel.currentGameState == "gameOver" {
            nextButton.isHidden = true
            messageLabel.text = "Victory!"
            plusOneImage.isHidden = true
            beatenEveryLevelLabel.isHidden = false
            checkBackLaterLabel.isHidden = false
        }
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
//        dismiss(animated: true, completion: nil)
        _ = navigationController?.popViewController(animated: true)
    }
}
