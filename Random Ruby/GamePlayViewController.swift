//
//  GamePlayViewController.swift
//  Random Ruby
//
//  Created by Levi on 9/14/17.
//  Copyright © 2017 App Volks. All rights reserved.
//



//NEED TO CREATE PREPARE FOR SEGUE FOR DELEGATE: AT THE BOTTOM OF THIS WEBSITE https://www.appcoda.com/in-app-purchase-tutorial/



import UIKit
import GameKit
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit
import Social

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
    @IBOutlet weak var levelLabel: UILabel!
    
    var tileButtons = [UIButton]()
    var tileOriginalPositions = [CGPoint]()
    var answerPositions = [CGPoint]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let firstLoadCheck = UserDefaults.standard.object(forKey: GameLevel.Key.firstLoad.rawValue) as? Bool {
            if firstLoadCheck == true {
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
        
        let buttons = [rubyCounterButton,askFriendButton,removeButton,revealButton,homeButton,settingsButton,solveButton]
        for button in buttons {
            if let buttonUnwrapped = button {
                Utilities().setButtonShadow(button: buttonUnwrapped)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Utilities().updateRubyLabel(rubyCount: GameLevel.rubyCount, buttonForLabelUpdate: rubyCounterButton)
        setHeaderContent()
        
        if GameLevel.currentGameState == "finishedLevel" {
            setupNextLevelContent()
        }
        
        setLabels()
        setAnswerSpace()
        movePlayedTilesUponLoad()
        UserDefaultsHelper().saveGameContext()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print(GameLevel.currentGameState)
        if GameLevel.currentGameState == "gameOver" {
            performSegue(withIdentifier: "showCorrectView", sender: self)
        }
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
    @IBAction func facebookButton(_ sender: Any) {
        if(FBSDKAccessToken.current() != nil) {
            FacebookHelper().shareOnFB(vc: self)
        } else {
            FacebookHelper().loginFacebookAction(sender: self)
        }
    }
    
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
            if GameLevel.currentLevel < 299 {
                GameLevel.currentLevel += 1
                GameLevel.currentGameState = "finishedLevel"
            } else {
                GameLevel.currentGameState = "gameOver"
            }
            print(GameLevel.currentGameState)
            GameLevel.rubyCount += 1
            UserDefaultsHelper().saveGameContext()
            performSegue(withIdentifier: "showCorrectView", sender: self)
        } else {
            let messages = ["That's not it - try again!","Oooh...A good guess but no.","Keep guessing!","Incorrect. You'll get it next time!"]
            let message = Int(arc4random_uniform(4))
            Utilities().temporaryMessage(messageLabel: messageLabel, message: messages[message])
        }
    }
    
    @IBAction func removeButtonPressed(_ sender: Any) {
        if GameLevel.rubyCount >= 3 {
            if GameLevel.removeCount < GameLevel.incorrectTiles.count {
                let tileToRemove = GameLevel.incorrectTiles[GameLevel.removeCount]
                var i = 0
                var removeItemFound = false
                while removeItemFound == false {
                    if GameLevel.tileContents[i] == tileToRemove {
                        removeItemFound = true
                        let tile = tileButtons[i]
                        let tag = tile.tag
                        removeTile(tag: tag)
                        GameLevel.tileRemoved.append(tag)
                        GameLevel.rubyCount -= 3
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
    
    func removeTile(tag: Int) {
        tileButtons[tag].isHidden = true
        if GameLevel.tileInPlay[tag] != false {
            putTileBack(tileToMove: tag)
        }
    }
    
    @IBAction func revealButtonPressed(_ sender: Any) {
        if GameLevel.rubyCount >= 5 {
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
                                lockRevealedTile(tag: tag)
                                
                                GameLevel.tileRevealed.append(tag)
                                
                                GameLevel.rubyCount -= 5
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
    
    func lockRevealedTile(tag: Int) {
        tileButtons[tag].isUserInteractionEnabled = false
        tileButtons[tag].setTitleColor(UIColor(red: 208/255.0, green: 1/255.0, blue: 27/255.0, alpha: 1.0), for: .normal)
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
        }
        UserDefaultsHelper().saveGameContext()
    }
    
    // MOVE PLAYED TILES UPON LOAD
    func movePlayedTilesUponLoad() {
        if let tileInPlayCheck = UserDefaults.standard.object(forKey: GameLevel.Key.tileInPlay.rawValue) as? [Bool] {
            var i = 0
            for tileButton in tileButtons {
                if tileInPlayCheck[i] == true {
                    let position = GameLevel.tileAnswerPositions[i] - 1
                    tileButton.center = self.answerPositions[position]
                }
                i += 1
            }
        }
        if let tileRemovedCheck = UserDefaults.standard.object(forKey: GameLevel.Key.tileRemoved.rawValue) as? [Int] {
            GameLevel.tileRemoved = tileRemovedCheck
            if tileRemovedCheck != [] {
                for tile in tileRemovedCheck {
                    removeTile(tag: tile)
                }
            }
        }
        if let tileRevealedCheck = UserDefaults.standard.object(forKey: GameLevel.Key.tileRevealed.rawValue) as? [Int] {
            GameLevel.tileRevealed = tileRevealedCheck
            if tileRevealedCheck != [] {
                for tile in tileRevealedCheck {
                    lockRevealedTile(tag: tile)
                }
            }
        }
    }
    
    // SETUP RUBY COUNTER
    func setHeaderContent() {
        // SETUP DISPLAY
        rubyCounterButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5)
        levelLabel.text = "Level  \(GameLevel.currentLevel + 1)"
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



