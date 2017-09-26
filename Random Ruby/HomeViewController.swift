//
//  HomeViewController.swift
//  Random Ruby
//
//  Created by Levi on 9/22/17.
//  Copyright © 2017 App Volks. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    // OUTLETS
    @IBOutlet weak var playButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utilities().setButtonShadow(button: playButton)
        
    }
    
    // ACTIONS
    @IBAction func playButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "showGamePlayViewController", sender: self)
    }
    
    
}
