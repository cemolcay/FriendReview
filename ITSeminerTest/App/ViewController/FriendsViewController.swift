//
//  FriendsViewController.swift
//  ITSeminerTest
//
//  Created by Cem Olcay on 24/02/15.
//  Copyright (c) 2015 Cem Olcay. All rights reserved.
//

import UIKit

class FriendsViewController: UIViewController {
    
    // MARK: Properties
    
    var scroll: UIScrollView!
    
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        
        scroll = UIScrollView (frame: view.frame)
        scroll.contentHeight = 10
        view.addSubview(scroll)

        getFriends {
            [unowned self] friends in
            self.drawFriends(friends)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "friendProfileSegue"  {
            let profile = segue.destinationViewController as! ProfileViewController
            profile.user = sender as! FRUser
        }
    }
    
    
    // MARK: Requests
    
    func getFriends (success: ([FRUser]) -> Void) {
        SVProgressHUD.showWithStatus("Getting friends", maskType: .Black)
        
        FBRequestConnection.startWithGraphPath("me/friends?fields=first_name,last_name,id,picture",
            completionHandler: {[unowned self] (connection, result, error) -> Void in
            if let e = error {
                SVProgressHUD.showErrorWithStatus("Could not getting friends")
                println(e.description)
            } else {
                
                // get facebook friends ids
                var ids: [String] = []
                let friendsData = result["data"] as! [[String: AnyObject]]
                for friendData in friendsData {
                    ids.append(friendData["id"] as! String)
                }
                
                
                // find friends pfusers by friends facebook ids
                let query = PFUser.query()
                query.whereKey("facebookId", containedIn: ids)
                query.findObjectsInBackgroundWithBlock({
                    [unowned self] (objects, error) -> Void in
                    if let e = error {
                        println("user get error")
                    } else {
                        var friends: [FRUser] = []
                        for obj in objects {
                            let friend = FRUser (user: obj as! PFUser)
                            friends.append(friend)
                        }
                        success (friends)
                    }
                })
                
            }
        })
    }
    
    
    // MARK: Draw
    
    func setupNavigationBar () {
        navigationItem.title = "Friends"
        navigationItem.rightBarButtonItem = barButtonItem("invite.png", {
            [unowned self] (sender) -> () in
            
            FBWebDialogs.presentRequestsDialogModallyWithSession(FBSession.activeSession(),
                message: "Let me review you 🙊",
                title: "Invite firends",
                parameters: nil) {
                    (dialogResult, url, error) -> Void in
                    if let e = error {
                        println(e.description)
                    } else {
                        println(url)
                        println(dialogResult)
                    }
            }
        })
    }
    
    func drawFriends (friends: [FRUser]) {

        for friend in friends {
            let card = FriendCard (
                data: friend,
                action: {
                    [unowned self] in
                    self.performSegueWithIdentifier("friendProfileSegue", sender: friend)
                })
            
            card.y = scroll.contentHeight
            scroll.addSubview(card)
            scroll.contentHeight += card.h + 10
        }
        
        if friends.count == 0 {
            let label = UILabel (
                x: 20,
                y: UIScreen.StatusBarHeight + navigationBarHeight + 20,
                width: scroll.w - 40,
                attributedText: NSAttributedString(
                    text: "You have no friends 😟",
                    color: UIColor.TextColor(),
                    font: UIFont.TextFont()),
                textAlignment: .Center)
            scroll.addSubview (label)
        }
        
        SVProgressHUD.dismiss()
    }
    
}
