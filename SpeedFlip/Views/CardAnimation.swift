//
//  AnimationExtension.swift
//  MemoryGame
//
//  Created by Nicholas Verrico on 2/13/17.
//  Copyright © 2017 Nicholas Verrico. All rights reserved.
//

import Foundation
import UIKit
import GameplayKit

extension Array where Element : Card {

    func animate(delay:Double = 0, duration: Double = 0.25, flipFaceUp: Bool, completion: @escaping () -> Void){
        
        AudioManager.shared.playSoundEffect(type: .Flip)
        //Allows animations to be given delay for preview purposes
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            
            // Opens transaction and sets Core Animation configuration
            CATransaction.begin()
            // Set animation duration
            CATransaction.setAnimationDuration(duration)
            
            let transition = CATransition()
            transition.type = CATransitionType.push
            transition.subtype = CATransitionSubtype.fromRight
            
            // Iterates over images in array based on flipFaceUp paramater
            
            if flipFaceUp {
                for card in self{
                    card.layer.add(transition, forKey: kCATransition)
                    card.image = card.faceUpImage
                    card.faceDown = false
                }
            }
            else {
                for card in self{
                    card.layer.add(transition, forKey: kCATransition)
                    card.image = card.cardBack
                    card.faceDown = true
                }
            }
            // Batch commits all transactions from iterations
            // Flips all cards over at one time
            CATransaction.commit()
            
            // required completion call
            completion()
        }
    }
}
