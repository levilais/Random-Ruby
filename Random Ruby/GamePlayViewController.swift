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
    
    // GAME VARIABLES
    var rubyCount = Int()
    var currentLevel = 0
    var gameState = GameLevel.GameState.firstLevel
    
    // LEVEL VARIABLES
    var comments = [String]()
    var tileButtons = [UIButton]()
    var tileContents = [String]()
    var correctTiles = [String]()
    var incorrectTiles = [String]()
    var answer = String()
    
    // LEVEL TRACKER VARIABLES
    var removeCount = 0
    
    // TILE TRACKERS
    var tileInPlay = [Bool]()
    var tileOriginPositions: [CGPoint] = [CGPoint]()
    var tileAnswerPositions = [Int]()
    var existingAnswerTiles = 0
    
    // ANSWER SPACE TRACKERS
    var solutionGuess = [String]()
    var answerPositions: [CGPoint] = [CGPoint]()
    var answerTileExists = [Bool]()
    var answerCount = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let buttons = [rubyCounterButton,askFriendButton,removeButton,revealButton,homeButton,settingsButton]
        for button in buttons {
            if let buttonUnwrapped = button {
                Utilities().setButtonShadow(button: buttonUnwrapped)
            }
        }
        
        rubyCount = 150
        Utilities().updateRubyLabel(rubyCount: rubyCount, buttonForLabelUpdate: rubyCounterButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if existingAnswerTiles > 0 {
            setNextLevel()
        } else {
            setLevelContent()
            setRubyCounter()
            setLabels()
            setTiles()
            setAnswerSpace()
        }
    }
    
    func setNextLevel() {
        Utilities().updateRubyLabel(rubyCount: rubyCount, buttonForLabelUpdate: rubyCounterButton)
        comments = []
        tileContents = []
        correctTiles = []
        incorrectTiles = []
        existingAnswerTiles = 0
        answerCount = 0
        removeCount = 0
        setLevelContent()
        resetAnswerSpace()
        for i in 0..<10 {
            if tileInPlay[i] == true {
                tileButtons[i].center = tileOriginPositions[i]
                tileInPlay[i] = false
            }
            tileButtons[i].isHidden = false
            tileButtons[i].isUserInteractionEnabled = true
            tileButtons[i].setTitleColor(UIColor(red: 35/255.0, green: 100/255.0, blue: 170/255.0, alpha: 1.0), for: .normal)
            tileButtons[i].setTitle(String(self.tileContents[i]), for: .normal)
        }
        var i = 0
        for comment in GameLevel.comments {
            commentLabels[i].text = comment
            i += 1
        }
    }
    
    // ACTIONS
    @IBAction func homeButtonPressed(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @objc func titleButtonTapped(sender : UIButton) {
        let tile = sender
        let tag = tile.tag
        if tileInPlay[tag] == false {
            placeTile(tileToMove: tag)
        } else {
            // PUT TILE BACK
            putTileBack(tileToMove: tag)
        }
    }
    
    @IBAction func solveButtonPressed(_ sender: Any) {
        if solutionGuess.joined() == answer {
            currentLevel += 1
            rubyCount += 4
            performSegue(withIdentifier: "showCorrectView", sender: self)
        } else {
            let messages = ["That's not it - try again!","Oooh...A good guess but no.","Keep guessing!","Incorrect. You'll get it next time!"]
            let message = Int(arc4random_uniform(4))
            Utilities().temporaryMessage(messageLabel: messageLabel, message: messages[message])
        }
    }
    
    @IBAction func removeButtonPressed(_ sender: Any) {
        if rubyCount >= 4 {
            if removeCount < incorrectTiles.count {
                let tileToRemove = incorrectTiles[removeCount]
                var i = 0
                var removeItemFound = false
                while removeItemFound == false {
                    if tileContents[i] == tileToRemove {
                        tileButtons[i].isHidden = true
                        removeItemFound = true
                        let tile = tileButtons[i]
                        let tag = tile.tag
                        if tileInPlay[tag] != false {
                            // PUT TILE BACK
                            putTileBack(tileToMove: tag)
                        }
                        print("rubyCount Before \(rubyCount)")
                        rubyCount -= 4
                        print("rubyCount After \(rubyCount)")
                        Utilities().updateRubyLabel(rubyCount: rubyCount, buttonForLabelUpdate: rubyCounterButton)
                    }
                    i += 1
                }
                removeCount += 1
            }
        } else {
            Utilities().temporaryMessage(messageLabel: messageLabel, message: "You can buy rubies in the store")
        }
    }
    
    @IBAction func revealButtonPressed(_ sender: Any) {
        if rubyCount >= 4 {
            if existingAnswerTiles == answerCount && solutionGuess.joined() == answer {
                Utilities().temporaryMessage(messageLabel: messageLabel, message: "Did you mean to press \"Solve\"?")
            } else if existingAnswerTiles == answerCount && solutionGuess.joined() != answer {
                Utilities().temporaryMessage(messageLabel: messageLabel, message: "Remove a tile and try again")
            } else {
                var i = 0
                var emptySpaceFound = false
                while emptySpaceFound == false {
                    if answerTileExists[i] != true {
                        let answerArray = answer.map() { String($0) }
                        let tileToReveal = answerArray[i]
                        var i2 = 0
                        var revealItemFound = false
                        while revealItemFound == false {
                            if tileContents[i2] == tileToReveal {
                                revealItemFound = true
                                let tile = tileButtons[i2]
                                let tag = tile.tag
                                placeTile(tileToMove: tag)
                                tileButtons[tag].isUserInteractionEnabled = false
                                tileButtons[tag].setTitleColor(UIColor(red: 208/255.0, green: 1/255.0, blue: 27/255.0, alpha: 1.0), for: .normal)
                                rubyCount -= 4
                                Utilities().updateRubyLabel(rubyCount: rubyCount, buttonForLabelUpdate: rubyCounterButton)
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
        if existingAnswerTiles < answerCount {
            // PLAY TILE
            var foundAnswerSpace = false
            while foundAnswerSpace == false {
                if answerTileExists[i] == false {
                    tileButtons[tileTag].center = answerPositions[i]
                    answerTileExists[i] = true
                    tileInPlay[tileTag] = true
                    existingAnswerTiles = existingAnswerTiles + 1
                    solutionGuess[i] = tileContents[tileTag]
                    tileAnswerPositions[tileTag] = i
                    foundAnswerSpace = true
                }
                i += 1
            }
        }
    }
    
    func putTileBack(tileToMove: Int) {
        let tileAnswerPosition = tileAnswerPositions[tileToMove]
        answerTileExists[tileAnswerPosition] = false
        existingAnswerTiles = existingAnswerTiles - 1
        tileInPlay[tileToMove] = false
        solutionGuess[tileAnswerPosition] = ""
        tileButtons[tileToMove].center = tileOriginPositions[tileToMove]
    }
    
    // SETUP LEVEL CONTENT
    func setLevelContent() {
        // GET DATA
        if let url = Bundle.main.url(forResource: "randomRubyJsonData", withExtension: "json") {
            if let data = NSData(contentsOf: url) {
                do {
                    let object = try JSONSerialization.jsonObject(with: data as Data, options: .allowFragments)
                    if let dataArray = object as? (Array<Dictionary<String, AnyObject>>) {
                        // SET THE LEVEL FOR THE CORRECT DATA
                        let levelData = dataArray[currentLevel]
                        // ANSWER CONTENT
                        if let answer = levelData["answer"] as? String {
                            self.answer = answer
                        }
                        
                        if let answerCountCheck = levelData["answerCount"] as? Int {
                            self.answerCount = answerCountCheck
                        }
                        // GET COMMENTS
                        for i in 1...3 {
                            let comment = "comment" + String(i)
                            if let commentContent = levelData[comment] as? String {
                                self.comments.append(commentContent)
                            }
                        }
                        // TILE CONTENTS
                        for i in 1...10 {
                            let tile = "t" + String(i)
                            if let tileContent = levelData[tile] as? String {
                                self.tileContents.append(tileContent)
                                if i <= answerCount {
                                    self.correctTiles.append(tileContent)
                                } else {
                                    self.incorrectTiles.append(tileContent)
                                }
                            }
                        }
                        tileContents.shuffle()
                        incorrectTiles.shuffle()
                    }
                } catch {
                    // handle error
                }
            }
        }
    }
    
    // SETUP ANSWER SPACE
    func setAnswerSpace() {
        gamePlayView.layoutIfNeeded()
        
        var i = 0
        for answerSpace in answerSpaces {
            if i < answerCount {
                let answerPosition = CGPoint(x: answerSpace.center.x, y: answerSpace.center.y)
                self.answerPositions.append(answerPosition)
                self.answerTileExists.append(false)
                self.solutionGuess.append("")
            } else {
                answerSpace.isHidden = true
            }
            i += 1
        }
    }
    
    func resetAnswerSpace() {
        gamePlayView.layoutIfNeeded()
        
        answerPositions = []
        solutionGuess = []
        answerTileExists = []
        
        var i = 0
        for answerSpace in answerSpaces {
            answerSpace.isHidden = false
            i += 1
        }
        
        i = 0
        for answerSpace in answerSpaces {
            if i < answerCount {
                let answerPosition = CGPoint(x: answerSpace.center.x, y: answerSpace.center.y)
                self.answerPositions.append(answerPosition)
                self.answerTileExists.append(false)
                self.solutionGuess.append("")
            } else {
                answerSpace.isHidden = true
            }
            i += 1
        }
    }
    
    // SETUP TILES
    func setTiles() {
        gamePlayView.layoutIfNeeded()
        
        var i = 0
        for solutionSpace in solutionSpaces {
            let tileButton = UIButton(frame: CGRect(x: solutionSpace.center.x - solutionSpace.frame.width / 2, y: solutionSpace.center.y - solutionSpace.frame.height / 2, width: solutionSpace.frame.width, height: solutionSpace.frame.height))
            tileButton.tag = i
            tileButton.setBackgroundImage(UIImage(named: "answerTile.pdf"), for: .normal)
            tileButton.setTitle(String(self.tileContents[i]), for: .normal)
            tileButton.titleLabel?.font = UIFont.systemFont(ofSize: Utilities().screenBasedFontSize(minimumFontSize: 15), weight: UIFont.Weight.heavy)
            tileButton.setTitleColor(UIColor(red: 35/255.0, green: 100/255.0, blue: 170/255.0, alpha: 1.0), for: .normal)
            Utilities().setButtonShadow(button: tileButton)
            tileButton.addTarget(self, action:#selector(self.titleButtonTapped(sender:)), for: .touchUpInside)
            tileOriginPositions.append(CGPoint(x: tileButton.center.x, y: tileButton.center.y))
            tileButtons.append(tileButton)
            tileInPlay.append(false)
            tileAnswerPositions.append(0)
            gamePlayView.addSubview(tileButton)
            tileButton.bringSubview(toFront: gamePlayView)
            i += 1
        }
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
            label.text = comments[i]
            label.adjustsFontSizeToFitWidth = true
            label.numberOfLines = 4
            label.font = label.font.withSize(newFontSize)
            i += 1
        }
    }
}



