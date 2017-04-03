//
//  audioRecViewController.swift
//  SmartStreetApp
//
//  Created by Preethi on 3/28/16.
//  Copyright © 2016 Parse. All rights reserved.


import UIKit
import Parse
import AVFoundation

class audioRecViewController: UIViewController, AVAudioRecorderDelegate{
    
    @IBOutlet var recordingInProgressLabel: UILabel!
    
   
    @IBOutlet var stopButton: UIButton!
    
    //declare instance variable to record sound
    var audioRecorder:AVAudioRecorder!
    
    //Object for the new class
    var recordedAudio:RecordAudio!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "Recorder"
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        //Hide the stop Button
        
        stopButton.hidden = true
        
    }
    @IBAction func recordAudioButton(sender: AnyObject) {
        //Hide the Stop Buttons
        recordingInProgressLabel.hidden = false
        stopButton.hidden = false
        
        //Record Users Voice
        
        let dirPath =  NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) [0] as String
        
        var currentDateTime =  NSDate()
        var formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        
        var recordingName =  formatter.stringFromDate(currentDateTime) + ".caf"
        var pathArray = [dirPath, recordingName]
        
        
        let filepath = NSURL.fileURLWithPathComponents(pathArray)
        print(filepath)
        
        let settings: [String : AnyObject] = [
            AVFormatIDKey:Int(kAudioFormatAppleIMA4), //Int required in Swift2
            AVSampleRateKey:44100.0,
            AVNumberOfChannelsKey:2,
            AVEncoderBitRateKey:12800,
            AVLinearPCMBitDepthKey:16,
            AVEncoderAudioQualityKey:AVAudioQuality.Max.rawValue
        ]
        
        
        //Setup Audio Session
        
        var session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try audioRecorder = AVAudioRecorder(URL: filepath!, settings: settings)
            audioRecorder.prepareToRecord()
            audioRecorder.meteringEnabled = true;
            audioRecorder.record()
            audioRecorder.delegate = self
        } catch {
            print("Unable to record")
        }
        

    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        
        if(flag){
            //save the recorded audio
            recordedAudio =  RecordAudio()
            recordedAudio.filePathURL = recorder.url
            recordedAudio.title = recorder.url.lastPathComponent
            //Perform segue after finish recording
            self.performSegueWithIdentifier("stopRecordingSegue", sender: recordedAudio)
            print("finish recording")
        } else {
            
            print("Error recording")
        }
        
    }
    
   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("Insegue")
        if (segue.identifier == "stopRecordingSegue"){
            let playSoundsVC:audioPlayViewController = segue.destinationViewController as! audioPlayViewController
            
            let data = sender as! RecordAudio
            playSoundsVC.receivedAudio = data
            print("segue successful")
        }
    
    }


    @IBAction func stopButton(sender: AnyObject) {
   
     
        recordingInProgressLabel.hidden = true
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(false)
        } catch {
            print("Failed to stop")
        }
    }
    
}
