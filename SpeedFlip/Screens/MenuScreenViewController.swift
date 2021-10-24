//
//  MenuScreenViewController.swift
//  MemoryGame
//
//  Created by Nicholas Verrico on 2/13/17.
//  Copyright © 2017 Nicholas Verrico. All rights reserved.
//

import UIKit
import SwiftUI

/// Wrapper for SwiftUI integration
struct MenuScreen: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> MenuScreenViewController {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Menu")
        return vc as! MenuScreenViewController
    }

    func updateUIViewController(_ uiViewController: MenuScreenViewController, context: Context) {}

    typealias UIViewControllerType = MenuScreenViewController
}




class MenuScreenViewController: UIViewController {
  
    let segue_NewGame = "NewGame"
   // var scores = [Score]()

    // Mutes audio
    @IBAction func muteButton(_ sender: Any) {
        AudioManager.shared.isMuted.toggle()
    }
  
    @IBAction func scoreButtonTapped(_ sender: Any) {
        presentSwiftUIView()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        AudioManager.shared.playSoundtrack(screen:"MenuAudio", volume: 0.75)
        AudioManager.shared.playSoundtrack(screen: "GameAudio", volume: 0)
     
    }


  //  @IBAction func unwindToMenu(segue:UIStoryboardSegue){}
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is PlayScreen{
        // passes audio mute to game object when seguein
            // if muted will not call crossfade
            guard !AudioManager.shared.isMuted else {return}
       
         
            DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                // ramps up new sound and down active sound
                AudioManager.shared.crossFade(active: AudioManager.shared.queuePlayers[0], new: AudioManager.shared.queuePlayers[1], newVolume: 0.6)

            })
        }
    }

    func presentSwiftUIView() {
        
        
        let swiftUIView = ScoreView(scores: [
            Score(name: "Sam", time: "3:15"),
            Score(name: "Ned", time: "4:34")
        ])
        let hostingController = UIHostingController(rootView: swiftUIView)
        present(hostingController, animated: true, completion: nil)
    }
}
