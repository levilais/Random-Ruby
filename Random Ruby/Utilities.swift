//
//  Utilities.swift
//  Random Ruby
//
//  Created by Levi on 9/18/17.
//  Copyright © 2017 App Volks. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration

class Utilities {
    
    // GET MATH TO ADJUST DISPLAY FOR SCREEN SIZE OF DEVICE
    func screenBasedFontSize(minimumFontSize: CGFloat) -> CGFloat {
        let screen = UIScreen.main
        let newFontSize = screen.bounds.size.width * (minimumFontSize / 320.0)
        return newFontSize
    }
    
    // CHANGE MESSAGE LABEL FOR 3 SECONDS AND RETURN TO ORIGINAL MESSAGE
    func temporaryMessage(messageLabel: UILabel, message: String) {
        messageLabel.text = message
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(3), execute: { () -> Void in
            UIView.animate(withDuration: 1, animations: { () -> Void in
                messageLabel.text = "What's the common thread?"
            })
        })
    }
    
    // SET RUBY LABEL TO NEW RUBY COUNT
    func updateRubyLabel(rubyCount: Int, buttonForLabelUpdate: UIButton) {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        let formattedNumber = numberFormatter.string(from: NSNumber(value:rubyCount))
        if let newRubyAmount = formattedNumber {
            buttonForLabelUpdate.setTitle(String(describing: newRubyAmount), for: .normal)
        }
    }
    
    // SET BUTTON SHADOWS
    func setButtonShadow(button: UIButton) {
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        button.layer.masksToBounds = false
        button.layer.shadowOpacity = 0.3
    }
    
    // PRINT DATA
    func printData() {
        print("Ruby Count: \(GameLevel.rubyCount)")
        print("currentLevel: \(GameLevel.currentLevel)")
        print("currentGameState: \(GameLevel.currentGameState)")
        print("comments: \(GameLevel.comments)")
        print("tileContents: \(GameLevel.tileContents)")
        print("correctTiles: \(GameLevel.correctTiles)")
        print("incorrectTiles: \(GameLevel.incorrectTiles)")
        print("answer: \(GameLevel.answer)")
        print("removeCount: \(GameLevel.removeCount)")
        print("tileInPlay: \(GameLevel.tileInPlay)")
        print("tileAnswerPositions: \(GameLevel.tileAnswerPositions)")
        print("existingAnswerTiles: \(GameLevel.existingAnswerTiles)")
        print("solutionGuess: \(GameLevel.solutionGuess)")
        print("answerTileExists: \(GameLevel.answerTileExists)")
        print("answerCount: \(GameLevel.answerCount)")
    }
}

public class ConnectionCheck {
    class func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                zeroSockAddress in SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, zeroSockAddress)}
        } ) else {
            return false
        }
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) == false {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let value = (isReachable && !needsConnection)
        
        return value
    }
}

extension MutableCollection {
    /// Shuffles the contents of this collection.
    mutating func shuffle() {
        let c = count
        guard c > 1 else { return }
        
        for (firstUnshuffled, unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)) {
            let d: IndexDistance = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            let i = index(firstUnshuffled, offsetBy: d)
            swapAt(firstUnshuffled, i)
        }
    }
}
