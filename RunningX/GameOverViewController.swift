//
//  GameOverViewController.swift
//  RunningX
//
//  Created by Anderson Sprenger on 30/09/21.
//

import UIKit

class GameOverViewController: UIViewController {
    @IBOutlet weak var dimView: UIView!
    
    private var oldGameScore = HighScoreRepository.getHighScore()
    var score: Int = 0
    
    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var goHomeButton: UIButton!
    
    // segues identifiers
    let menuSegueID = "gameover-menu-segue"
    let restartSegueID = "gameover-restart-segue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dimView.alpha = 0.6
        
        scoreLabel.text = String(score)
        
        //goGameButton.layer.cornerRadius = 18
        goHomeButton?.layer.cornerRadius = 18

        if score > oldGameScore {
            HighScoreRepository.updateHighScore(to: score)
            recordLabel.isHidden = false
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}
