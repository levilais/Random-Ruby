//
//  StoreViewController.swift
//  Random Ruby
//
//  Created by Levi on 10/10/17.
//  Copyright © 2017 App Volks. All rights reserved.
//

import UIKit

class StoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var rubyCounterButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var buttonBackgroundImages: [UIImage] = Store().getButtonBackgroundImages()

    override func viewDidLoad() {
        super.viewDidLoad()
        rubyCounterButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5)
        Utilities().setButtonShadow(button: rubyCounterButton)
        Utilities().updateRubyLabel(rubyCount: GameLevel.rubyCount, buttonForLabelUpdate: rubyCounterButton)
    }
    
    @IBAction func rubyCounterButtonDidPress(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return buttonBackgroundImages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "storeCell", for: indexPath) as! PurchaseTableViewCell
        
        return cell
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        <#code#>
//    }

}
