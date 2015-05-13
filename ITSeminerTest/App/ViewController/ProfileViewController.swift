//
//  ProfileViewController.swift
//  ITSeminerTest
//
//  Created by Cem Olcay on 24/02/15.
//  Copyright (c) 2015 Cem Olcay. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, WriteViewControllerDelegate {
    
    // MARK: Properties
    
    var user: FRUser!
    
    var scroll: StrechyParallaxScrollView!
    let topViewHeight: CGFloat = 200
    
    var topView: UIImageView!
    var bubble: UIImageView!
    
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupScrollView()
        draw()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "writeReviewSegue" {
            let nav = segue.destinationViewController as! UINavigationController
            let write = nav.viewControllers[0] as! WriteViewController
            write.delegate = self
            write.type = .Review
            write.relatedUser = user!.pfUser
            write.title = user.getName()! + " Review"
        } else if segue.identifier == "reviewSegue" {
            let review = segue.destinationViewController as! ReviewViewController
            review.review = sender as! FRReview
            review.title = user.getName()! + " Review"
        }
    }
    
    
    // MARK: Draw
    
    func setupNavigationBar () {
        
        // title
        
        navigationItem.title = user.getName()
        
        
        // review button
        
        if user.objectId != PFUser.currentUser().objectId {
            navigationItem.rightBarButtonItem = barButtonItem("write.png", {
                [unowned self] sender in
                if let u = self.user {
                    self.performSegueWithIdentifier("writeReviewSegue", sender: self)
                }
            })
        }
        
        
        // back button
        
        if navigationController?.viewControllers.count > 1 {
            navigationItem.leftBarButtonItem = barButtonItem("back.png", {
                [unowned self] sender in
                SVProgressHUD.dismiss()
                self.navigationController?.popViewControllerAnimated(true)
            })
        }
    }
    
    func setupScrollView () {
        
        topView = UIImageView (frame: CGRect (x: 0, y: 0, width: view.w, height: topViewHeight))
        topView.contentMode = .ScaleAspectFill
        topView.backgroundColor = UIColor.FBTitleColor()
        
        scroll = StrechyParallaxScrollView (frame: view.frame, andTopView: topView)
        scroll.parallax = false
        scroll.scrollView.contentInset.bottom = 44
        view.addSubview(scroll)
    }
    
    func draw () {
        
        SVProgressHUD.show()
        
        bubble = UIImageView (frame: CGRect (x: 0, y: 0, width: 100, height: 100))
        bubble.setCornerRadius(bubble.w/2)
        bubble.backgroundColor = UIColor.FBBorderColor()
        bubble.addBorder(2, color: UIColor.Gray(237))
        
        user.getImage {
            [unowned self] image in
            self.topView.image = image
            self.bubble.image = image
        }
        
        bubble.center.x = topView.center.x
        bubble.center.y = topView.bottom
        scroll.addSubview(bubble)
        
        let nameLabel = UILabel (
            x: 10,
            y: bubble.bottomWithOffset(10),
            width: scroll.w - 20,
            text: user.getName()!,
            textColor: UIColor.FBTitleColor(),
            textAlignment: .Center,
            font: UIFont.TitleFont())
        scroll.addSubview(nameLabel)
        scroll.scrollView.contentHeight = nameLabel.bottomWithOffset(20)
    
        user.getReviews {
            [unowned self] reviews in
            
            if reviews.count > 0 {
                for review in reviews {
                    let reviewCard = ReviewCard (
                        data: review,
                        action: {
                            [unowned self] in
                            self.performSegueWithIdentifier("reviewSegue", sender: review)
                        },
                        authorPressed: {
                            [unowned self] in
                            let profile = UIStoryboard (name: "Main", bundle: nil)
                                .instantiateViewControllerWithIdentifier("Profile") as! ProfileViewController
                            profile.user = review.author
                            self.push(profile)
                        })
                    
                    reviewCard.y = self.scroll.scrollView.contentHeight
                    self.scroll.addSubview(reviewCard)
                    self.scroll.scrollView.contentHeight += reviewCard.h + 10
                }
                
                if self.scroll.scrollView.contentHeight < self.scroll.h {
                    self.scroll.scrollView.contentHeight = self.scroll.h + 1
                }
            } else {
                let label = UILabel (
                    x: 20,
                    y: self.scroll.scrollView.contentHeight,
                    width: self.scroll.w - 40,
                    attributedText: NSAttributedString (
                        text: "You have no reviews 😕",
                        color: UIColor.TitleColor(),
                        font: UIFont.TextFont()),
                    textAlignment: .Center)
                self.scroll.addSubview(label)
            }
            
            SVProgressHUD.dismiss()
        }
    }
    
    
    // MARK: WriteViewControllerDelegate
    
    func writeViewControllerDidSuccess(writeViewController: WriteViewController) {
        writeViewController.dismiss(nil)
        
        scroll.removeFromSuperview()
        scroll = nil
        
        setupScrollView()
        draw()
    }
    
}
