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
        UserDefaults.standard.set(GameLevel.rubyCount, forKey: GameLevel.Key.rubyCount.rawValue)
        print("rubyCount Saved")
        UserDefaults.standard.set(GameLevel.currentLevel, forKey: GameLevel.Key.currentLevel.rawValue)
        print("currentLevel Saved")
        UserDefaults.standard.set(GameLevel.currentGameState, forKey: GameLevel.Key.currentGameState.rawValue)
        print("currentGameState Saved")
        print(GameLevel.currentGameState)
        UserDefaults.standard.set(GameLevel.comments, forKey: GameLevel.Key.comments.rawValue)
        print("comments Saved")
        UserDefaults.standard.set(GameLevel.tileButtons, forKey: GameLevel.Key.tileButtons.rawValue)
        print("tileButtons Saved")
        UserDefaults.standard.set(GameLevel.tileContents, forKey: GameLevel.Key.tileContents.rawValue)
        print("tileContents Saved")
        UserDefaults.standard.set(GameLevel.correctTiles, forKey: GameLevel.Key.correctTiles.rawValue)
        print("correctTilesSaved")
        UserDefaults.standard.set(GameLevel.incorrectTiles, forKey: GameLevel.Key.incorrectTiles.rawValue)
        print("incorrectTiles Saved")
        UserDefaults.standard.set(GameLevel.answer, forKey: GameLevel.Key.answer.rawValue)
        print("answer Saved")
        UserDefaults.standard.set(GameLevel.removeCount, forKey: GameLevel.Key.removeCount.rawValue)
        print("removeCount Saved")
        UserDefaults.standard.set(GameLevel.tileInPlay, forKey: GameLevel.Key.tileInPlay.rawValue)
        print("tileInPlay Saved")
        UserDefaults.standard.set(GameLevel.tileAnswerPositions, forKey: GameLevel.Key.tileAnswerPositions.rawValue)
        print("tileAnswerPositions Saved")
        UserDefaults.standard.set(GameLevel.existingAnswerTiles, forKey: GameLevel.Key.existingAnswerTiles.rawValue)
        print("tileInPlay Saved")
        UserDefaults.standard.set(GameLevel.solutionGuess, forKey: GameLevel.Key.solutionGuess.rawValue)
        print("solutionGuess Saved")
        UserDefaults.standard.set(GameLevel.answerTileExists, forKey: GameLevel.Key.answerTileExists.rawValue)
        print("answerTileExists Saved")
        UserDefaults.standard.set(GameLevel.answerCount, forKey: GameLevel.Key.answerCount.rawValue)
        print("answerCount Saved")
        var stringOfCGPointArray = [String]()
        for tileOriginalPosition in GameLevel.tileOriginPositions {
            let stringOfCGPoint = NSStringFromCGPoint(tileOriginalPosition)
            stringOfCGPointArray.append(stringOfCGPoint)
        }
        UserDefaults.standard.set(stringOfCGPointArray, forKey: GameLevel.Key.tileOriginPositions.rawValue)
        var stringOfCGPointArray2 = [String]()
        for answerPosition in GameLevel.answerPositions {
            let stringOfCGPoint = NSStringFromCGPoint(answerPosition)
            stringOfCGPointArray2.append(stringOfCGPoint)
        }
        UserDefaults.standard.set(stringOfCGPointArray2, forKey: GameLevel.Key.answerPositions.rawValue)
        
//        let gameData : NSData = NSKeyedArchiver.archivedData(withRootObject: gameDataDictionary) as NSData
//        do {
//            let backToGameDictionary = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(gameData) as! NSDictionary
//            print(backToGameDictionary)
//        }catch{
//            print("Unable to successfully convert NSData to NSDictionary")
//        }
        
//        let userDefaults = UserDefaults.standard
//        print("below this line is where it went wrong")
//        let data = NSKeyedArchiver.archivedData(withRootObject: userDefaults)
//        userDefaults.set(data, forKey: "gameDataDictionary")
//
//        userDefaults.set(gameDataDictionary, forKey: "gameDataDictionary")
//        print("worked")
        
        
        
