//
//  ProfileViewController.swift
//  ITSeminerTest
//
//  Created by Cem Olcay on 24/02/15.
//  Copyright (c) 2015 Cem Olcay. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    
    // MARK: Properties
    
    var facebookId: String!
    var isSelf: Bool!
    
    var user: PFUser? {
        didSet {
            drawProfile()
        }
    }
    
    var scroll: StrechyParallaxScrollView!
    let topViewHeight: CGFloat = 150
    
    
    
    // MARK: Lifecycle
    
    
    // Another Profile
    // Get user from cloud
    init (facebookId: String) {
        super.init()
        self.facebookId = facebookId
        isSelf = false
    }
    
    
    // My profile
    // Draw my profile
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        facebookId = PFUser.currentUser().objectForKey("facebookId") as! String
        isSelf = true
        user = PFUser.currentUser()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    
    
    
    // MARK: Draw
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !isSelf {
            getUser()
            parentViewController?.navigationItem.rightBarButtonItem = barButtonItem("write.png", {
                [unowned self] (sender) -> () in
                self.writeReviewPressed()
            })
        } else {
            drawProfile()
        }
    }
    
    func drawProfile () {
        let top = UIImageView (frame: CGRect (x: 0, y: 0, width: view.w, height: topViewHeight))
        top.contentMode = .ScaleAspectFill
        top.backgroundColor = UIColor.FBTitleColor()
        
        let bubble = UIImageView (frame: CGRect (x: 0, y: 0, width: 100, height: 100))
        bubble.setCornerRadius(bubble.w/2)
        bubble.backgroundColor = UIColor.FBBorderColor()
        
        getProfilePicture { (imageUrl) -> Void in
            imageRequest(imageUrl, { (image) -> Void in
                top.image = image
                bubble.image = image
            })
        }
        
        scroll = StrechyParallaxScrollView (frame: view.frame, andTopView: top)
        scroll.parallax = false
        view.addSubview(scroll)
        
        bubble.center.x = top.center.x
        bubble.center.y = top.bottom
        scroll.addSubview(bubble)
        
        let first = user!.objectForKey("firstName") as! String
        let last = user!.objectForKey("lastName") as! String
        
        let nameLabel = UILabel (
            x: 10,
            y: bubble.bottomWithOffset(10),
            width: scroll.w - 20,
            text: first + " " + last,
            textColor: UIColor.FBTitleColor(),
            textAlignment: .Center,
            font: UIFont.TitleFont())
        scroll.addSubview(nameLabel)
        scroll.scrollView.contentHeight = 1000
    }
    
    func writeReviewPressed () {
        
    }
    
    
    
    // MARK: Get Data
    
    func getUser () {
        SVProgressHUD.showWithMaskType(.Black)
        
        let query = PFUser.query()
        query.whereKey("facebookId", equalTo: facebookId)
        query.getFirstObjectInBackgroundWithBlock { (user, error) -> Void in
            if let e = error {
                SVProgressHUD.showErrorWithStatus("We couldnt find the user 😕")
                println(e.description)
            } else {
                SVProgressHUD.dismiss()
                self.user = user as? PFUser
            }
        }
        
    }
  
    func getProfilePicture (success: (String)->Void) {
        FBRequestConnection.startWithGraphPath(facebookId + "/picture",
            parameters: ["redirect": "false", "type": "large"],
            HTTPMethod: "GET") {
                (connection, result, error) -> Void in
                if let e = error {
                    println("profile pic error")
                    println(e.description)
                } else {
                    let data = result as! [String: AnyObject]
                    let image = data["data"] as! [String: AnyObject]
                    let url = image["url"] as! String
                    success (url)
                }
        }
    }

    func getReviews () {
        
    }
}
