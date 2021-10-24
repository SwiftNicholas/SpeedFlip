//
//  Card.swift
//  MemoryGame
//
//  Created by Nicholas Verrico on 2/13/17.
//  Copyright © 2017 Nicholas Verrico. All rights reserved.
//

import Foundation
import UIKit

class Card: UIImageView{
    
    // MARK: Card traits
    
    var cardBackName:String = "-laughingSmiley"
    
    // ID for comparison
    var faceValueID: Int = 0
    var faceUpImage: UIImage? = nil
    
    // Default card state
    var faceDown: Bool = true
    var cardBack: UIImage = UIImage(named:"-laughingSmiley")!
    
    
    
    // MARK: Required
    
    
    // Required UIImageView super init
    init() {
        super.init(image: nil)
    }
    
    required init(coder aDecoder: NSCoder) { super.init(coder: aDecoder)! }
}
