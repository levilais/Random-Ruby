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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let buttons = [rubyCounterButton,askFriendButton,removeButton,revealButton,homeButton,settingsButton]
        for button in buttons {
            if let buttonUnwrapped = button {
                Utilities().setButtonShadow(button: buttonUnwrapped)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setRubyCounter()
        Utilities().updateRubyLabel(rubyCount: GameLevel.rubyCount, buttonForLabelUpdate: rubyCounterButton)
        
        print("GameLevel.currentGameState \(GameLevel.currentGameState)")
        if GameLevel.currentGameState == "activeLevel" {
            UserDefaultsHelper().loadActiveGameContext()
            setLabels()
            createTiles()
        } else if GameLevel.currentGameState == "finishedLevel" {
            Utilities().updateRubyLabel(rubyCount: GameLevel.rubyCount, buttonForLabelUpdate: rubyCounterButton)
            UserDefaultsHelper().loadNextLevelContent()
            GameLevel.currentGameState = "activeLevel"
            UserDefaultsHelper().saveGameContext()
        } else {
            if tileButtons.count == 0 {
                UserDefaultsHelper().loadNextLevelContent()
                setLabels()
                createTiles()
                setAnswerSpace()
            }
        }
    }
    
    func setupNewLevel() {
        GameLevel.comments = []
        GameLevel.tileContents = []
        GameLevel.correctTiles = []
        GameLevel.incorrectTiles = []
        GameLevel.existingAnswerTiles = 0
        GameLevel.answerCount = 0
        GameLevel.removeCount = 0
        GameLevel.tileInPlay = []
        GameLevel.tileOriginPositions = []
        GameLevel.tileAnswerPositions = []
        commentLabels = []
        resetAnswerSpace()
        UserDefaultsHelper().loadNextLevelContent()
        createTiles()
        
    }
    
    // ACTIONS
    @IBAction func homeButtonPressed(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @objc func titleButtonTapped(sender : UIButton) {
        let tile = sender
        let tag = tile.tag
        print("tile.tag: \(tile.tag)")
        if GameLevel.tileInPlay[tag] == false {
            placeTile(tileToMove: tag)
            GameLevel.tileInPlay[tag] = true
        } else {
            // PUT TILE BACK
            putTileBack(tileToMove: tag)
            GameLevel.tileInPlay[tag] = false
        }
        print(GameLevel.tileInPlay)
        
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
                        GameLevel.currentGameState = "activeLevel"
                        UserDefaultsHelper().saveGameContext()
                    }
                    i += 1
                }
                GameLevel.removeCount += 1
            }
        } else {
            Utilities().temporaryMessage(messageLabel: messageLabel, message: "You can buy rubies in the store")
        }
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
                                GameLevel.currentGameState = "activeLevel"
                                UserDefaultsHelper().saveGameContext()
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
    }
    
    func placeTile(tileToMove: Int) {
        let tileTag = tileToMove
        var i = 0
        if GameLevel.existingAnswerTiles < GameLevel.answerCount {
            // PLAY TILE
            var foundAnswerSpace = false
            while foundAnswerSpace == false {
                if GameLevel.answerTileExists[i] == false {
                    tileButtons[tileTag].center = GameLevel.answerPositions[i]
                    GameLevel.answerTileExists[i] = true
                    GameLevel.tileInPlay[tileTag] = true
                    GameLevel.existingAnswerTiles = GameLevel.existingAnswerTiles + 1
                    GameLevel.solutionGuess[i] = GameLevel.tileContents[tileTag]
                    GameLevel.tileAnswerPositions[tileTag] = i
                    foundAnswerSpace = true
                }
                i += 1
            }
        }
    }
    
    func putTileBack(tileToMove: Int) {
        let tileAnswerPosition = GameLevel.tileAnswerPositions[tileToMove]
        GameLevel.answerTileExists[tileAnswerPosition] = false
        GameLevel.existingAnswerTiles = GameLevel.existingAnswerTiles - 1
        GameLevel.tileInPlay[tileToMove] = false
        GameLevel.solutionGuess[tileAnswerPosition] = ""
        tileButtons[tileToMove].center = GameLevel.tileOriginPositions[tileToMove]
    }
    
    // SETUP ANSWER SPACE
    func setAnswerSpace() {
        gamePlayView.layoutIfNeeded()
        
        var i = 0
        for answerSpace in answerSpaces {
            if i < GameLevel.answerCount {
                let answerPosition = CGPoint(x: answerSpace.center.x, y: answerSpace.center.y)
                if GameLevel.currentGameState != "activeLevel" {
                    GameLevel.answerPositions.append(answerPosition)
                    GameLevel.answerTileExists.append(false)
                    GameLevel.solutionGuess.append("")
                }
            } else {
                answerSpace.isHidden = true
            }
            i += 1
        }
    }
    
    func resetAnswerSpace() {
        gamePlayView.layoutIfNeeded()
        
        GameLevel.answerPositions = []
        GameLevel.solutionGuess = []
        GameLevel.answerTileExists = []
        
        var i = 0
        for answerSpace in answerSpaces {
            answerSpace.isHidden = false
            i += 1
        }
        
        i = 0
        for answerSpace in answerSpaces {
            if GameLevel.solutionGuess.count == 0 {
                let answerPosition = CGPoint(x: answerSpace.center.x, y: answerSpace.center.y)
                GameLevel.answerPositions.append(answerPosition)
                GameLevel.answerTileExists.append(false)
                GameLevel.solutionGuess.append("")
            } else {
                answerSpace.isHidden = true
            }
            i += 1
        }
    }
    
    // SETUP TILES
    func createTiles() {
        gamePlayView.layoutIfNeeded()
        if tileButtons == [] {
            resetTiles()
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
                tileButtons.append(tileButton)
                gamePlayView.addSubview(tileButton)
                tileButton.bringSubview(toFront: gamePlayView)
                GameLevel.tileInPlay.append(false)
                GameLevel.tileAnswerPositions.append(0)
                GameLevel.tileOriginPositions.append(CGPoint(x: tileButton.center.x, y: tileButton.center.y))
                i += 1
            }
        } else {
            var i = 0
            for button in tileButtons {
                if GameLevel.tileInPlay[i] == true {
                    button.center = GameLevel.answerPositions[i]
                } else {
                    button.center = GameLevel.tileOriginPositions[i]
                }
                i += 1
            }
        }
    }
    
    // RESET TILES
    func resetTiles() {
        tileButtons = []
        GameLevel.tileInPlay = []
        GameLevel.tileAnswerPositions = []
        GameLevel.tileOriginPositions = []
    }
    
    // SETUP RUBY COUNTER
    func setRubyCounter() {
        // SETUP DISPLAY
        rubyCounterButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5)
    }
    
    // SETUP LABELS
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



