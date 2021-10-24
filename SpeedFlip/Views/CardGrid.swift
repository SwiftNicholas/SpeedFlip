//
//  StackViewGrid.swift
//  MemoryGame
//
//  Created by Nicholas Verrico on 2/13/17.
//  Copyright © 2017 Nicholas Verrico. All rights reserved.
//

import Foundation
import UIKit
import GameplayKit

// MARK: New game function stack order
/*
    populateEmptyGrid -> Update grid images -> Tap Gesture Config
 */

// MARK: Grid setup and init
class Grid: UIStackView {

    var delegate: PlayScreen!

    func populateEmptyGrid(height: Int, width: Int)->[Card]{
       
        // Holds empty card image views
        var imageViews = [Card]()
        
        func clearExistingView(){
            // Clears current view stack skeleton
            for card in self.arrangedSubviews{
                card.removeFromSuperview()
            }
        }; clearExistingView()
        
        // Configures master StackView to hold row
        for _ in (0..<height){
            
            // Creats new ROW
            let newRow = UIStackView()
            // configures ROW settings
            newRow.axis = .horizontal
            newRow.distribution = .fillEqually
            newRow.spacing = 8
            // Inserts ROW into master
            self.insertArrangedSubview(newRow as UIView, at: (self.arrangedSubviews.count))
           
            // Populates row with empty cards
            for _ in 0..<width{
                
                // Creates new card imageview
                let imageView = Card()
                imageView.contentMode = .scaleAspectFit
                // Inserts image view into ROW Stack
                newRow.insertArrangedSubview(imageView as UIView, at: (newRow.arrangedSubviews.count))
                // Pass reference to array
                imageViews.append(imageView)
            }
        }
        // Returns array for ViewController collectionView
        return imageViews
    }
    
    func updateGridImages(numberOfTiles:Int, cards:[Card]) -> [Card]{
        
        // array of numbers generated for constructing custom image views
        var newImageIDNumbers = [Int]()
        // Creates random number distribution between 0 and # of images in assets catalog.
        let shuffleDistro = GKShuffledDistribution(lowestValue: 0, highestValue: 149)
        for _ in 0..<(numberOfTiles/2){
            // Generates random number from distributed range
            let randomID = shuffleDistro.nextInt()
            // Adds random number to new image numbers array twice to account for every image having a match
            newImageIDNumbers.append(randomID)
            newImageIDNumbers.append(randomID)
        }
        
        // Generates new random generator source
        let randomNumberSource = GKRandomSource()
        // Shuffles image numbers using random source
        newImageIDNumbers = randomNumberSource.arrayByShufflingObjects(in: newImageIDNumbers) as! [Int]
        
        
        for (offset,element) in cards.enumerated(){
            
            element.faceUpImage = UIImage(named:"img_\(newImageIDNumbers[offset])")
            element.faceValueID = newImageIDNumbers[offset]
        }
        return cards
    }
        
    func tapGestureConfig(gridViewController:PlayScreen, cards:[Card]) -> [Card]
    {
        for card in cards {
            let singleTapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: gridViewController, action: #selector(gridViewController.tapped(sender:)))
            
            singleTapGesture.delegate = gridViewController as UIGestureRecognizerDelegate?
            card.addGestureRecognizer(singleTapGesture)
            card.contentMode = .scaleAspectFit
            card.image = card.cardBack
            card.isUserInteractionEnabled = true
        }
        
        return cards
    }
    
    func createNewGrid(height:Int, width:Int){
    
        
        // Creates empty grid stack view
        let grid = self.populateEmptyGrid(height: height, width: width)
        let tiles = height*width
        
        // Fills grid stack view with images
        let populatedGrid = self.updateGridImages(numberOfTiles: tiles, cards: grid)
        
        // Attaches gestures to views
        delegate.cardViewOutletCollection = self.tapGestureConfig(gridViewController: self.delegate, cards: populatedGrid)
    
    }

    init(height:Int, width:Int, delegate: PlayScreen){
        
        // MARK: Grid Check - Move to Settings (do not allow uneven number grids
        // Tests tiles for even number of matches
        let tiles = height*width
        if tiles % 2 != 0 {assertionFailure("Grid count not even number")}

        // assigns grid view delegate
        self.delegate = delegate
        
        // Initializes Stack View superclass
         super.init(frame: CGRect())
        
        // Configures stack view
        self.autoresizesSubviews = true
        self.distribution = .fillEqually
        self.axis = .vertical
       
        createNewGrid(height: height, width: width)
        
    }

    // Require call for stack view super
    required init(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
}



// MARK: Grid actions extension
extension Grid{
    
    // 'locks' grid by disabling subview interaction
    func lockGrid(){
        
        for stack in self.arrangedSubviews {
            let row = stack as! UIStackView
            for view in row.arrangedSubviews{
                view.isUserInteractionEnabled = false
            }
        }
    }
    
    // 'unlocks' grid by disabling subview interaction
    func unlockGrid(){
        for stack in self.arrangedSubviews {
            let row = stack as! UIStackView
            for view in row.arrangedSubviews{
                view.isUserInteractionEnabled = true
            }
        }
    }
}

    
