//
//  ScoreViewController.swift
//  MemoryGame
//
//  Created by Nicholas Verrico on 2/23/17.
//  Copyright © 2017 Nicholas Verrico. All rights reserved.
//
import Foundation
import UIKit
import CoreData

class ScoreViewController: UIViewController {

    // Displays scores dynamically in stack views using the score array, [UIStackView] outlet and a label outlet containing all labels on screen.
    
    
    var scores = [Score]()
    var dataAccess = CoreData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scores = dataAccess.retrieveAllForEntityType(entityType: Score.self, context: nil, returnFetchWithFaults: false, errorHandler: nil)!
        
        populateScores()
        // Do any additional setup after loading the view.
    }

    @IBOutlet var scoreRowsCollection: [UIStackView]!

    @IBOutlet var labelCollection: [UILabel]!
   
    
    func populateScores(){
    
        // Sorts scores based on minutes first, then sorts within each minute based on seconds
        
        var sortedScores = scores.sorted { (Score1, Score2) -> Bool in
           
           Score1.timeMinutes < Score2.timeMinutes
           
        }
        // Sorts scores based on seconds
        
        sortedScores.sort(by:  { (Score1, Score2) -> Bool in
            
            Score1.timeMinutes <= Score2.timeMinutes && Score1.timeSeconds < Score2.timeSeconds
            
        })
        
       
        for (row, stackView) in scoreRowsCollection.enumerated(){
        // No scores present
            if sortedScores.isEmpty == true{return}
            // ensures enough scores to fill rows
           if sortedScores.count-1 >= row{
            // calls score object from array
            let currentScore = sortedScores[row]
            // creates the current label array index since each object/row has 4 items
            let rowMultiplier = row*4
            // Sets initials
            let initialsLabel = labelCollection[rowMultiplier]
                initialsLabel.text = currentScore.initials
                // Sets scores
            let scoreLabel = labelCollection[rowMultiplier+1]
            // creates formatted date from NSDate object in core data
            let formattedDate = DateFormatter.localizedString(from: currentScore.date! as Date, dateStyle: .short, timeStyle: .none)
      
            // assigns shorthand date to label
            scoreLabel.text = formattedDate
            
            // sets turns label
            let turnsLabel = labelCollection[rowMultiplier+2]
            turnsLabel.text = String(currentScore.turns)
            
            // sets time label
            let timeLabel = labelCollection[rowMultiplier+3]
            var timeSeconds = String(currentScore.timeSeconds)
            if currentScore.timeSeconds < 10 {
                timeSeconds = "0\(currentScore.timeSeconds)"
                
            }
            
            timeLabel.text = "\(currentScore.timeMinutes):\(timeSeconds)"
            
            for label in stackView.subviews{
             // labels are hidden by default
                label.isHidden = false
                
                }
            // Ensures proper stackView updates
            stackView.layoutSubviews()
            
            }
            
            
        }
        
    }
}




