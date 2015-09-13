//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by admin on 9/7/15.
//  Copyright (c) 2015 admin. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    var avPlayer:AVAudioPlayer!
    var isPlaying = false
    var receivedAudio:RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /* UI Methods */
    @IBAction func playAudioChipmunkly(sender: AnyObject) {
       playAudioWithVariablePitch(1000)
    }
    
    @IBAction func playAudioDarthly(sender: AnyObject) {
        playAudioWithVariablePitch(-1000)
    }
    @IBAction func playAudioFastly(sender: AnyObject) {
        playAudioUsingAVPlayer(1.5);
    }

    @IBAction func playAudioSlowly(sender: AnyObject) {
        playAudioUsingAVPlayer(0.5);
    }
    
    @IBAction func stopPlaying(sender: AnyObject) {
        if (isPlaying) {
            avPlayer.stop()
            audioEngine.stop()
            audioEngine.reset()
            isPlaying = false
        }
    }
    
    /* Methods that actually control playback */
    
    func playAudioWithVariablePitch(pitch:Float) {
        if (isPlaying) {
            avPlayer.stop()
            isPlaying = false
        }
        audioEngine.stop()
        audioEngine.reset()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
        isPlaying = true
    }
    
    func playAudioUsingAVPlayer(rate:Float) {
        
        var error: NSError?
        self.avPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: &error)

        avPlayer.enableRate = true
        avPlayer.prepareToPlay()
        avPlayer.rate = rate
        avPlayer.volume = 1.0
        avPlayer.play()
        isPlaying = true
    }

}
