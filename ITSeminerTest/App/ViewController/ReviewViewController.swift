//
//  ReviewViewController.swift
//  ITSeminerTest
//
//  Created by Cem Olcay on 24/02/15.
//  Copyright (c) 2015 Cem Olcay. All rights reserved.
//

import UIKit

class ReviewViewController: UIViewController, WriteViewControllerDelegate {

    // MARK: Properties
    
    var review: FRReview!
    var scroll: UIScrollView!
    
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        
        draw()
        
        navigationItem.leftBarButtonItem = barButtonItem("back.png", {
            [unowned self] (sender) -> () in
            self.pop()
        })
        
        navigationItem.rightBarButtonItem = barButtonItem("comment.png", {
            [unowned self] (sender) -> () in
            self.performSegueWithIdentifier("writeCommentSegue", sender: self)
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "writeCommentSegue" {
            let nav = segue.destinationViewController as! UINavigationController
            let write = nav.viewControllers[0] as! WriteViewController
            write.delegate = self
            write.title = "Write Comment"
            write.relatedReview = review.pfObject
            write.type = .Comment
        }
    }

    
    // MARK: Draw
    
    func draw () {
        SVProgressHUD.show()
        
        scroll = UIScrollView (frame: view.frame)
        view.addSubview (scroll)
        
        scroll.contentHeight = 10
        view.addSubview(scroll)
        
        let reviewCard = ReviewCard (
            data: review,
            authorPressed: {
                [unowned self] in
                let profile = UIStoryboard (name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Profile") as! ProfileViewController
                profile.user = self.review.author
                self.push(profile)
            },
            drawFooter: false)
        
        reviewCard.y = scroll.contentHeight
        scroll.addSubview(reviewCard)
        scroll.contentHeight += reviewCard.h + 15
        
        review.getComments {
            [unowned self] comments in
            
            let commentSectionLabel = UILabel (
                x: 20,
                y: reviewCard.bottomWithOffset(15),
                attributedText: NSAttributedString.Title("Comments"),
                textAlignment: .Left)
            
            self.scroll.addSubview(commentSectionLabel)
            self.scroll.contentHeight += commentSectionLabel.h + 15
            
            for comment in comments {
                let commentCard = CommentCard (data: comment)
                commentCard.y = self.scroll.contentHeight
                self.scroll.addSubview(commentCard)
                self.scroll.contentHeight += commentCard.h + 10
            }
            
            let writeCommentCard = MaterialCardView (x: 10, y: self.scroll.contentHeight, w: self.scroll.w - 20)
            writeCommentCard.addCell("Write comment")
            writeCommentCard.addRipple { [unowned self] in
                self.performSegueWithIdentifier("writeCommentSegue", sender: nil)
            }
            self.scroll.contentHeight += writeCommentCard.h + 10
            self.scroll.addSubview(writeCommentCard)
            
            SVProgressHUD.dismiss()
        }
    }
    
    
    // MARK: WriteViewControllerDelegate
    
    func writeViewControllerDidSuccess(writeViewController: WriteViewController) {
        writeViewController.dismiss(nil)
        
        scroll.removeFromSuperview()
        scroll = nil
        
        draw()
    }
}
