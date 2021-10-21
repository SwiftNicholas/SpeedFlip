//
//  AudioLogic.swift
//  MemoryGame
//
//  Created by Nicholas Verrico on 2/11/17.
//  Copyright © 2017 Nicholas Verrico. All rights reserved.
//

import Foundation
import AVFoundation
import GameplayKit
import UIKit


class AudioLogic{
    
    private init(){}
    
    static var audio = AudioLogic()
    
    // creats base
    var queuePlayers = [AVQueuePlayer]()
    
    var looper:AVPlayerLooper!
    
    var soundEffectPlayer = AVPlayer()

    
    func mute(){
        
        for players in self.queuePlayers{
        
            players.pause()
        }
    }
    
    func unmute(){
        
        for players in self.queuePlayers{
            
            players.play()
        }
        
        
    }
    
    func playSoundtrack(screen:String, volume:Float){
        guard game.mute == false else {
            print("Muted")
            return
        }
        
        let session = AVAudioSession.sharedInstance()
        print("Accessing shared audio instance")
      
        print("Setting output channels")
        do {try session.setPreferredOutputNumberOfChannels(4)}
        catch
        {assertionFailure("Cannot set output channels")}
        print("Output channels set")
        
        print("Setting input channels")
        do {try session.setPreferredInputNumberOfChannels(4)}
        catch
        {assertionFailure("Cannot set Input channels")}
        print("Input channels set")
        
        
        var soundtrackAVItemArray = [AVPlayerItem]()
        let url = Bundle.main.urls(forResourcesWithExtension: "wav", subdirectory: screen)
       
        if url?.count != 0 {
        
            let randomNumberSource = GKRandomSource()
            let shuffedTracks = randomNumberSource.arrayByShufflingObjects(in: url!) as! [URL]
            for (_, element) in (shuffedTracks.enumerated()){
                let asset = AVAsset(url: element)
                
                let avItem = AVPlayerItem(asset: asset)
                
                soundtrackAVItemArray.append(avItem)
            }
            
            let player = AVQueuePlayer(items: soundtrackAVItemArray)
            
            looper = AVPlayerLooper(player: player, templateItem: soundtrackAVItemArray[0])
            
            self.queuePlayers.append(player)
            // Begin looping playback
           
            self.queuePlayers.last?.volume = volume
            self.queuePlayers.last?.play()
          
         
         
        }
    }
    
    
  
    
    func cardFlipSoundEffect(){
        if game.mute {return}
        
                let url = Bundle.main.url(forResource: "CardFlipSoundEffect", withExtension: "wav", subdirectory: "/SoundEffects")
                
                let avItem = AVPlayerItem(url: url!)
        
                self.soundEffectPlayer = AVPlayer(playerItem: avItem)
                self.soundEffectPlayer.volume = 0.5
                self.soundEffectPlayer.actionAtItemEnd = .pause
                self.soundEffectPlayer.play()
        
    }
    
    func matchSoundEffect(){
        if game.mute{return}
        
        let url = Bundle.main.url(forResource: "MatchSoundEffect", withExtension: "wav", subdirectory: "/SoundEffects")
        
        let avItem = AVPlayerItem(url: url!)
        
        self.soundEffectPlayer = AVPlayer(playerItem: avItem)
        self.soundEffectPlayer.volume = 0.5
        self.soundEffectPlayer.actionAtItemEnd = .pause
        self.soundEffectPlayer.play()
        
    }
    
    func crossFade(active:AVQueuePlayer, new:AVQueuePlayer, newVolume:Float){
    
        func ramp(delay:Double, active:AVQueuePlayer, new:AVQueuePlayer, completion:()){
                    var localDelay = delay
                for _ in stride(from: 0, to: newVolume, by: 0.01) {
                    
                    localDelay = delay + 0.03
                    DispatchQueue.main.asyncAfter(deadline: .now() + localDelay) {
                    ()
                    new.volume = new.volume + 0.001
                        if active.volume > 0.3{
                        active.volume = active.volume - 0.3
                        } else if active.volume < 0.3{
                        
                        active.volume = 0
                        
                        }
                    }
            }
        }
        
        ramp(delay: 0, active: active, new: new, completion: {
            () in
            DispatchQueue.main.asyncAfter(deadline: .now() + 8){
                active.pause()}
        }())
       
    }
    
    
}
