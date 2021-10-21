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


/// Singleton audio handling
struct AudioLogic{
    
    /// Singleton sealed init
    private init(){}
    
    /// Singleton access point for audio handling
    static var audio = AudioLogic()
    
    /// Queue players are used to set a list of audio files. These can then be set in a loop using the AVPlayerLooper
    var queuePlayers = [AVQueuePlayer]()
    
    /// Audio player used for one shot sound effects, must use the reference to avoid falling out of scope while playing sounds
    var soundEffectPlayer = AVPlayer()
    var looper: AVPlayerLooper!
    
    
    /// Use rawValue() to get back the appropriate URL for the soundeffect.
    enum SoundEffectTypes {
        case Flip
        case Match
        
        func rawValue() -> URL? {
            switch self {case .Flip:
                return Bundle.main.url(forResource: "CardFlipSoundEffect", withExtension: "wav", subdirectory: "/SoundEffects")
            case .Match:
               return Bundle.main.url(forResource: "MatchSoundEffect", withExtension: "wav", subdirectory: "/SoundEffects")
                
            }
        }
    }

    
    /// Loads a sound effect from url stores it in this singleton instance and plays it. The singleton avoids unneccessary changes it scope when playing sound effects.
    mutating func playSoundEffect(type: SoundEffectTypes){
        guard !game.mute else {return}
        
        let player = AVPlayer.configureSoundEffectPlayerFromURL(url: type.rawValue()!)
        self.soundEffectPlayer = player
        self.soundEffectPlayer.play()
    }

    
    func mute(){
        guard !self.queuePlayers.isEmpty else {return}
        _ = self.queuePlayers.map({$0.pause})
    }
    
    func unmute(){
        guard !self.queuePlayers.isEmpty else {return}
        _ = self.queuePlayers.map({$0.play})
    }
    
    mutating func playSoundtrack(screen:String, volume:Float){
        guard !game.mute else {print("Muted"); return}
        guard let url = Bundle.main.urls(
            forResourcesWithExtension: "wav",
            subdirectory: screen) else {return}
        guard !url.isEmpty else {return}
        
        var soundtracks = [AVPlayerItem]()
    
            let randomNumberSource = GKRandomSource()
            let shuffedTracks = randomNumberSource.arrayByShufflingObjects(in: url) as! [URL]
        
            for (_, url) in (shuffedTracks.enumerated()){
                soundtracks.append(AVPlayerItem.createPlayer(from: url))
            
            let player = AVQueuePlayer(items: soundtracks)
                player.volume = volume
            looper = AVPlayerLooper(player: player, templateItem: soundtracks[0])
            self.queuePlayers.append(player)
            self.queuePlayers.last!.play()
        }
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


extension AVPlayerItem {
   static func createPlayer(from URL: URL) -> AVPlayerItem{
        let asset = AVAsset(url: URL)
        let avPlayer = AVPlayerItem(asset: asset)
        return avPlayer
    }
}

extension AVPlayer {
    
    static func configureSoundEffectPlayerFromURL(url: URL, volume: Float = 0.5, action: ActionAtItemEnd = .pause) -> AVPlayer{
      
        let avItem = AVPlayerItem(url: url)
        let player = AVPlayer(playerItem: avItem)
        player.volume = volume
        player.actionAtItemEnd = action
        return player
    }
}


