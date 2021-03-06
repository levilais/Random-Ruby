//
//  GameLevelStruct.swift
//  Random Ruby
//
//  Created by Levi on 9/23/17.
//  Copyright © 2017 App Volks. All rights reserved.
//

import Foundation
import UIKit

class GameLevel {
    // GAME VARIABLES
    static var firstLoad = true
    static var rubyCount = 20 {
        didSet  {
            print("rubyCount was updated")
            let rubyDataDict:[String: Int] = ["rubyCount": rubyCount]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "rubiesChanged"), object: nil, userInfo: rubyDataDict)
            UserDefaults.standard.set(GameLevel.rubyCount, forKey: GameLevel.Key.rubyCount.rawValue)
        }
    }
    static var currentLevel = 0
    static var currentGameState = "newGame" // "activeLevel", "finishedLevel", "gameOver"
    static var tilesExist = false
    
    // LEVEL VARIABLES
    static var comments = [String]()
    static var tileButtons = [UIButton]()
    static var tileContents = [String]()
    static var correctTiles = [String]()
    static var incorrectTiles = [String]()
    static var answer = String()
    
    // LEVEL TRACKER VARIABLES
    static var removeCount = 0
    
    // TILE TRACKERS
    static var tileInPlay = [Bool]()
    static var tileAnswerPositions = [Int]()
    static var existingAnswerTiles = 0
    static var tileRemoved = [Int]()
    static var tileRevealed = [Int]()
    
    // ANSWER SPACE TRACKERS
    static var solutionGuess = [String]()
    static var answerTileExists = [Bool]()
    static var answerCount = Int()
    
    // KEYS FOR DATA READ/WRITE
    enum Key: String {
        case firstLoad = "firstLoad"
        case tilesExist = "tilesExist"
        case rubyCount = "rubyCount"
        case currentLevel = "currentLevel"
        case currentGameState = "gameState"
        case comments = "comments"
        case tileButtons = "tileButtons"
        case tileContents = "tileContents"
        case correctTiles = "correctTiles"
        case incorrectTiles = "incorrectTiles"
        case answer = "answer"
        case removeCount = "removeCount"
        case tileInPlay = "tileInPlay"
        case tileAnswerPositions = "tileAnswerPositions"
        case existingAnswerTiles = "existingAnswerTiles"
        case solutionGuess = "solutionGuess"
        case answerTileExists = "answerTileExists"
        case answerCount = "answerCount"
        case tileRemoved = "tileRemoved"
        case tileRevealed = "tileRevealed"
    }
}
