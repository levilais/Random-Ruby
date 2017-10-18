//
//  StoreStruct.swift
//  Random Ruby
//
//  Created by Levi on 10/12/17.
//  Copyright © 2017 App Volks. All rights reserved.
//

import Foundation
import UIKit

class Store {
    static var selectedProductIndex: Int?
    static var transactionInProgress = false
    static var purchaseItemsDelivered = false
    static let rubyAmounts = ["+50","+250","+750","+1,500","+3,000","+6,000","+9,000"]
    static let costs = ["$1.99","$4.99","$9.99","$14.99","$29.99","$59.99","$99.99"]
    static let titles = ["Some Rubies","More Rubies","Tons'a Rubies","Too Many","Ummm","You Crazy","Retiring Now"]
    static let subTitles = ["A good start...","A great value...","The best value ever...","Too many rubies...","Way too many...","This is out of hand...","Well that was fun..."]
    
    enum Key: String {
        case selectedProductIndex = "selectedProductIndex"
        case transactionInProgress = "transactionInProgress"
        case purchaseItemsDelivered = "purchaseItemsDelivered"
    }
}
