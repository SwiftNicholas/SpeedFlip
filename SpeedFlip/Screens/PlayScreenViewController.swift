//
//  PlayScreen.swift
//  MemoryGame
//
//  Created by Nicholas Verrico on 2/9/17.
//  Copyright © 2017 Nicholas Verrico. All rights reserved.
//


import UIKit
import AVFoundation
import GameplayKit

// Global singleton accessors
var game: currentGame = currentGame()

class PlayScreen: UIViewController, UIGestureRecognizerDelegate {
    // MARK: Class member variables
    // Stores card imageID and imageView for comparision and UI updates
    
    // Placeholders for updating grid layout based on Storyboard auto-layout
    var gridConstraints: [NSLayoutConstraint] = []
    var stackViewFrame: CGRect = CGRect()
    var cardViewOutletCollection: [Card] = []

    
    // MARK: - IBOutlets
    @IBOutlet weak var timerView: TimerView!
  
    // Used to get auto-layout constraints and frame from empty view
    // Discarded in ViewDidAppear
    @IBOutlet var masterStackView: UIStackView?

    // MARK: New game
    
    func startRound(height: Int, width: Int){
        // Ensure only one game can start at a time
        guard !game.roundStarting
            else {
           return
        }
        
         game.roundStarting = true
        
        // Creates and returns custom UIStack view with images
        let newGrid = game.newGame(viewController: self)
        
        // Sets frame and constraints to placholder view in storyboard
        newGrid.frame = self.stackViewFrame
        newGrid.addConstraints(self.gridConstraints)
      
        // Adds subview and moves it to the front of the view stack
        self.view.addSubview(newGrid)
        self.view.bringSubviewToFront(newGrid)
        
        // Calls layout to update stackView containers
        newGrid.layoutSubviews()
    }

    // Displays grid for # of seconds before flipping cards back over
    func gridPreview(_:Int){
        // Displays all images for user to preview before beginning
        self.cardViewOutletCollection.animate(delay: 0, duration: 0.35, flipFaceUp: true, completion: {})
        // After 5 seconds, flips cards over and allows interaction
        self.cardViewOutletCollection.animate(delay: 5, duration: 0.35, flipFaceUp: false, completion: {() in
                self.timerView.resetTimer()
               game.grid?.unlockGrid()
                self.timerView.startTimer()
               game.roundStarting = false
            })
    }
    

    // MARK: - Tap Gesture Setup
    @objc func tapped(sender: UITapGestureRecognizer){
        
    // Checks to make sure the sender is 'Card' Image View
        if let tappedCard = sender.view as? Card{
         // Ignores taps on facedown cards
            if !tappedCard.faceDown {
                return
            } else {
                // Locks all cards while comparing
                // Prevents users from spamming card taps
               game.grid?.lockGrid()
                var comparisonArray = [tappedCard]
                // Flips tapped card face up
                comparisonArray.animate(flipFaceUp: true, completion: {})
                // If card has nothing to compare to then unlocks grid to allow for second tap
                if game.activeCard == nil {
                  game.activeCard = comparisonArray[0]
                   game.grid?.unlockGrid()
                    return
            }else if game.activeCard != nil {
                    
                // If there is already an 'active card'
                // Adds both cards to array for animation purposes
                comparisonArray = [game.activeCard!, tappedCard]
                if comparisonArray[0].faceValueID == comparisonArray[1].faceValueID{
                    
                    // if cards match
                        matched(cards:comparisonArray)
                        return
                } else {
                    // If cards don't match flip them back over, reset the active card and unlock the grid
                    comparisonArray.animate(delay: 0.3, duration: 0.15, flipFaceUp: false, completion: {
                       game.activeCard = nil
                       game.grid?.unlockGrid()
                    })
                }
            }
        }
        }
       game.turns += 1
    }
  
    // MARK: Cards matched
    
