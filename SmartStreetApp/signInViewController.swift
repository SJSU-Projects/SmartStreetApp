//
//  signInViewController.swift
//  SmartStreetApp
//
//  Created by Preethi on 3/27/16.
//  Copyright © 2016 Parse. All rights reserved.
//
import UIKit
import Parse

class signInViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var usernameInput: UITextField!
    
    @IBOutlet var passwordInput: UITextField!
    
    
    //Empty Activity Indicator View
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "Login"
        print("In Login")
        self.view.sendSubviewToBack(imageView)

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func logInButton(sender: AnyObject) {
        // Validation of User input fields
        if usernameInput.text == "" || passwordInput.text == ""{
            
            displayAlert("Unable to SignUp", message: "Please enter correct Username and Password!!")
            
        } else {
            
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
            var user1 = PFUser()
            var errorMessage = "Please try again later"
            
            PFUser.logInWithUsernameInBackground(usernameInput.text!, password: passwordInput.text!, block: { (user1, error) -> Void in
                
                self.activityIndicator.stopAnimating()
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                
                if user1 != nil {
                    //Navigate to home screen
                   // self.displayAlert("Login Successful!", message: "Welcome to Smart Street")
                   // dispatch_async(dispatch_get_main_queue()){
                    //    self.performSegueWithIdentifier("home", sender: nil)
                    //}
                    self.performSegueWithIdentifier("home", sender: nil)
                    print("Please go to home screen")
                    
                    
                    
                } else {
                    if let errorString = error!.userInfo["error"] as? String {
                        errorMessage = errorString
                        
                    }
                    self.displayAlert("Unable to Login!", message: errorMessage)
                }
            })
            
            
            
        }

    }
    
    
    // Display Alerts in case of an Error
    func displayAlert(title: String, message: String) {
        
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: {(action) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
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
