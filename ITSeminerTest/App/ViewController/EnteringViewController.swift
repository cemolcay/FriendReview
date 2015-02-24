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
}
