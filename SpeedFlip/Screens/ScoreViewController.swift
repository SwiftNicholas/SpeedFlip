//
//  ScoreViewController.swift
//  MemoryGame
//
//  Created by Nicholas Verrico on 2/23/17.
//  Copyright © 2017 Nicholas Verrico. All rights reserved.
//
import Foundation
import SwiftUI
import CoreData

struct ScoreView: View {
    var scores: [Score]
    
    var body: some View {
        VStack {
      
        ForEach(scores){ score in
            ScoreCell(username: score.name, time: score.time)
        }
            Spacer()
        } .background(Image("_bg_blue"))
    }
}

struct Score: Identifiable {
    var id: UUID = UUID()
    var name: String = ""
    var time: String = ""
    
    init(name: String, time: String){
        self.name = name
        self.time = time
    }
}