    func matched(cards:[Card]){
        // Removes matched cards from view
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
            for card in cards{
                card.image = nil
            }
        }
       game.activeCard = nil
        AudioManager.shared.playSoundEffect(type: .Match)
        
       game.numberOfMatches += 1
        if game.numberOfMatches == (self.cardViewOutletCollection.count/2){
          gameOver()
           return
        }
       game.grid?.unlockGrid()
    }
    
   
    
    // MARK: Game over
    
    func gameOver(){
        
        // local scope for timer
        let timer = self.timerView.stopwatch
        // Stores time
        let time = (timer?.time)!
        // Resets Timer
        timerView.resetTimer()
        // Extracts time for display and score
        let seconds = time.seconds
        let minutes = time.minutes
  
        // locally scoped function, with options to return to main menu or play again
        func createAlert(scoreString:String) -> UIAlertController{
        
            let gameOverAlert = UIAlertController(title: "Congratulations!", message: "You completed all the matches in \(scoreString). Would you like to play again?", preferredStyle: .alert)
            
            let newGameButton = UIAlertAction(title: "New Game", style: .default, handler: {
                (UIAlertAction) in
                
                // Starts new rowund
                self.startRound(height:game.height,width:game.width)
            })
            
            let returnButton = UIAlertAction(title: "Main Menu", style: .default, handler: {
                (UIAlertAction) in
             
             self.performSegue(withIdentifier: "unwindToMenu", sender: self)
                
            })
            gameOverAlert.addAction(returnButton)
            gameOverAlert.addAction(newGameButton)
            
            return gameOverAlert
        }
        
        // string placeholder
        
        var scoreString = ""
        // correctly formats text to display in alert view
        if minutes == 0 {
            scoreString = "\(seconds) Seconds"
        } else {
            scoreString = "\(minutes) Minutes and \(seconds) Seconds"
        }

        // Creates display message for alert view
        
        let scoreAlert = UIAlertController(title: "Save Score", message: "Congratulations. You completed a game please enter your initials ro record your score.", preferredStyle: .alert)
        
        // Adds input textfield to alert view
        
        scoreAlert.addTextField { (text:UITextField) in
            text.placeholder = "Initials"
        }
        
        // Creates second alert to call after initials are entered that displays options for a new game or main menu
        
        let confirmInitials = UIAlertAction(title: "Confirm", style: .default, handler: {
            (UIAlertAction) in
            
            let time: (seconds: Int, minutes:Int) = (seconds: seconds, minutes: minutes)
            
            // Inserts score object into NSData stack on completion of alert menu selection
            
//            let data = CoreData()
//            let score:Score = data.insert(entityName: "Score", entityType: Score.self, context: nil)
//            
//            score.initials = scoreAlert.textFields?[0].text
//            score.date = Date.init() as NSDate? as Date?
//            score.turns = Int16(game.turns)
//            score.timeSeconds = Int16(time.seconds)
//            score.timeMinutes = Int16(time.minutes)
//            
//            data.contextSave(context: nil, errorHandler: nil)
//            
            
            let alert = createAlert(scoreString: scoreString)
            // Presents second alert view
            self.present(alert, animated: true, completion: nil)
            
           
            
        })
        // adds action created above
        scoreAlert.addAction(confirmInitials)
        
        // presents first alert view to input initials
        self.present(scoreAlert, animated: true, completion: nil)
        
        return
    }
    
    // MARK: ViewController overrides
    
    // Flow control note: All game play begins here 
    override func viewDidAppear(_ animated: Bool) {
        // Copies grid constraints from auto-layout shell
        self.gridConstraints = (masterStackView?.constraints)!
       // Copies frame location/size from existing shell
        self.stackViewFrame = (masterStackView?.frame)!
        // Removes shell from view stack
        masterStackView?.removeFromSuperview()
        // Creates game object to hold current game stats
       game = currentGame()
        // Starts new round
        self.startRound(height:game.height,width:game.width)
    }
}



