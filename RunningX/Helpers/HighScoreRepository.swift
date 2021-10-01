//
//  ScoreHelper.swift
//  RunningX
//
//  Created by Anderson Sprenger on 30/09/21.
//

import Foundation

public class HighScoreRepository {
    private static let defaults = UserDefaults.standard
    private static let highScoreKey = "score"
    
    static func getHighScore() -> Int {
        defaults.integer(forKey: HighScoreRepository.highScoreKey)
    }
    
    static func updateHighScore(to newHighScore: Int) {
        defaults.set(newHighScore, forKey: HighScoreRepository.highScoreKey)
    }
}
