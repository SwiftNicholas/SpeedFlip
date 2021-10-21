//
//  TimerView.swift
//  MemoryGame
//
//  Created by Nicholas Verrico on 2/11/17.
//  Copyright © 2017 Nicholas Verrico. All rights reserved.
//

import UIKit

class TimerView: UIView, StopwatchDelegate{

    // MARK: Public properties
    
    var stopwatch: Stopwatch? = nil
    var state:State = .reset
    
    enum State {
        
        case paused
        case reset
        case running
    }
    
    
    @IBOutlet weak private var Minutes1: UIImageView!
    @IBOutlet weak private var Minutes0: UIImageView!
    @IBOutlet weak private var Seconds1: UIImageView!
    @IBOutlet weak private var Seconds0: UIImageView!
  
    
    // Tracks time in digits seconds/minutes (0-9) and secondsTensPlace/minutesTensPlace (10+)
    // Used to update the custom clock animation only
    // For correct time use stopwatch.time
    // Variables are made private to prevent access by mistake
    internal func updateTime(){
       //  Checks for rollover in seconds
        self.seconds += 1
        if self.seconds == 10{
            self.updateTensPlaceForSeconds = true
            self.seconds = 0
            self.secondsTensPlace += 1
            // Nested - Only called when rolled over from seconds (every 10th second)
            // Checks for rollover from single digit seconds to double digit seconds
            if self.secondsTensPlace == 6 {
                self.secondsTensPlace = 0
                self.minutes = self.minutes + 1
                self.updateOnesPlaceForMinutes = true
                // Checks for rollover from single digit minutes to double digits
                // Only called every 10th Minute
                if self.minutes >= 10 {
                    self.minutesTensPlace += 1
                    self.minutes = 0
                    self.updateTensPlaceForMinutes = true
                }
            }
        }
        self.animate()
    }
    
    // Used only within timer view to track and update custom timer
    
    private var seconds = 0
    private var secondsTensPlace = 0
    private var minutes = 0
    private var minutesTensPlace = 0
    private var updateTensPlaceForSeconds = false
    private var updateOnesPlaceForMinutes = false
    private var updateTensPlaceForMinutes = false
    
    func resetDigitViews(){
        // Reset Views
        self.Minutes0.image = UIImage(named: "0")
        self.Minutes1.image = UIImage(named: "0")
        self.Seconds1.image = UIImage(named: "0")
        self.Seconds0.image = UIImage(named: "0")
        
    }
    
    private func animate(){
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(0.3)
        let transition = CATransition()
        transition.type = CATransitionType.reveal
        transition.subtype = CATransitionSubtype.fromBottom
        
        // Loops over update bools for timer digits. Only updates digits that have been 'flagged'
        
        if self.updateOnesPlaceForMinutes{
            self.Minutes0.layer.add(transition, forKey: kCATransition)
            self.Minutes0.image = (UIImage(named: "\(self.minutes)"))
        }
        if self.updateTensPlaceForMinutes {
            self.Minutes1.layer.add(transition, forKey: kCATransition)
            self.Minutes1.image = (UIImage(named: "\(self.minutesTensPlace)"))
        }
        if self.updateTensPlaceForSeconds{
            self.Seconds1.layer.add(transition, forKey: kCATransition)
            self.Seconds1.image = (UIImage(named: "\(self.secondsTensPlace)"))
        }
        // Seconds are always updated when called
        self.Seconds0.layer.add(transition, forKey: kCATransition)
        self.Seconds0.image = (UIImage(named: "\(self.seconds)"))
        
        // Closes Core Animation transaction and updates UI
        CATransaction.commit()
        
        // resets update flags
        self.updateTensPlaceForSeconds = false
        self.updateOnesPlaceForMinutes = false
        self.updateTensPlaceForMinutes = false
    }
    
    // MARK: Timerview init
    
    init() {
        super.init(frame: CGRect())
        self.stopwatch = Stopwatch(delegate: self)
    }
    
    // Required init from UIView
    required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder)}

    // MARK: TimerView actions
    
    func startTimer(){
        self.stopwatch?.startTimer()
        self.state = .running
    }
    
    func pauseTimer(){
        self.stopwatch?.stopTimer()
        self.state = .paused
    }
    
    func resetTimer(){
        
        self.stopwatch?.stopTimer()
        self.stopwatch = Stopwatch(delegate: self)
        self.resetDigitViews()
        self.state = .reset
    }
    
    
}


