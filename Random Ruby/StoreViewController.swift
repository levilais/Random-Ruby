//
//  StoreViewController.swift
//  Random Ruby
//
//  Created by Levi on 10/10/17.
//  Copyright © 2017 App Volks. All rights reserved.
//

import UIKit
import StoreKit
import SystemConfiguration

class StoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SKProductsRequestDelegate {
    
    @IBOutlet weak var tryAgainDirectionsLabel: UILabel!
    @IBOutlet weak var tryAgainTitleLabel: UILabel!
    @IBOutlet weak var tryAgainButton: UIButton!
    @IBOutlet weak var rubyCounterButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    let productIDs: Set<String> = ["com.AppVolks.RandomRuby.50Rubies","com.AppVolks.RandomRuby.250Rubies","com.AppVolks.RandomRuby.750Rubies","com.AppVolks.RandomRuby.1500Rubies","com.AppVolks.RandomRuby.3000Rubies","com.AppVolks.RandomRuby.6000Rubies","com.AppVolks.RandomRuby.9000Rubies"]
    let rubyAmountsToAdd: [Int] = [50,250,750,1500,3000,6000,9000]
    var productsArray: Array<SKProduct> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rubyCounterButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5)
        Utilities().setButtonShadow(button: rubyCounterButton)
        Utilities().updateRubyLabel(rubyCount: GameLevel.rubyCount, buttonForLabelUpdate: rubyCounterButton)
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("isConnectedToNetwork: \(ConnectionCheck.isConnectedToNetwork())")
        if ConnectionCheck.isConnectedToNetwork() == true {
            requestProductInfo()
            print("productsArray.count: \(productsArray.count)")
        } else {
            print("Internet connection FAILED")
            showTryAgain()
        }
    }
    
    @IBAction func tryAgainButtonPressed(_ sender: Any) {
        // try to load products again
        requestProductInfo()
    }
    
    func showTryAgain() {
        // show the try again functionality and hide tableview
        tableView.isHidden = true
        tryAgainTitleLabel.isHidden = false
        tryAgainDirectionsLabel.isHidden = false
        tryAgainButton.isHidden = false
    }
    
    func hideTryAgain() {
        // hide the try again functinoality and show tableview
        tableView.isHidden = false
        tryAgainTitleLabel.isHidden = true
        tryAgainDirectionsLabel.isHidden = true
        tryAgainButton.isHidden = true
    }
    
    func requestProductInfo() {
        if SKPaymentQueue.canMakePayments() {
            let productRequest = SKProductsRequest(productIdentifiers: productIDs)
            productRequest.delegate = self
            productRequest.start()
            print("Product request was sent to the App Store.")
        } else {
            let alert = UIAlertController(title: "In-App Purchases Not Enabled", message: "Please enable In-App Purchase in Settings > General > Restrictions", preferredStyle: .alert)
            let settingsButton = UIAlertAction(title: "Settings", style: .default) {
                UIAlertAction in
                alert.dismiss(animated: true, completion: nil)
                UIApplication.shared.open(URL(string:"App-Prefs:root=General")!, options: [:], completionHandler: nil)
            }
            let okButton = UIAlertAction(title: "OK", style: .default) {
                UIAlertAction in
                alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(settingsButton)
            alert.addAction(okButton)
            
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if response.products.count != 0 {
            print("products were returned")
            var tempProductsArray = [SKProduct]()
            for product in response.products {
                tempProductsArray.append(product as SKProduct)
            }
            tempProductsArray = tempProductsArray.sorted(by: {Float(truncating: $0.price) < Float(truncating: $1.price)})
            productsArray = tempProductsArray
            print("There are \(productsArray.count) elements in the productsArray.")
            hideTryAgain()
        } else {
            print("No products returned")
            showTryAgain()
        }
        if response.invalidProductIdentifiers.count != 0 {
            print(response.invalidProductIdentifiers.description)
        }
        print("productsRequest has finished")
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
        if ConnectionCheck.isConnectedToNetwork() == true {
            Store.selectedProductIndex = indexPath.row
            if Store.transactionInProgress == false {
                if let unwrappedSelectedIndex = Store.selectedProductIndex {
                    if self.productsArray.count != 0 {
                        print("products exist")
                        let payment = SKPayment(product: self.productsArray[unwrappedSelectedIndex] as SKProduct)
                        SKPaymentQueue.default().add(payment)
                        Store.purchaseItemsDelivered = false
                        Store.transactionInProgress = true
                        print("Store.selectedProductIndex before saving transaction: \(String(describing: Store.selectedProductIndex))")
                        UserDefaultsHelper().savePurchaseState()
                        tableView.isHidden = false
                    } else {
                        print("product doesn't exist")
                        showTryAgain()
                    }
                }
            }
            tableView.cellForRow(at: indexPath)?.isSelected = false
        } else {
            showTryAgain()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func deliverPurchaseItems(rubiesIndex: Int) {
        UserDefaultsHelper().loadCurrentTransactionState()
        if Store.purchaseItemsDelivered == false {
            if let productIndex = Store.selectedProductIndex {
                GameLevel.rubyCount += rubyAmountsToAdd[productIndex]
            }
            Store.purchaseItemsDelivered = true
            Store.transactionInProgress = false
            UserDefaultsHelper().saveGameContext()
        }
    }
}









