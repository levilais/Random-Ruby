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
    static var rubyCount = 150
    static var currentLevel = 0
    static var currentGameState = "firstLevel"
    
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
    static var tileOriginPositions: [CGPoint] = [CGPoint]()
    static var tileAnswerPositions = [Int]()
    static var existingAnswerTiles = 0
    
    // ANSWER SPACE TRACKERS
    static var solutionGuess = [String]()
    static var answerPositions: [CGPoint] = [CGPoint]()
    static var answerTileExists = [Bool]()
    static var answerCount = Int()
    
//    enum GameState: String {
//        case firstLevel = "firstLevel"
//        case activeLevel = "activeLevel"
//        case finishedLevel = "finishedLevel"
//    }
    
    // KEYS FOR DATA READ/WRITE
    enum Key: String {
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
        case tileOriginPositions = "tileOriginPositions"
        case tileAnswerPositions = "tileAnswerPositions"
        case existingAnswerTiles = "existingAnswerTiles"
        case solutionGuess = "solutionGuess"
        case answerPositions = "answerPositions"
        case answerTileExists = "answerTileExists"
        case answerCount = "answerCount"
    }
}
