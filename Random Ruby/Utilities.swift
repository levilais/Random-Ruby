//
//  Utilities.swift
//  Random Ruby
//
//  Created by Levi on 9/18/17.
//  Copyright © 2017 App Volks. All rights reserved.
//

import Foundation
import UIKit

class Utilities {
    
    // GET MATH TO ADJUST DISPLAY FOR SCREEN SIZE OF DEVICE
    func screenBasedFontSize(minimumFontSize: CGFloat) -> CGFloat {
        let screen = UIScreen.main
        var newFontSize = screen.bounds.size.height * (minimumFontSize / 568.0)
        if (screen.bounds.size.height < 500) {
            newFontSize = screen.bounds.size.height * (minimumFontSize / 480.0)
        }
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
