//
//  UserDefaultsHelper.swift
//  Random Ruby
//
//  Created by Levi on 9/22/17.
//  Copyright © 2017 App Volks. All rights reserved.
//

// NOTE: Use this to save data to UD and to get data from randomRubyJsonData.  Call these functions in GamePlayViewController.  Possibly reference the GameLevelStruct for simplicity.

import Foundation
import UIKit

class UserDefaultsHelper {
    
    // SETUP LEVEL CONTENT
    func setNextLevelContent() {
        
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
                        // GET COMMENTS
                        for i in 1...3 {
                            let comment = "comment" + String(i)
                            if let commentContent = levelData[comment] as? String {
                                GameLevel.comments.append(commentContent)
                            }
                        }
                        // TILE CONTENTS
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
                        }
                        GameLevel.tileContents.shuffle()
                        GameLevel.incorrectTiles.shuffle()
                    }
                } catch {
                    // handle error
                }
            }
        }
    }
    
    // SAVE ACTIVE GAME CONTEXT
    func saveActiveGameContext() {
        var gameDataDictionary = [String: Any]()
        gameDataDictionary[GameLevel.Key.rubyCount.rawValue] = GameLevel.rubyCount
        gameDataDictionary[GameLevel.Key.currentLevel.rawValue] = GameLevel.currentLevel
        gameDataDictionary[GameLevel.Key.currentGameState.rawValue] = GameLevel.currentGameState
        gameDataDictionary[GameLevel.Key.comments.rawValue] = GameLevel.comments
        gameDataDictionary[GameLevel.Key.tileButtons.rawValue] = GameLevel.tileButtons
        gameDataDictionary[GameLevel.Key.tileContents.rawValue] = GameLevel.tileContents
        gameDataDictionary[GameLevel.Key.correctTiles.rawValue] = GameLevel.correctTiles
        gameDataDictionary[GameLevel.Key.incorrectTiles.rawValue] = GameLevel.incorrectTiles
        gameDataDictionary[GameLevel.Key.answer.rawValue] = GameLevel.answer
        gameDataDictionary[GameLevel.Key.rubyCount.rawValue] = GameLevel.rubyCount
        gameDataDictionary[GameLevel.Key.removeCount.rawValue] = GameLevel.removeCount
        gameDataDictionary[GameLevel.Key.tileInPlay.rawValue] = GameLevel.tileInPlay
        gameDataDictionary[GameLevel.Key.tileOriginPositions.rawValue] = GameLevel.tileOriginPositions
        gameDataDictionary[GameLevel.Key.tileAnswerPositions.rawValue] = GameLevel.tileAnswerPositions
        gameDataDictionary[GameLevel.Key.existingAnswerTiles.rawValue] = GameLevel.existingAnswerTiles
        gameDataDictionary[GameLevel.Key.solutionGuess.rawValue] = GameLevel.solutionGuess
        gameDataDictionary[GameLevel.Key.answerPositions.rawValue] = GameLevel.answerPositions
        gameDataDictionary[GameLevel.Key.answerTileExists.rawValue] = GameLevel.answerTileExists
        gameDataDictionary[GameLevel.Key.answerCount.rawValue] = GameLevel.answerCount
        
        let gameData : NSData = NSKeyedArchiver.archivedData(withRootObject: gameDataDictionary) as NSData
        do {
            let backToGameDictionary = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(gameData) as! NSDictionary
            print(backToGameDictionary)
        }catch{
            print("Unable to successfully convert NSData to NSDictionary")
        }
        
//        let userDefaults = UserDefaults.standard
//        print("below this line is where it went wrong")
//        let data = NSKeyedArchiver.archivedData(withRootObject: userDefaults)
//        userDefaults.set(data, forKey: "gameDataDictionary")
//
//        userDefaults.set(gameDataDictionary, forKey: "gameDataDictionary")
//        print("worked")
        
//        let defaults = UserDefaults.standard
//        defaults.set(gameDataDictionary, forKey: "gameDataDictionary")
//        defaults.set(GameLevel.rubyCount, forKey: GameLevel.Key.rubyCount.rawValue)
//        defaults.set(GameLevel.currentLevel, forKey: GameLevel.Key.currentLevel.rawValue)
//        defaults.set(GameLevel.currentGameState, forKey: GameLevel.Key.currentGameState.rawValue)
//        defaults.set(GameLevel.comments, forKey: GameLevel.Key.comments.rawValue)
//        defaults.set(GameLevel.tileButtons, forKey: GameLevel.Key.tileButtons.rawValue)
//        defaults.set(GameLevel.tileContents, forKey: GameLevel.Key.tileContents.rawValue)
//        defaults.set(GameLevel.correctTiles, forKey: GameLevel.Key.correctTiles.rawValue)
//        defaults.set(GameLevel.incorrectTiles, forKey: GameLevel.Key.incorrectTiles.rawValue)
//        defaults.set(GameLevel.answer, forKey: GameLevel.Key.answer.rawValue)
//        defaults.set(GameLevel.removeCount, forKey: GameLevel.Key.removeCount.rawValue)
//        defaults.set(GameLevel.tileInPlay, forKey: GameLevel.Key.tileInPlay.rawValue)
//        defaults.set(GameLevel.tileOriginPositions, forKey: GameLevel.Key.tileOriginPositions.rawValue)
//        defaults.set(GameLevel.tileAnswerPositions, forKey: GameLevel.Key.tileAnswerPositions.rawValue)
//        defaults.set(GameLevel.existingAnswerTiles, forKey: GameLevel.Key.existingAnswerTiles.rawValue)
//        defaults.set(GameLevel.solutionGuess, forKey: GameLevel.Key.solutionGuess.rawValue)
//        defaults.set(GameLevel.answerPositions, forKey: GameLevel.Key.answerPositions.rawValue)
//        defaults.set(GameLevel.answerTileExists, forKey: GameLevel.Key.answerTileExists.rawValue)
//        defaults.set(GameLevel.answerCount, forKey: GameLevel.Key.answerCount.rawValue)
        
//        if GameLevel.currentGameState == GameLevel.GameState.finishedLevel {
//            
//        } else if GameLevel.currentGameState == GameLevel.GameState.activeLevel {
//            
//        } else if GameLevel.currentGameState == GameLevel.GameState.firstLevel {
//            
//        }
//        userDefaults.synchronize()
    }
    
    // LOAD ACTIVE GAME CONTEXT
    func loadActiveGameContext() {
        
        let defaults = UserDefaults.standard
        
        if let dataObjects = defaults.object(forKey: "gameDataDictionary") as? NSData {
            if let unarchivedObject = NSKeyedUnarchiver.unarchiveObject(with: dataObjects as Data) {
                print("This is unarchivedObject: \(unarchivedObject)")
                
                print("Below is the data from the for loop")
                for (key, value) in UserDefaults.standard.dictionaryRepresentation() {
                print("\(key) = \(value) \n")
                }
            }
        }
        
            
        
//        if let decoded  = UserDefaults.standard.object(forKey: "gameDataDictionary") as? Data {
//            if (NSKeyedUnarchiver.unarchiveObject(with: decoded) as? NSDictionary) != nil {
//                for (key, value) in UserDefaults.standard.dictionaryRepresentation() {
//                    print("\(key) = \(value) \n")
//                }
////                print(decodedDictionary[GameLevel.Key.answerCount] as! Int)
////                print(decodedDictionary[GameLevel.Key.answer] as! String)
//            }
        
        
//
//        if let dataDictionaryCheck = defaults.object(forKey: "gameDataDictionary") as? NSDictionary {
//            print(dataDictionaryCheck[GameLevel.Key.answerCount] as! Int)
//            print(dataDictionaryCheck[GameLevel.Key.answer] as! String)
//        }
//        if let rubyCountCheck = defaults.object(forKey: GameLevel.Key.rubyCount.rawValue),
//            let currentLevelCheck = defaults.object(forKey: GameLevel.Key.currentLevel.rawValue),
//            let currentGameStateCheck = defaults.object(forKey: GameLevel.Key.currentGameState.rawValue),
//            let commentsCheck = defaults.object(forKey: GameLevel.Key.comments.rawValue),
//            let tileButtonsCheck = defaults.object(forKey: GameLevel.Key.tileButtons.rawValue),
//            let tileContentsCheck = defaults.object(forKey: GameLevel.Key.tileContents.rawValue),
//            let correctTilesCheck = defaults.object(forKey: GameLevel.Key.correctTiles.rawValue),
//            let incorrectTilesCheck = defaults.object(forKey: GameLevel.Key.incorrectTiles.rawValue),
//            let answerCheck = defaults.object(forKey: GameLevel.Key.answer.rawValue),
//            let removeCountCheck = defaults.object(forKey: GameLevel.Key.removeCount.rawValue),
//            let tileInPlayCheck = defaults.object(forKey: GameLevel.Key.tileInPlay.rawValue),
//            let tileOriginalPositionsCheck = defaults.object(forKey: GameLevel.Key.tileOriginPositions.rawValue),
//            let tileAnswerPositionsCheck = defaults.object(forKey: GameLevel.Key.tileAnswerPositions.rawValue),
//            let existingAnswerTilesCheck = defaults.object(forKey: GameLevel.Key.existingAnswerTiles.rawValue),
//            let solutionGuessCheck = defaults.object(forKey: GameLevel.Key.solutionGuess.rawValue),
//            let answerPositionsCheck = defaults.object(forKey: GameLevel.Key.answerPositions.rawValue),
//            let answerTileExistsCheck = defaults.object(forKey: GameLevel.Key.answerTileExists.rawValue),
//            let answerCountCheck = defaults.object(forKey: GameLevel.Key.answerCount.rawValue)
//        {
//            GameLevel.rubyCount = rubyCountCheck as! Int
//            GameLevel.currentLevel = currentLevelCheck as! Int
//            GameLevel.currentGameState = currentGameStateCheck as! GameLevel.GameState
//            GameLevel.comments = commentsCheck as! [String]
//            GameLevel.tileButtons = tileButtonsCheck as! [UIButton]
//            GameLevel.tileContents = tileContentsCheck as! [String]
//            GameLevel.correctTiles = correctTilesCheck as! [String]
//            GameLevel.incorrectTiles = incorrectTilesCheck as! [String]
//            GameLevel.answer = answerCheck as! String
//            GameLevel.removeCount = removeCountCheck as! Int
//            GameLevel.tileInPlay = tileInPlayCheck as! [Bool]
//            GameLevel.tileOriginPositions = tileOriginalPositionsCheck as! [CGPoint]
//            GameLevel.tileAnswerPositions = tileAnswerPositionsCheck as! [Int]
//            GameLevel.existingAnswerTiles = existingAnswerTilesCheck as! Int
//            GameLevel.solutionGuess = solutionGuessCheck as! [String]
//            GameLevel.answerPositions = answerPositionsCheck as! [CGPoint]
//            GameLevel.answerTileExists = answerTileExistsCheck as! [Bool]
//            GameLevel.answerCount = answerCountCheck as! Int
//            
//            print("Ruby Count: \(GameLevel.rubyCount)")
//            print("currentLevel: \(GameLevel.currentLevel)")
//            print("currentGameState: \(GameLevel.currentGameState)")
//            print("comments: \(GameLevel.comments)")
//            print("tileContents: \(GameLevel.tileContents)")
//            print("correctTiles: \(GameLevel.correctTiles)")
//            print("incorrectTiles: \(GameLevel.incorrectTiles)")
//            print("answer: \(GameLevel.answer)")
//            print("removeCount: \(GameLevel.removeCount)")
//            print("tileInPlay: \(GameLevel.tileInPlay)")
//            print("tileOriginPositions: \(GameLevel.tileOriginPositions)")
//            print("tileAnswerPositions: \(GameLevel.tileAnswerPositions)")
//            print("existingAnswerTiles: \(GameLevel.existingAnswerTiles)")
//            print("solutionGuess: \(GameLevel.solutionGuess)")
//            print("answerPositions: \(GameLevel.answerPositions)")
//            print("answerTileExists: \(GameLevel.answerTileExists)")
//            print("answerCount: \(GameLevel.answerCount)")
//        }
//    }
    }
    
    func save(dictionary: [Int: Bool], forKey key: String) {
        let archiver = NSKeyedArchiver.archivedData(withRootObject: dictionary)
        UserDefaults.standard.set(archiver, forKey: key)
    }
}
