//
//  signUpViewController.swift
//  SmartStreetApp
//
//  Created by Preethi on 3/27/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse
import AVFoundation




class signUpViewController: UIViewController,AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet var usernameInput: UITextField!
    
    @IBOutlet var passwordInput: UITextField!
    
    @IBOutlet var emailaddInput: UITextField!
    
    @IBOutlet var mobilenoInput: UITextField!
    
    @IBOutlet var resultLabel: UILabel!


    
    
    
    
    
    var receivedname:String = ""
    var receivedphone:String = ""
    var receivedmail:String = ""
    
    var signUpQRCode = true
    
    //Empty Activity Indicator View
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    //Scanner fields for QR Code Registration
    var objCaptureSession:AVCaptureSession?
    var objCaptureVideoPreviewLayer:AVCaptureVideoPreviewLayer?
    var vwQRCode:UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "Sign Up"
        print("In SignUP")
        print("Received Sign UP Name: \(receivedname) , Phone:\(receivedphone) , mail = \(receivedmail)")
        if(receivedname == "" && receivedphone == "" && receivedmail == ""){
            signUpQRCode = false
            print("No data from QRCode")
        } else {
            usernameInput.text = receivedname
            mobilenoInput.text = receivedphone
            emailaddInput.text = receivedmail
            print("till here")
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
   
    
    @IBAction func signUpButton(sender: AnyObject) {
        // Validation of User input fields
 
        
        
        if usernameInput.text == "" || passwordInput.text == "" || emailaddInput.text == "" || mobilenoInput.text == "" {
            
            displayAlert("Unable to SignUp", message: "Please enter all information")
            
        } else {
            print("In else")
            //Spinner activity indicator that it is signing up
            
            activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0,0,50,50))
            
            //Set to middle of screen
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            
            //Create User
           
            var user = PFUser()
            user.username = usernameInput.text
            user.password = passwordInput.text
            user.email  = emailaddInput.text
            user["phone"] = mobilenoInput.text
            
            var errorMessage = "Please try again later"
            
            user.signUpInBackgroundWithBlock({ (success, error) -> Void in
                
                self.activityIndicator.stopAnimating()
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                
                if error == nil {
                    
                    
                    self.displayAlert("Successful Signup", message: "Please Login..")
              
                    
                } else {
                    
                    if let errorString = error!.userInfo["error"] as? String {
                        
                        errorMessage = errorString
                        self.dismissViewControllerAnimated(true, completion: nil)
                        
                    }
                    
                    self.displayAlert("Failed SignUp", message: errorMessage)
                    
                }
                if error == nil {
                }
            })
            
        
          
            
        }
       
     
    }
    
    // Display Alerts in case of an Error
    func displayAlert(title: String, message: String) {
        
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: {(action) -> Void in
            //self.dismissViewControllerAnimated(true, completion: nil)
            self.navigationController?.popToRootViewControllerAnimated(true)
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
