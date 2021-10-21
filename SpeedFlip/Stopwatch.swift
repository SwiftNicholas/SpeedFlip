//
//  GenericGameTimer.swift
//  SpeedFlip
//
//  Created by Nicholas Verrico on 2/16/17.
//  Copyright © 2017 Nicholas Verrico. All rights reserved.
//
//


import Foundation
import UIKit

protocol StopwatchDelegate {
    func updateTime()
}

class Stopwatch {
   
    init(delegate: StopwatchDelegate){
        self.delegate = delegate
    
    }
    
    var delegate: StopwatchDelegate
    
    // MARK: Class members
    
    // Use as needed to store/access multiple stopwatch/times
    var name:String = ""
    // Times are autoset to 0
    var time = Time()
    
    // Uses default NSTimer
    // MARK: - Timer Accuracy note
    // "Because of the various input sources a typical run loop manages, the effective resolution of the time interval for a timer is limited to on the order of 50-100 milliseconds"
    //  https://developer.apple.com/reference/foundation/timer#1667624
    // Accessed 16 February, 2017
    var timer = Timer()
    
    // MARK: - Stopwatch (increase time)
    
    // Creates and fires NSTimer with a 1 second interval
    // INCREASES Time object seconds by 1
    func startTimer(){
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {
            timer in
            self.time.seconds += 1
            self.delegate.updateTime()
            
        })
        timer.fire()
    }
    
    // MARK: - Timer (decrease time)
    
    // Sets countdown flag in Time object, sets times to start values;
    // Creates and fires NSTimer object;
    // DECREASES Time object seconds by 1 will flag -1 and auto-invalidate when timer expires
    func startCountdown(startingTime: (seconds: Int, minutes: Int, hours: Int, days: Int)){
    
        self.time.seconds = startingTime.seconds
        self.time.minutes = startingTime.minutes
        self.time.hours = startingTime.hours
        self.time.days = startingTime.days
        self.time.countDown = true
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {
            timer in
            if self.time.seconds >= 0{
                self.time.seconds -= 1
            }
            else {
                self.stopTimer()
                return
            }
        })
        timer.fire()
    }
    
    // MARK: - Call to invalidate NSTimer
    
    func stopTimer(){
        
        if timer.isValid{
            timer.invalidate()
        }
    }
}

// MARK: -

/// Simple time object
/**
 Can store or compute at init, seconds, minutes, hours or days based on simple Ints.
 Useful for reading time into and out of NSTimer objects in the correct format.
 */

class Time {
    
    // MARK: Class members
    
    // Automatically adjusts time based on countdown or increased time
    // Seconds value returns flag of -1 if no time remains
     private var _Seconds:Int = 0
     private var _Minutes:Int = 0
     private var _Hours:Int = 0
     private var _Days:Int = 0
   
    // MARK: - Countdown flag
    var countDown:Bool = false
   
    // MARK: - Computed properties
    
    var seconds: Int {
        get {
            
            if countDown {
                // Subtracts from minutes(if possible) and resets seconds
                if self._Seconds == 0 && self._Minutes > 0{
                    self._Minutes -= 1
                    self._Seconds = 59
                }
                // No available minutes sets timer end flag
                else if self._Seconds == 0 && self._Minutes == 0{
                    self._Seconds = -1
                    return self._Seconds
                }
                
                else {
                    // Actual value getter
                    return self._Seconds
                }
            }
            
            // Seconds count up
            if self._Seconds == 60 {
                // Adds one to minutes and resets seconds
                self._Minutes += 1
                self._Seconds = 0
            }
            return self._Seconds
        }
        
        set (seconds){
            self._Seconds = seconds
        }
    }
    
    var minutes: Int {
        get {
            if countDown {
                if self._Minutes == 0 && self._Hours > 0 {
                    self._Hours -= 1
                    self._Minutes = 59
                }
                return self._Minutes
            }
            if self._Minutes == 60 {
                self._Hours += self._Minutes/60
                self._Minutes = 0
            }
            return self._Minutes
        }
        set (minutes){
            self._Minutes = minutes
        }
    }
    
    var hours: Int {
        get {
            if countDown {
                if self._Hours == 0 && self._Days > 0 {
                    self._Days -= 1
                    self._Hours = 23
                }
                return self._Days
            }
            if self._Hours == 24 {
                self._Days += self._Hours/24
                self._Hours = 0
            }
            return self._Hours
        }
        set (hours){
            self._Hours = hours
        }
    }
    
    var days: Int {
        get {
            return self._Days
        }
        set (days){
            self._Days = days
        }
    }
    
    // MARK: - Optional Use Functions
    
    // Can also be accomplished by instantiating new Time object
    func reset(){
        _Seconds = 0
        _Minutes = 0
        _Hours = 0
        _Days = 0
    }
    
    // MARK: - Developer's Note Additional Features
    
    /*
        This is a first attempt to create my own 'framework'/class. More research is needed before adding additional features. See below for details:
     
        May opt to add support for NSDate comparison for longer run timers, days may also be lumped into that.
        Considering pre-fire completion handlers for short run timers to trigger animations or other assets. Allowing access to pass in NSTimer objects would allow for more flexibility with variances and Timer scheduling. In my opinion though timer scheduling should be change to delay in minutes/seconds and 'scheduling' should be handled by NSDate or subclass therein.
     
        May also consider submitting as a built-in Swift component for NSTimer bridging. What good is a timer if the access to times or triggers is inefficient?
     
        MARK: - Needed updates
            - Update getter functions to call single method using an enum? (Individual blocks seemed more straight forward.
            - Added NSNotification trigger to allow for observer method calls.
            - .background() call to send timers to background/allow operation while app is in suspended state
     
     
     
        MARK: - Last updated: 16 February, 2017
     
     // MARK: - Contact Info
        
        email: Nicholas.Verrico@icloud.com
     
    */
}

