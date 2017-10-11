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
        if let currentGameStateCheck = UserDefaults.standard.object(forKey: GameLevel.Key.currentGameState.rawValue) {
            GameLevel.currentGameState = currentGameStateCheck as! String
            if GameLevel.currentGameState != "firstLoad" {
                performSegue(withIdentifier: "showGamePlayViewController", sender: self)
            }
        }
    }
    @IBAction func howToPlayButtonPressed(_ sender: Any) {
    }
    
    // ACTIONS
    @IBAction func playButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "showGamePlayViewController", sender: self)
    }
    
    
}
