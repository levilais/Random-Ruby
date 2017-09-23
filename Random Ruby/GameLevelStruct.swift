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
    static var rubyCount = Int()
    static var currentLevel = 0
    static var gameState = GameLevel.GameState.firstLevel
    
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
    
    enum GameState: Int {
        case firstLevel = 0
        case activeLevel = 1
        case finishedLevel = 2
    }
}
