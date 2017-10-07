//
//  UserDefaultsHelper.swift
//  Random Ruby
//
//  Created by Levi on 9/22/17.
//  Copyright © 2017 App Volks. All rights reserved.
//

import Foundation
import UIKit

class UserDefaultsHelper {
    
    // SETUP LEVEL CONTENT
    func loadNextLevelContent() {
        
        // GET DATA
        if let url = Bundle.main.url(forResource: "randomRubyJsonData", withExtension: "json") {
            if let data = NSData(contentsOf: url) {
                do {
                    let object = try JSONSerialization.jsonObject(with: data as Data, options: .allowFragments)
                    if let dataArray = object as? (Array<Dictionary<String, AnyObject>>) {
                        // SET THE LEVEL FOR THE CORRECT DATA
                        let levelData = dataArray[GameLevel.currentLevel]
                        
                        // ANSWER CONTENT
                        if let answer = levelData["answer"] as? String {
                            GameLevel.answer = answer
                        }
                        if let answerCountCheck = levelData["answerCount"] as? Int {
                            GameLevel.answerCount = answerCountCheck
                        }
                        GameLevel.answerTileExists = []
                        GameLevel.solutionGuess = []
                        var i = 0
                        while i < GameLevel.answerCount {
                            GameLevel.answerTileExists.append(false)
                            GameLevel.solutionGuess.append("")
                            i += 1
                        }
                        
                        // GET COMMENTS
                        for i in 1...3 {
                            let comment = "comment" + String(i)
                            if let commentContent = levelData[comment] as? String {
                                GameLevel.comments.append(commentContent)
                            }
                        }
                        
                        // TILE CONTENTS
                        GameLevel.tileInPlay = []
                        GameLevel.tileAnswerPositions = []
                        GameLevel.tileRemoved = []
                        GameLevel.tileRevealed = []
                        for i in 1...10 {
                            let tile = "t" + String(i)
                            if let tileContent = levelData[tile] as? String {
                                GameLevel.tileContents.append(tileContent)
                                if i <= GameLevel.answerCount {
                                    GameLevel.correctTiles.append(tileContent)
                                } else {
                                    GameLevel.incorrectTiles.append(tileContent)
                                }
                            }
                            GameLevel.tileInPlay.append(false)
                            GameLevel.tileAnswerPositions.append(0)
                        }
                        
                        GameLevel.tileContents.shuffle()
                        GameLevel.incorrectTiles.shuffle()
                    }
                } catch {
                    // handle error
                }
            }
        }
        UserDefaultsHelper().saveGameContext()
    }
    
    // SAVE ACTIVE GAME CONTEXT
    func saveGameContext() {
        UserDefaults.standard.set(GameLevel.tilesExist, forKey: GameLevel.Key.tilesExist.rawValue)
        UserDefaults.standard.set(GameLevel.rubyCount, forKey: GameLevel.Key.rubyCount.rawValue)
        UserDefaults.standard.set(GameLevel.currentLevel, forKey: GameLevel.Key.currentLevel.rawValue)
        UserDefaults.standard.set(GameLevel.currentGameState, forKey: GameLevel.Key.currentGameState.rawValue)
        UserDefaults.standard.set(GameLevel.comments, forKey: GameLevel.Key.comments.rawValue)
        UserDefaults.standard.set(GameLevel.tileContents, forKey: GameLevel.Key.tileContents.rawValue)
        UserDefaults.standard.set(GameLevel.correctTiles, forKey: GameLevel.Key.correctTiles.rawValue)
        UserDefaults.standard.set(GameLevel.incorrectTiles, forKey: GameLevel.Key.incorrectTiles.rawValue)
        UserDefaults.standard.set(GameLevel.answer, forKey: GameLevel.Key.answer.rawValue)
        UserDefaults.standard.set(GameLevel.removeCount, forKey: GameLevel.Key.removeCount.rawValue)
        UserDefaults.standard.set(GameLevel.tileInPlay, forKey: GameLevel.Key.tileInPlay.rawValue)
        UserDefaults.standard.set(GameLevel.tileAnswerPositions, forKey: GameLevel.Key.tileAnswerPositions.rawValue)
        UserDefaults.standard.set(GameLevel.existingAnswerTiles, forKey: GameLevel.Key.existingAnswerTiles.rawValue)
        UserDefaults.standard.set(GameLevel.solutionGuess, forKey: GameLevel.Key.solutionGuess.rawValue)
        UserDefaults.standard.set(GameLevel.answerTileExists, forKey: GameLevel.Key.answerTileExists.rawValue)
        UserDefaults.standard.set(GameLevel.answerCount, forKey: GameLevel.Key.answerCount.rawValue)
        UserDefaults.standard.set(GameLevel.tileRemoved, forKey: GameLevel.Key.tileRemoved.rawValue)
        UserDefaults.standard.set(GameLevel.tileRevealed, forKey: GameLevel.Key.tileRevealed.rawValue)
    }
    