//        if GameLevel.currentGameState == GameLevel.GameState.finishedLevel {
//            
//        } else if GameLevel.currentGameState == GameLevel.GameState.activeLevel {
//            
//        } else if GameLevel.currentGameState == GameLevel.GameState.firstLevel {
//            
//        }
    }
    
    // LOAD ACTIVE GAME CONTEXT
    func loadActiveGameContext() {
        if let tileOriginalPointData = UserDefaults.standard.object(forKey: GameLevel.Key.tileOriginPositions.rawValue) as? NSArray {
            var i = 0
            for tileOriginalPoint in tileOriginalPointData {
                let point = CGPointFromString(tileOriginalPoint as! String)
                GameLevel.tileOriginPositions[i] = point
                i += 1
            }
        }
        if let answerPositions = UserDefaults.standard.object(forKey: GameLevel.Key.answerPositions.rawValue) as? NSArray {
            var i = 0
            for answerPosition in answerPositions {
                let point = CGPointFromString(answerPosition as! String)
                GameLevel.answerPositions[i] = point
                i += 1
            }
        }
        if let rubyCountCheck = UserDefaults.standard.object(forKey: GameLevel.Key.rubyCount.rawValue),
            let currentLevelCheck = UserDefaults.standard.object(forKey: GameLevel.Key.currentLevel.rawValue),
            let currentGameStateCheck = UserDefaults.standard.object(forKey: GameLevel.Key.currentGameState.rawValue),
            let commentsCheck = UserDefaults.standard.object(forKey: GameLevel.Key.comments.rawValue),
            let tileButtonsCheck = UserDefaults.standard.object(forKey: GameLevel.Key.tileButtons.rawValue),
            let tileContentsCheck = UserDefaults.standard.object(forKey: GameLevel.Key.tileContents.rawValue),
            let correctTilesCheck = UserDefaults.standard.object(forKey: GameLevel.Key.correctTiles.rawValue),
            let incorrectTilesCheck = UserDefaults.standard.object(forKey: GameLevel.Key.incorrectTiles.rawValue),
            let answerCheck = UserDefaults.standard.object(forKey: GameLevel.Key.answer.rawValue),
            let removeCountCheck = UserDefaults.standard.object(forKey: GameLevel.Key.removeCount.rawValue),
            let tileInPlayCheck = UserDefaults.standard.object(forKey: GameLevel.Key.tileInPlay.rawValue),
            let existingAnswerTilesCheck = UserDefaults.standard.object(forKey: GameLevel.Key.existingAnswerTiles.rawValue),
            let solutionGuessCheck = UserDefaults.standard.object(forKey: GameLevel.Key.solutionGuess.rawValue),
            let answerTileExistsCheck = UserDefaults.standard.object(forKey: GameLevel.Key.answerTileExists.rawValue),
            let answerCountCheck = UserDefaults.standard.object(forKey: GameLevel.Key.answerCount.rawValue)
        {
            GameLevel.rubyCount = rubyCountCheck as! Int
            GameLevel.currentLevel = currentLevelCheck as! Int
            GameLevel.currentGameState = currentGameStateCheck as! String
            GameLevel.comments = commentsCheck as! [String]
            GameLevel.tileButtons = tileButtonsCheck as! [UIButton]
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
            print("tileOriginPositions: \(GameLevel.tileOriginPositions)")
            print("tileAnswerPositions: \(GameLevel.tileAnswerPositions)")
            print("existingAnswerTiles: \(GameLevel.existingAnswerTiles)")
            print("solutionGuess: \(GameLevel.solutionGuess)")
            print("answerPositions: \(GameLevel.answerPositions)")
            print("answerTileExists: \(GameLevel.answerTileExists)")
            print("answerCount: \(GameLevel.answerCount)")
        }
    }
}
