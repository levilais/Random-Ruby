//
//  GamePlayViewController.swift
//  Random Ruby
//
//  Created by Levi on 9/14/17.
//  Copyright © 2017 App Volks. All rights reserved.
//

import UIKit
import GameKit

class GamePlayViewController: UIViewController {
    
    // OUTLETS
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var gamePlayView: UIView!
    @IBOutlet weak var rubyCounterButton: UIButton!
    @IBOutlet var commentLabels: [UILabel]!
    @IBOutlet var answerSpaces: [UIImageView]!
    @IBOutlet var solutionSpaces: [UIImageView]!
    @IBOutlet weak var askFriendButton: UIButton!
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var revealButton: UIButton!
    @IBOutlet weak var solveButton: UIButton!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    
    var tileButtons = [UIButton]()
    var tileOriginalPositions = [CGPoint]()
    var answerPositions = [CGPoint]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let firstLoadCheck = UserDefaults.standard.object(forKey: GameLevel.Key.firstLoad.rawValue) as? Bool {
            if firstLoadCheck == true {
                print("worked")
                UserDefaultsHelper().loadNextLevelContent()
                GameLevel.firstLoad = false
                UserDefaults.standard.set(GameLevel.firstLoad, forKey: GameLevel.Key.firstLoad.rawValue)
            } else {
                UserDefaultsHelper().loadActiveGameContext()
            }
        } else {
            UserDefaultsHelper().loadNextLevelContent()
            GameLevel.firstLoad = false
            UserDefaults.standard.set(GameLevel.firstLoad, forKey: GameLevel.Key.firstLoad.rawValue)
        }
        
        setTiles()
        
        let buttons = [rubyCounterButton,askFriendButton,removeButton,revealButton,homeButton,settingsButton]
        for button in buttons {
            if let buttonUnwrapped = button {
                Utilities().setButtonShadow(button: buttonUnwrapped)
            }
        }
        Utilities().updateRubyLabel(rubyCount: GameLevel.rubyCount, buttonForLabelUpdate: rubyCounterButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setRubyCounter()
        
        print("currentGameState \(GameLevel.currentGameState)")
        if GameLevel.currentGameState == "finishedLevel" {
            setupNextLevelContent()
        }
        
        setLabels()
        setAnswerSpace()
        UserDefaultsHelper().saveGameContext()
    }
    
    func setupNextLevelContent() {
        Utilities().updateRubyLabel(rubyCount: GameLevel.rubyCount, buttonForLabelUpdate: rubyCounterButton)
        GameLevel.comments = []
        GameLevel.tileContents = []
        GameLevel.correctTiles = []
        GameLevel.incorrectTiles = []
        GameLevel.existingAnswerTiles = 0
        GameLevel.answerCount = 0
        GameLevel.removeCount = 0
        
        UserDefaultsHelper().loadNextLevelContent()
        
        resetAnswerSpace()
        
        if tileButtons.count > 0 {
            for i in 0..<10 {
                tileButtons[i].center = self.tileOriginalPositions[i]
                tileButtons[i].isHidden = false
                tileButtons[i].isUserInteractionEnabled = true
                tileButtons[i].setTitleColor(UIColor(red: 35/255.0, green: 100/255.0, blue: 170/255.0, alpha: 1.0), for: .normal)
                tileButtons[i].setTitle(String(GameLevel.tileContents[i]), for: .normal)
            }
        } else {
            setTiles()
        }
    }
    
