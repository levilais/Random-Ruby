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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rubyCounterButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5)
        Utilities().setButtonShadow(button: rubyCounterButton)
        Utilities().updateRubyLabel(rubyCount: GameLevel.rubyCount, buttonForLabelUpdate: rubyCounterButton)
        tableView.tableFooterView = UIView()
    }
    
    @IBAction func rubyCounterButtonDidPress(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Store().titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "storeCell", for: indexPath) as! PurchaseTableViewCell
        cell.rubyAmountLabel.text = Store().rubyAmounts[indexPath.row]
        cell.subTitleLabel.text = Store().subTitles[indexPath.row]
        cell.titleLabel.text = Store().titles[indexPath.row]
        cell.costLabel.text = Store().costs[indexPath.row]
        return cell
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        <#code#>
//    }

}
