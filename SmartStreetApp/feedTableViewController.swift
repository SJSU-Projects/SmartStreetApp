//
//  feedTableViewController.swift
//  SmartStreetApp
//
//  Created by Preethi on 3/28/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class feedTableViewController: UITableViewController {
    
    
    var messages = [String]()
    var usernames = [String]()
    var ratings = [Int]()
    var users = [String:String]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Get User name
        var query =  PFUser.query()
        query?.findObjectsInBackgroundWithBlock({ (objects, error ) -> Void in
            if let users = objects {
                self.messages.removeAll(keepCapacity: true)
                self.users.removeAll(keepCapacity: true)
                self.usernames.removeAll(keepCapacity: true)
                print("test1")
                for object in users {
                    print("test2")
                    if let user = object as? PFUser{
                        self.users[user.objectId!] = user.username!
                        print("test3")
                    }
                    print(self.users)
                }
                
            }
            
            var UserQuery = PFQuery(className: "Post")
            UserQuery.findObjectsInBackgroundWithBlock { (objects, error ) -> Void in
                print("test4")
                if let objects = objects {
                    
                    for object in objects {
                        
                        self.messages.append(object["message"] as! String)
                        self.usernames.append(self.users[object["userId"] as! String]!)
                        self.ratings.append(object["rate"] as! Int)
                        self.tableView.reloadData()
                        
                    }
                    
                    
                }
                
            }
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usernames.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellidentifier = "cellFeed"
        let mycell = tableView.dequeueReusableCellWithIdentifier(cellidentifier, forIndexPath: indexPath) as! cellFeed
        
        
        
        mycell.message.text = messages[indexPath.row]
        mycell.username.text = usernames[indexPath.row]
       	mycell.ratingControl.rating = ratings[indexPath.row]
        return mycell
        
    }


}
