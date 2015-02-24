//
//  FriendsViewController.swift
//  ITSeminerTest
//
//  Created by Cem Olcay on 24/02/15.
//  Copyright (c) 2015 Cem Olcay. All rights reserved.
//

import UIKit

class FriendsViewController: UIViewController {

    var friends: [FacebookFriend] = []
    var scroll: UIScrollView!
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        getFriendsWithPhoto()
        
        parentViewController?.navigationItem.rightBarButtonItem = barButtonItem("invite.png", {
            [unowned self] (sender) -> () in
            self.inviteFriendsPressed()
        })
    }
    
    func inviteFriendsPressed () {
        FBWebDialogs.presentRequestsDialogModallyWithSession(nil,
            message: "Let me review you 🙊",
            title: "Invite firends", parameters: nil) {
                (dialogResult, url, error) -> Void in
                if let e = error {
                    println(e.description)
                } else {
                    println(url)
                    println(dialogResult)
                }
        }
    }
    
    
    func getFriendsWithPhoto () {
        SVProgressHUD.showWithStatus("Getting friends", maskType: .Black)
        
        FBRequestConnection.startWithGraphPath("me/friends?fields=first_name,last_name,id,picture",
            completionHandler: { [unowned self] (connection, result, error) -> Void in
            if let e = error {
                SVProgressHUD.showErrorWithStatus("Could not getting friends")
                println(e.description)
            } else {
                let friendsData = result["data"] as! [[String: AnyObject]]
                for friendData in friendsData {
                    var friend = FacebookFriend (data: friendData)
                    self.friends.append(friend)
                }
                self.drawFriends()
            }
        })
    }
    
    func drawFriends () {
        scroll = UIScrollView (frame: view.frame)
        scroll.contentHeight = navigationBarHeight + UIScreen.StatusBarHeight + 10
        view.addSubview(scroll)

        for friend in friends {
            let card = FriendCard (data: friend, action: {
                [unowned self] (fbId) -> Void in
                let profile = ProfileViewController (facebookId: fbId)
                self.push(profile)
            })
            
            card.y = scroll.contentHeight
            scroll.addSubview(card)
            scroll.contentHeight += card.h + 10
        }
        
        SVProgressHUD.dismiss()
    }
    
}