    // LOAD ACTIVE GAME CONTEXT
    func loadActiveGameContext() {
        if let rubyCountCheck = UserDefaults.standard.object(forKey: GameLevel.Key.rubyCount.rawValue),
            let tileAnswerPositionsCheck = UserDefaults.standard.object(forKey: GameLevel.Key.tileAnswerPositions.rawValue),
            let tilesExistCheck = UserDefaults.standard.object(forKey: GameLevel.Key.tilesExist.rawValue),
            let currentLevelCheck = UserDefaults.standard.object(forKey: GameLevel.Key.currentLevel.rawValue),
            let currentGameStateCheck = UserDefaults.standard.object(forKey: GameLevel.Key.currentGameState.rawValue),
            let commentsCheck = UserDefaults.standard.object(forKey: GameLevel.Key.comments.rawValue),
            let tileContentsCheck = UserDefaults.standard.object(forKey: GameLevel.Key.tileContents.rawValue),
            let correctTilesCheck = UserDefaults.standard.object(forKey: GameLevel.Key.correctTiles.rawValue),
            let incorrectTilesCheck = UserDefaults.standard.object(forKey: GameLevel.Key.incorrectTiles.rawValue),
            let answerCheck = UserDefaults.standard.object(forKey: GameLevel.Key.answer.rawValue),
            let removeCountCheck = UserDefaults.standard.object(forKey: GameLevel.Key.removeCount.rawValue),
            let tileInPlayCheck = UserDefaults.standard.object(forKey: GameLevel.Key.tileInPlay.rawValue),
            let existingAnswerTilesCheck = UserDefaults.standard.object(forKey: GameLevel.Key.existingAnswerTiles.rawValue),
            let solutionGuessCheck = UserDefaults.standard.object(forKey: GameLevel.Key.solutionGuess.rawValue),
            let answerTileExistsCheck = UserDefaults.standard.object(forKey: GameLevel.Key.answerTileExists.rawValue),
            let answerCountCheck = UserDefaults.standard.object(forKey: GameLevel.Key.answerCount.rawValue),
            let tileRemovedCheck = UserDefaults.standard.object(forKey: GameLevel.Key.tileRemoved.rawValue),
            let tileRevealedCheck = UserDefaults.standard.object(forKey: GameLevel.Key.tileRevealed.rawValue)
        {
            GameLevel.tileAnswerPositions = tileAnswerPositionsCheck as! [Int]
            GameLevel.rubyCount = rubyCountCheck as! Int
            GameLevel.tilesExist = tilesExistCheck as! Bool
            GameLevel.currentLevel = currentLevelCheck as! Int
            GameLevel.currentGameState = currentGameStateCheck as! String
            GameLevel.comments = commentsCheck as! [String]
            GameLevel.tileContents = tileContentsCheck as! [String]
            GameLevel.correctTiles = correctTilesCheck as! [String]
            GameLevel.incorrectTiles = incorrectTilesCheck as! [String]
            GameLevel.answer = answerCheck as! String
            GameLevel.removeCount = removeCountCheck as! Int
            GameLevel.tileInPlay = tileInPlayCheck as! [Bool]
            GameLevel.existingAnswerTiles = existingAnswerTilesCheck as! Int
            GameLevel.solutionGuess = solutionGuessCheck as! [String]
            GameLevel.answerTileExists = answerTileExistsCheck as! [Bool]
            GameLevel.answerCount = answerCountCheck as! Int
            GameLevel.tileRemoved = tileRemovedCheck as! [Int]
            GameLevel.tileRevealed = tileRevealedCheck as! [Int]
        }
    }
}
