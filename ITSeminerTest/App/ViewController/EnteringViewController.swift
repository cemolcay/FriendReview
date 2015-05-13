//
//  EnteringViewController.swift
//  ITSeminerTest
//
//  Created by Cem Olcay on 24/02/15.
//  Copyright (c) 2015 Cem Olcay. All rights reserved.
//

import UIKit

class EnteringViewController: UIViewController {

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        if let user = PFUser.currentUser() {
            performSegueWithIdentifier("startApp", sender: self)
        } else {
            performSegueWithIdentifier("goLogin", sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        
        if segue.identifier == "startApp" {
            let tab = segue.destinationViewController as! UITabBarController
            let nav = tab.viewControllers![0] as! UINavigationController
            let profile = nav.viewControllers.first! as! ProfileViewController
            profile.user = FRUser.currentUser()
        }
    }
}
