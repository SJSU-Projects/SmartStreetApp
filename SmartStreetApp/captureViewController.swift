//
//  captureViewController.swift
//  SmartStreetApp
//
//  Created by Preethi on 3/28/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import MobileCoreServices
import MediaPlayer


class captureViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet var imageView: UIImageView!
    
    var newMedia:Bool?
    
    let imagePicker = UIImagePickerController()
    
    var urlVideo :NSURL = NSURL()


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "Capture"
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func takePhotoButton(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
            
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            imagePicker.mediaTypes = [kUTTypeImage as NSString as String]
            imagePicker.allowsEditing = false
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
            newMedia = true
            
        }

    }
    
    @IBAction func takeVideoButton(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
            

        var cameraController = UIImagePickerController()
        cameraController.sourceType = .Camera
        cameraController.mediaTypes = [kUTTypeMovie as NSString as String]
        cameraController.allowsEditing = false
        cameraController.delegate = self
        
        self.presentViewController(cameraController, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func recordAudioButton(sender: AnyObject) {
    }
    
    // Delegate methods didFinishPickingMedia is called when user has finished taking and selecting an image
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let mediaType = info[UIImagePickerControllerMediaType] as! NSString
        
        
        print("\(mediaType)")
        
        if mediaType.isEqualToString(kUTTypeImage as NSString as String){
            print("reading image")
            let image =  info[UIImagePickerControllerOriginalImage] as! UIImage
            self.dismissViewControllerAnimated(true, completion: nil)
            imageView.image = image
            print("trying to save")
            UIImageWriteToSavedPhotosAlbum(imageView.image!, self, "image:didFinishSavingWithError:contextInfo:", nil)
            
            } else if mediaType.isEqualToString(kUTTypeMovie as NSString as String) {
                print("Got a video")
                
                if let pickedVideo:NSURL = (info[UIImagePickerControllerMediaURL] as? NSURL) {
                let path = (info[UIImagePickerControllerMediaURL] as! NSURL).path
                    if UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(path!) {
                        UISaveVideoAtPathToSavedPhotosAlbum(path!, self, "video:didFinishSavingWithError:contextInfo:", nil)
                    }
                   // self.dismissViewControllerAnimated(true, completion: nil)
                }
            urlVideo = info[UIImagePickerControllerMediaURL] as! NSURL
            self.dismissViewControllerAnimated(true, completion: nil)
            let asset = AVURLAsset(URL: urlVideo)
            let generator = AVAssetImageGenerator(asset: asset)
            generator.appliesPreferredTrackTransform = true
            
            let timestamp = CMTime(seconds: 1, preferredTimescale: 60)
            
            do {
                let imageRef = try generator.copyCGImageAtTime(timestamp, actualTime: nil)
                imageView.image = UIImage(CGImage: imageRef)
            }
            catch let error as NSError
            {
                print("Image generation failed with error \(error)")
                
            }
                
          }
    }
    
    func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafePointer<Void>) {
        if error == nil {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(ac, animated: true, completion: nil)
        } else {
            let ac = UIAlertController(title: "Save error", message: error?.localizedDescription, preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(ac, animated: true, completion: nil)
        }
    }
    
   
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    

    func video(videoPath: NSString, didFinishSavingWithError error: NSError?, contextInfo info: AnyObject) {
        var title = "Success"
        var message = "Video was saved"
        
        if let saveError = error {
            title = "Error"
            message = "Video failed to save"
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
    


}




