//
//  GameInfo.swift
//  MemoryGame
//
//  Created by Nicholas Verrico on 2/16/17.
//  Copyright © 2017 Nicholas Verrico. All rights reserved.
//

import Foundation

class currentGame{

    var activeCard:Card? = nil
    var numberOfMatches = 0
    var previousScore:String = ""
    var roundStarting = false
    var grid: Grid? = nil
    var height: Int = 8
    var width: Int = 4
    var turns: Int = 0
    var mute = false

    
    init(){
        numberOfMatches = 0
    }
    
    func newGame(viewController: PlayScreen)-> Grid{
        self.turns = 0
    // ##Consider moving to game object class
    // Creates new grid
        self.grid = Grid(height: height, width: width, delegate: viewController)

        self.numberOfMatches = 0
        self.grid?.lockGrid()
        viewController.gridPreview(5)
           
     return self.grid!
    }
    
}


class player {
    var name: String?
    var scores: localScores = localScores()
}

class localScores{}

enum gameModes{

    case regular
    case challenge
    case multiPlayer
}

enum difficulties{
    case hard
    case normal
    case easy
    case extreme
}
