//
//  ShareMediaViewController.swift
//  SmartStreetApp
//
//  Created by Preethi on 3/28/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Social
import MediaPlayer
import MobileCoreServices
import AVKit
import AVFoundation

class ShareMediaViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    @IBOutlet var postImage: UIImageView!
    
    @IBOutlet var postText: UITextField!
    
    //video
    var objMoviePlayerController: MPMoviePlayerController = MPMoviePlayerController()
    var urlVideo :NSURL = NSURL()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "Share"
        print("Im Sharing")
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sharePhotoButton(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum
        imagePicker.mediaTypes = [kUTTypeMovie as NSString as String, kUTTypeImage as NSString as String]
        imagePicker.allowsEditing = false
        self.presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    
    @IBAction func shareVideoButton(sender: AnyObject) {
        let ipcVideo = UIImagePickerController()
        ipcVideo.delegate = self
        ipcVideo.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum
        //  let kUTTypeMovieAnyObject : AnyObject = kUTTypeMovie as AnyObject
        ipcVideo.mediaTypes = [kUTTypeMovie as! String]
        self.presentViewController(ipcVideo, animated: true, completion: nil)
        

    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let mediaType = info[UIImagePickerControllerMediaType] as! NSString
        
        if mediaType.isEqualToString(kUTTypeImage as NSString as String){
            print("image")
            self.dismissViewControllerAnimated(true, completion: nil)
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            postImage.image = image
            
        } else if mediaType.isEqualToString(kUTTypeMovie as NSString as String) {
            print("Got Video")
            urlVideo = info[UIImagePickerControllerMediaURL] as! NSURL
            self.dismissViewControllerAnimated(true, completion: nil)
            let asset = AVURLAsset(URL: urlVideo)
            let generator = AVAssetImageGenerator(asset: asset)
            generator.appliesPreferredTrackTransform = true
            
            let timestamp = CMTime(seconds: 1, preferredTimescale: 60)
            
            do {
                let imageRef = try generator.copyCGImageAtTime(timestamp, actualTime: nil)
                postImage.image = UIImage(CGImage: imageRef)
            }
            catch let error as NSError
            {
                print("Image generation failed with error \(error)")
                
            }
            
            
            let activityController = UIActivityViewController(activityItems:[urlVideo], applicationActivities: nil)
            presentViewController(activityController, animated: true,completion: nil)
            
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        postText.endEditing(true)
    }
    
    @IBAction func sendPost(sender: AnyObject) {
        var activityItems: [AnyObject]?
        
        let image = postImage.image
        
        if (postImage.image != nil) {
            activityItems = [postText.text!, postImage.image!]
        } else {
            activityItems = [postText.text!]
        }
        
        let activityController = UIActivityViewController(activityItems:
            activityItems!, applicationActivities: nil)
        self.presentViewController(activityController, animated: true,
            completion: nil)
        self.displayAlert("Shared", message: "Thanks for Posting on SmartStreet!!!")
        print("Posted success")
    }
 
    // Display Alerts in case of an Error
    func displayAlert(title: String, message: String) {
        
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: {(action) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
        
        
    }

    
}






    

    
