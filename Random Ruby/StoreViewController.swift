//
//  StoreViewController.swift
//  Random Ruby
//
//  Created by Levi on 10/10/17.
//  Copyright © 2017 App Volks. All rights reserved.
//

import UIKit
import StoreKit

class StoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SKProductsRequestDelegate/*, SKPaymentTransactionObserver*/ {
    
    @IBOutlet weak var rubyCounterButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    let productIDs: Set<String> = ["com.AppVolks.RandomRuby.50Rubies","com.AppVolks.RandomRuby.250Rubies","com.AppVolks.RandomRuby.750Rubies","com.AppVolks.RandomRuby.1500Rubies","com.AppVolks.RandomRuby.3000Rubies","com.AppVolks.RandomRuby.6000Rubies","com.AppVolks.RandomRuby.9000Rubies"]
    let rubyAmountsToAdd: [Int] = [50,250,750,1500,3000,6000,9000]
    var productsArray: Array<SKProduct> = []
//    var selectedProductIndex: Int!
//    var transactionInProgress = false
//    var delegate: StoreViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        SKPaymentQueue.default().add(self)
        rubyCounterButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5)
        Utilities().setButtonShadow(button: rubyCounterButton)
        Utilities().updateRubyLabel(rubyCount: GameLevel.rubyCount, buttonForLabelUpdate: rubyCounterButton)
        tableView.tableFooterView = UIView()
        
        requestProductInfo()
    }
    
    func requestProductInfo() {
        if SKPaymentQueue.canMakePayments() {
            let productRequest = SKProductsRequest(productIdentifiers: productIDs)
            productRequest.delegate = self
            productRequest.start()
        }
        else {
            print("Cannot perform In App Purchases.")
        }
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if response.products.count != 0 {
            for product in response.products {
                productsArray.append(product as SKProduct)
            }
            productsArray = productsArray.sorted(by: {Float(truncating: $0.price) < Float(truncating: $1.price)})
        }
        else {
            print("There are no products.")
        }
        if response.invalidProductIdentifiers.count != 0 {
            print(response.invalidProductIdentifiers.description)
        }
    }
    
    @IBAction func rubyCounterButtonDidPress(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func doneButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Store.titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "storeCell", for: indexPath) as! PurchaseTableViewCell
        cell.rubyAmountLabel.text = Store.rubyAmounts[indexPath.row]
        cell.subTitleLabel.text = Store.subTitles[indexPath.row]
        cell.titleLabel.text = Store.titles[indexPath.row]
        cell.costLabel.text = Store.costs[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Store.selectedProductIndex = indexPath.row
        
        if Store.transactionInProgress == false {
            let payment = SKPayment(product: self.productsArray[Store.selectedProductIndex!] as SKProduct)
            SKPaymentQueue.default().add(payment)
            Store.transactionInProgress = true
        }
        
        tableView.cellForRow(at: indexPath)?.isSelected = false
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func didBuyRubies(rubiesIndex: Int) {
        GameLevel.rubyCount += rubyAmountsToAdd[Store.selectedProductIndex!]
        UserDefaultsHelper().saveGameContext()
    }
}








