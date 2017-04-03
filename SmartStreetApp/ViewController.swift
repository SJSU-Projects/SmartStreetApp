/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import Parse
var currentUser = PFUser.currentUser()!.username

class ViewController: UIViewController{
    
    @IBOutlet var loginbutton: UIBarButtonItem!
    
    @IBOutlet var welcomeLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //Get User name
        print("User : \(currentUser!)")
       welcomeLabel.text = "Welcome to Smart Street \(currentUser!)"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "logout"{
            PFUser.logOut()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        // 1
        var nav = self.navigationController?.navigationBar
        // 2
        nav?.barStyle = UIBarStyle.Black
        nav?.tintColor = UIColor.yellowColor()
        // 3
       

        /*  if currentUser == nil {
        
        
        
            
            loginbutton.enabled = false
        
        } else {
            loginbutton.enabled = true
        }*/
                
    }
    
   }
