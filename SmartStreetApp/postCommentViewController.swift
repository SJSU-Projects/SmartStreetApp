//
//  postCommentViewController.swift
//  SmartStreetApp
//
//  Created by Preethi on 3/28/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse


var rated:Int = 0
class postCommentViewController: UIViewController{
    
  
    @IBOutlet var commentInput: UITextField!
    
    
    @IBOutlet var ratingControl: RatingControl!
    
    
    var activityIndicator =  UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
         self.title = "Comment"
        print("comment please")
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    @IBAction func postCommentButton(sender: AnyObject) {
        activityIndicator = UIActivityIndicatorView(frame: self.view.frame)
        activityIndicator.backgroundColor = UIColor(red: 0.918, green: 0.8, blue: 0.125, alpha: 0.5)

        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        var post = PFObject(className: "Post")
        
        post["message"] = commentInput.text
        
        post["userId"] = PFUser.currentUser()!.objectId!
        
        post["rate"] = rated
        
        var errorMessage = "Please try again later"
        
        post.saveInBackgroundWithBlock{(success, error) -> Void in
            
            self.activityIndicator.stopAnimating()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            
            if error == nil {
                
                self.displayAlert("Feedback Received", message: "Thanks for your Comments! Enjoy Smart Street")
                
            } else {
                
                if let errorString = error!.userInfo["error"] as? String {
                    
                    errorMessage = errorString
                    
                }
                self.displayAlert("Failed SignUp", message: errorMessage)
                
                
            }
        }
    }
    
    
    
    
    // Display Alerts in case of an Error
    func displayAlert(title: String, message: String) {
        
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: {(action) -> Void in
           // self.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
        
        
    }
    
    override func touchesBegan(touches : Set<UITouch>, withEvent event:UIEvent?)
    {
        
        self.view.endEditing(true)
    }
    
    
    //control the keyboard by pressing the retur button
    func textFieldShouldReturn(textField : UITextField!) -> Bool{
        
        textField.resignFirstResponder()
        
        return true
    }
    


    
    
}
