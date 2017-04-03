//
//  audioPlayViewController.swift
//  SmartStreetApp
//
//  Created by Preethi on 3/28/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse
import AVFoundation

class audioPlayViewController: UIViewController{
    
    var player: AVAudioPlayer = AVAudioPlayer()
    
    var receivedAudio:RecordAudio!
    
    @IBOutlet var slider: UISlider!
    
    var isPlaying = false
    
    var timer:NSTimer!
    
    @IBOutlet var playedTimeLabel: UILabel!
    
     var urlaudio :NSURL = NSURL()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = " Player"
        do {
            //     try  player = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: audioPath))
            try player = AVAudioPlayer(contentsOfURL: receivedAudio.filePathURL)
            player.enableRate = true
            
            
        } catch{
            //Process error here
            
        }
        
        
        // We need just to get the documents folder url
        let documentsUrl =  NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
        
        // now lets get the directory contents (including folders)
        do {
            let directoryContents = try NSFileManager.defaultManager().contentsOfDirectoryAtURL(documentsUrl, includingPropertiesForKeys: nil, options: NSDirectoryEnumerationOptions())
            print(directoryContents)
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        // if you want to filter the directory contents you can do like this:
        
        
        do {
            let directoryUrls = try  NSFileManager.defaultManager().contentsOfDirectoryAtURL(documentsUrl, includingPropertiesForKeys: nil, options: NSDirectoryEnumerationOptions())
            print(directoryUrls)
            let mp3Files = directoryUrls.filter{ $0.pathExtension == ".caf" }.map{ $0.lastPathComponent }
            print("caf:\n" + mp3Files.description)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        
       
    }
    
    @IBAction func shareButton(sender: AnyObject) {
        
        urlaudio  = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
        //self.dismissViewControllerAnimated(true, completion: nil)
        
        let activityController = UIActivityViewController(activityItems:[urlaudio], applicationActivities: nil)
        presentViewController(activityController, animated: true,completion: nil)

        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func playButton(sender: AnyObject) {
        if isPlaying{
            player.pause()
            isPlaying = false
        } else {
            
            player.play()
            isPlaying =  true
            player.rate = 1.0
            timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "updateTime", userInfo: nil, repeats: true)
            
        }
        
    }
    
    
    @IBAction func stopButton(sender: AnyObject) {
        player.stop()
        player.currentTime = 0
        isPlaying = false
    }
    
    
    @IBAction func adjustVolumeSlider(sender: AnyObject) {
        player.volume = slider.value
    }
    
    func updateTime(){
        let currentTime =  Int(player.currentTime)
        let min = currentTime/60
        let sec = currentTime - min * 60
        
        playedTimeLabel.text = NSString(format: "%02d:%02d",min,sec) as String
        
        
    }

  
    @IBAction func slowPlayButton(sender: AnyObject) {
        player.rate = 0.5
        resetplayer()
 
    }
    
    @IBAction func fastPlayButton(sender: AnyObject) {
        player.rate = 2.0
        resetplayer()
    }
    
    func resetplayer(){
        player.play()
        player.currentTime = 0.0
    }
    
    
}