    // ACTIONS
    @IBAction func homeButtonPressed(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @objc func titleButtonTapped(sender : UIButton) {
        let tile = sender
        let tag = tile.tag
        if GameLevel.tileInPlay[tag] == false {
            placeTile(tileToMove: tag)
        } else {
            putTileBack(tileToMove: tag)
        }
        GameLevel.currentGameState = "activeLevel"
        UserDefaultsHelper().saveGameContext()
    }
    
    @IBAction func solveButtonPressed(_ sender: Any) {
        if GameLevel.solutionGuess.joined() == GameLevel.answer {
            GameLevel.currentLevel += 1
            GameLevel.rubyCount += 4
            GameLevel.currentGameState = "finishedLevel"
            UserDefaultsHelper().saveGameContext()
            performSegue(withIdentifier: "showCorrectView", sender: self)
        } else {
            let messages = ["That's not it - try again!","Oooh...A good guess but no.","Keep guessing!","Incorrect. You'll get it next time!"]
            let message = Int(arc4random_uniform(4))
            Utilities().temporaryMessage(messageLabel: messageLabel, message: messages[message])
        }
    }
    
    @IBAction func removeButtonPressed(_ sender: Any) {
        if GameLevel.rubyCount >= 4 {
            if GameLevel.removeCount < GameLevel.incorrectTiles.count {
                let tileToRemove = GameLevel.incorrectTiles[GameLevel.removeCount]
                var i = 0
                var removeItemFound = false
                while removeItemFound == false {
                    if GameLevel.tileContents[i] == tileToRemove {
                        tileButtons[i].isHidden = true
                        removeItemFound = true
                        let tile = tileButtons[i]
                        let tag = tile.tag
                        if GameLevel.tileInPlay[tag] != false {
                            // PUT TILE BACK
                            putTileBack(tileToMove: tag)
                        }
                        GameLevel.rubyCount -= 4
                        Utilities().updateRubyLabel(rubyCount: GameLevel.rubyCount, buttonForLabelUpdate: rubyCounterButton)
                    }
                    i += 1
                }
                GameLevel.removeCount += 1
            }
        } else {
            Utilities().temporaryMessage(messageLabel: messageLabel, message: "You can buy rubies in the store")
        }
        GameLevel.currentGameState = "activeLevel"
        UserDefaultsHelper().saveGameContext()
    }
    
    @IBAction func revealButtonPressed(_ sender: Any) {
        if GameLevel.rubyCount >= 4 {
            if GameLevel.existingAnswerTiles == GameLevel.answerCount && GameLevel.solutionGuess.joined() == GameLevel.answer {
                Utilities().temporaryMessage(messageLabel: messageLabel, message: "Did you mean to press \"Solve\"?")
            } else if GameLevel.existingAnswerTiles == GameLevel.answerCount && GameLevel.solutionGuess.joined() != GameLevel.answer {
                Utilities().temporaryMessage(messageLabel: messageLabel, message: "Remove a tile and try again")
            } else {
                var i = 0
                var emptySpaceFound = false
                while emptySpaceFound == false {
                    if GameLevel.answerTileExists[i] != true {
                        let answerArray = GameLevel.answer.map() { String($0) }
                        let tileToReveal = answerArray[i]
                        var i2 = 0
                        var revealItemFound = false
                        while revealItemFound == false {
                            if GameLevel.tileContents[i2] == tileToReveal {
                                revealItemFound = true
                                let tile = tileButtons[i2]
                                let tag = tile.tag
                                placeTile(tileToMove: tag)
                                tileButtons[tag].isUserInteractionEnabled = false
                                tileButtons[tag].setTitleColor(UIColor(red: 208/255.0, green: 1/255.0, blue: 27/255.0, alpha: 1.0), for: .normal)
                                GameLevel.rubyCount -= 4
                                Utilities().updateRubyLabel(rubyCount: GameLevel.rubyCount, buttonForLabelUpdate: rubyCounterButton)
                            }
                            i2 += 1
                        }
                        emptySpaceFound = true
                    }
                    i += 1
                }
            }
        } else {
            Utilities().temporaryMessage(messageLabel: messageLabel, message: "You can buy rubies in the store")
        }
        GameLevel.currentGameState = "activeLevel"
        UserDefaultsHelper().saveGameContext()
    }
    
    func placeTile(tileToMove: Int) {
        let tileTag = tileToMove
        var i = 0
        if GameLevel.existingAnswerTiles < GameLevel.answerCount {
            // PLAY TILE
            var foundAnswerSpace = false
            while foundAnswerSpace == false {
                if GameLevel.answerTileExists[i] == false {
                    tileButtons[tileTag].center = self.answerPositions[i]
                    GameLevel.answerTileExists[i] = true
                    GameLevel.tileInPlay[tileTag] = true
                    GameLevel.existingAnswerTiles = GameLevel.existingAnswerTiles + 1
                    GameLevel.solutionGuess[i] = GameLevel.tileContents[tileTag]
                    GameLevel.tileAnswerPositions[tileTag] = i + 1
                    foundAnswerSpace = true
                }
                i += 1
            }
        }
        GameLevel.currentGameState = "activeLevel"
        UserDefaultsHelper().saveGameContext()
    }
    
    func putTileBack(tileToMove: Int) {
        let tileAnswerPosition = GameLevel.tileAnswerPositions[tileToMove] - 1
        GameLevel.answerTileExists[tileAnswerPosition] = false
        GameLevel.existingAnswerTiles = GameLevel.existingAnswerTiles - 1
        GameLevel.tileInPlay[tileToMove] = false
        GameLevel.solutionGuess[tileAnswerPosition] = ""
        tileButtons[tileToMove].center = self.tileOriginalPositions[tileToMove]
        GameLevel.tileAnswerPositions[tileToMove] = 0
    }
    
    
    // SETUP ANSWER SPACE
    func setAnswerSpace() {
        gamePlayView.layoutIfNeeded()
        var i = 0
        for answerSpace in answerSpaces {
            if i < GameLevel.answerCount {
                let answerPosition = CGPoint(x: answerSpace.center.x, y: answerSpace.center.y)
                self.answerPositions.append(answerPosition)
            } else {
                answerSpace.isHidden = true
            }
            i += 1
        }
    }
    
    func resetAnswerSpace() {
        gamePlayView.layoutIfNeeded()
        self.answerPositions = []
        var i = 0
        for answerSpace in answerSpaces {
            answerSpace.isHidden = false
            i += 1
        }
        setAnswerSpace()
    }
    
    // SETUP TILES
    func setTiles() {
        var tilesExists = false
        if tileButtons.count > 0 {
            tilesExists = true
        }
        
        gamePlayView.layoutIfNeeded()
        
        if tilesExists == false {
            var i = 0
            for solutionSpace in solutionSpaces {
                let tileButton = UIButton(frame: CGRect(x: solutionSpace.center.x - solutionSpace.frame.width / 2, y: solutionSpace.center.y - solutionSpace.frame.height / 2, width: solutionSpace.frame.width, height: solutionSpace.frame.height))
                tileButton.tag = i
                tileButton.setBackgroundImage(UIImage(named: "answerTile.pdf"), for: .normal)
                tileButton.setTitle(String(GameLevel.tileContents[i]), for: .normal)
                tileButton.titleLabel?.font = UIFont.systemFont(ofSize: Utilities().screenBasedFontSize(minimumFontSize: 15), weight: UIFont.Weight.heavy)
                tileButton.setTitleColor(UIColor(red: 35/255.0, green: 100/255.0, blue: 170/255.0, alpha: 1.0), for: .normal)
                Utilities().setButtonShadow(button: tileButton)
                tileButton.addTarget(self, action:#selector(self.titleButtonTapped(sender:)), for: .touchUpInside)
                self.tileOriginalPositions.append(CGPoint(x: tileButton.center.x, y: tileButton.center.y))
                tileButtons.append(tileButton)
                gamePlayView.addSubview(tileButton)
                tileButton.bringSubview(toFront: gamePlayView)
                i += 1
            }
        } else {
            print("tileButtons.count: \(tileButtons.count)")
            for i in 0..<tileButtons.count {
                if GameLevel.tileInPlay[i] == true {
                    tileButtons[i].center = self.answerPositions[i]
                } else {
                    tileButtons[i].center = self.tileOriginalPositions[i]
                }
            }
        }
        UserDefaultsHelper().saveGameContext()
    }
    
    // SETUP RUBY COUNTER
    func setRubyCounter() {
        // SETUP DISPLAY
        rubyCounterButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5)
    }
    
    // SETUP COMMENT LABELS
    func setLabels() {
        let newFontSize = Utilities().screenBasedFontSize(minimumFontSize: 15)
        
        var i = 0
        for label in commentLabels {
            label.text = GameLevel.comments[i]
            label.adjustsFontSizeToFitWidth = true
            label.numberOfLines = 4
            label.font = label.font.withSize(newFontSize)
            i += 1
        }
    }
}



