//
//  MenuViewController.swift
//  ITSeminerTest
//
//  Created by Cem Olcay on 24/02/15.
//  Copyright (c) 2015 Cem Olcay. All rights reserved.
//

import UIKit

class MenuViewController: DroppyMenuViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = barButtonItem("menu.png") {
            [unowned self] (sender) -> () in
            self.openMenu()
        }
        
        let friends = getViewController("Friends") as! FriendsViewController
        let profile = getViewController("Profile") as! ProfileViewController
        profile.user = FRUser.currentUser()
        
        viewControllers = [friends, profile]
    }
    
    func getViewController (id: String) -> UIViewController {
        return UIStoryboard (name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(id) as! UIViewController
    }
}
