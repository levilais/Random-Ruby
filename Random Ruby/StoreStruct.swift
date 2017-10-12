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
    func getButtonBackgroundImages() -> [UIImage] {
        let imageNames = ["rubies50.pdf","rubies250.pdf","rubies750.pdf","rubies1500.pdf","rubies3000.pdf","rubies6000.pdf","rubies9000.pdf"]
        var purchaseImages: [UIImage] = [UIImage]()
        for i in 0..<imageNames.count {
            if let image = UIImage(named: imageNames[i]) {
                purchaseImages.append(image)
            }
        }
        return purchaseImages
    }
}
