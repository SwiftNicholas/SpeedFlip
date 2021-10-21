//
//  MenuScreenViewController.swift
//  MemoryGame
//
//  Created by Nicholas Verrico on 2/13/17.
//  Copyright © 2017 Nicholas Verrico. All rights reserved.
//

import UIKit
import SwiftUI

struct MenuScreen: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> MenuScreenViewController {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Menu")
        return vc as! MenuScreenViewController
    }

    func updateUIViewController(_ uiViewController: MenuScreenViewController, context: Context) {
        
    }

    typealias UIViewControllerType = MenuScreenViewController
}




class MenuScreenViewController: UIViewController {
  

    let segue_NewGame = "NewGame"
    var scores = [Score]()
    var mute = false
    // Mutes audio
    @IBAction func muteButton(_ sender: Any) {
        let currentAudio = AudioLogic.audio
        if self.mute == false {
        currentAudio.mute()
        self.mute = true
        }
        else {
        
        currentAudio.unmute()
            self.mute = false
        }
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        gameAudio.playSoundtrack(screen:"MenuAudio", volume: 0.75)
        gameAudio.playSoundtrack(screen: "GameAudio", volume: 0)
     
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func unwindToMenu(segue:UIStoryboardSegue){
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is PlayScreen{
        // passes audio mute to game object when segueing
            game.mute = self.mute
            // if muted will not call crossfade
            if game.mute {return}
         
            
            DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                // locally scoped references to audio players, created at view did load
                let menuMusic = gameAudio.queuePlayers[0]
                let playScreenMusic = gameAudio.queuePlayers[1]
                
                // ramps up new sound and down active sound
                gameAudio.crossFade(active: menuMusic, new: playScreenMusic, newVolume: 0.6)

            })
            
        }
    }

}
