//
//  LoginViewController.swift
//  ITSeminerTest
//
//  Created by Cem Olcay on 24/02/15.
//  Copyright (c) 2015 Cem Olcay. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        if let user = PFUser.currentUser() {
            performSegueWithIdentifier("goApp", sender: self)
        } 
    }
    
    @IBAction func facebookLoginPressed (sender: UIButton) {
        SVProgressHUD.showWithMaskType(.Black)
        
        let permissions = ["public_profile", "user_friends", "email"]
        PFFacebookUtils.logInWithPermissions(permissions, block: { [unowned self] (user, error) -> Void in
            SVProgressHUD.dismiss()
            
            if let e = error {
                println(e.description)
                UIAlertView.showWithTitle("Facebook Login Error",
                    message: "Something went wrong 😕",
                    cancelButtonTitle: "OK",
                    otherButtonTitles: nil,
                    tapBlock: nil)
            } else {
                let req = FBRequest.requestForMe()
                req.startWithCompletionHandler({ (connectoion, result, error) -> Void in
                    if let e = error {
                        println("facebook /me/ error")
                    } else {
                        let userData = result as! [String: AnyObject]
                        let fbId = userData["id"] as! String
                        let firstName = userData["first_name"] as! String
                        
                        let lastName = userData["last_name"] as! String
                        
                        user.setObject(fbId, forKey: "facebookId")
                        user.setObject(firstName, forKey: "firstName")
                        user.setObject(lastName, forKey: "lastName")
                        user.saveInBackground ()
                    }
                })
                
                UIAlertView.showWithTitle("Facebook Login",
                    message: "Login succeed 💪",
                    cancelButtonTitle: "OK",
                    otherButtonTitles: nil,
                    tapBlock: { (alert, index) -> Void in
                        self.performSegueWithIdentifier("goApp", sender: self)
                    })
            }
        })
    }
    
}
