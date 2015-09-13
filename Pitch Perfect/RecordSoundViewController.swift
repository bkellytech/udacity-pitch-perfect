//
//  RecordSoundViewController.swift
//  Pitch Perfect
//
//  Created by admin on 8/23/15.
//  Copyright (c) 2015 admin. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundViewController: UIViewController, AVAudioRecorderDelegate {
    
    var flgRecording = false;
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    @IBOutlet weak var btnRecord: UIButton!
    @IBOutlet weak var btnStopRecording: UIButton!

    @IBOutlet weak var recordingInProgress: UILabel!
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    
    /* UI Actions */

    @IBAction func recordAudio(sender: UIButton) {
        let imageOff = UIImage(named: "microphoneOff") as UIImage!
        let imageOn = UIImage(named: "microphoneOn") as UIImage!
        
        if !flgRecording {
            
            //record sound
            recordingInProgress.text = "Recording...";
            btnStopRecording.hidden = false;
            flgRecording = true;
            btnRecord.setImage(imageOn, forState: UIControlState.Normal);
            btnRecord.enabled = false;
            
            let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
            

            let recordingName = "pitchPerfect.wav"
            let pathArray = [dirPath, recordingName]
            let filePath = NSURL.fileURLWithPathComponents(pathArray)
            println(filePath)
            
            var session = AVAudioSession.sharedInstance()
            session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
            
            audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
            audioRecorder.delegate = self
            audioRecorder.meteringEnabled = true
            audioRecorder.prepareToRecord()
            audioRecorder.record()
            
        }
        
    }
    
    
    @IBAction func stopRecording(sender: UIButton) {
        let imageOff = UIImage(named: "microphoneOff") as UIImage!
        let imageOn = UIImage(named: "microphoneOn") as UIImage!
        
        if flgRecording {
            recordingInProgress.text = "Tap to Record";
            btnStopRecording.hidden = true;
            flgRecording = false;
            btnRecord.setImage(imageOff, forState: UIControlState.Normal);
            btnRecord.enabled = true;
            
            audioRecorder.stop()
            var audioSession = AVAudioSession.sharedInstance()
            audioSession.setActive(false, error: nil)
        }
        
    }
    
    /* Utility Functions */
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if(flag) {
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!)
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        } else {
            println("Error during segue in Audio Recorder")
            
            /* Show Alert */
            let alertController = UIAlertController(title: "Recording Error", message:"An Error Occurred During Recording, Please Try Again", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
            
            btnRecord.enabled = true
            btnStopRecording.hidden = true
        }
        
        
    }

}

