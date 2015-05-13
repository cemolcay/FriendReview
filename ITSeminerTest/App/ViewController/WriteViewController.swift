//
//  WriteCommentViewController.swift
//  ITSeminerTest
//
//  Created by Cem Olcay on 24/02/15.
//  Copyright (c) 2015 Cem Olcay. All rights reserved.
//

import UIKit

enum WritingType: String {
    case Review     = "Review"
    case Comment    = "Comment"
}

protocol WriteViewControllerDelegate {
    func writeViewControllerDidSuccess (writeViewController: WriteViewController)
}

class WriteViewController: UIViewController {
    
    // MARK: Properties
    
    var type: WritingType?
    var relatedReview: PFObject?
    var relatedUser: PFUser?
    
    var textView: UITextView!
    var delegate: WriteViewControllerDelegate?
    
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        
        draw ()
        
        navigationItem.leftBarButtonItem = barButtonItem("close.png", {
            [unowned self] (sender) -> () in
            self.dismiss(nil)
        })
        
        navigationItem.rightBarButtonItem = barButtonItem("send.png", {
            [unowned self] (sender) -> () in
            
            if count(self.textView.text) <= 0 {
                UIAlertView.showWithTitle("Warning",
                    message: "Please write something",
                    cancelButtonTitle: "OK",
                    otherButtonTitles: nil,
                    tapBlock: nil)
                return
            }
            
            switch self.type! {
            case .Review:
                self.sendReview()
                
            case .Comment:
                self.sendComment()
            }
        })
    }
    
    
    // MARK: Draw
    
    func draw () {
        textView = UITextView (x: 10, y: 10, w: view.w - 20, h: view.h - 20)
        textView.backgroundColor = UIColor.clearColor()
        textView.tintColor = UIColor.FBTitleColor()
        textView.textColor = UIColor.TitleColor()
        textView.font = UIFont.TitleFont()
        textView.becomeFirstResponder()
        
        view.addSubview(textView)
    }
    
    
    // MARK: Requests
    
    func sendReview () {
        SVProgressHUD.showWithMaskType(.Black)
        
        let review = PFObject(className: "Review")
        review.setObject(textView.text, forKey: "Text")
        review.setObject(relatedUser, forKey: "User")
        review.setObject(PFUser.currentUser(), forKey: "Author")
        
        review.saveInBackgroundWithBlock {
            [unowned self] (success, error) -> Void in
            if let e = error {
                println("review save error")
                SVProgressHUD.showErrorWithStatus("Something went wrong :/")
            } else {
                if success {
                    self.success()
                    self.pushNotification()
                }
            }
        }
    }
    
    func sendComment () {
        SVProgressHUD.showWithMaskType(.Black)
        
        let comment = PFObject (className: "Comment")
        comment.setObject(PFUser.currentUser(), forKey: "Author")
        comment.setObject(textView.text, forKey: "Text")
        
        comment.saveInBackgroundWithBlock {
            [unowned self] (success, error) -> Void in
            if let e = error {
                println("comment save error")
                SVProgressHUD.showErrorWithStatus("Something went wrong :/")
            } else {
                if success {
                    
                    let reviewRelation = self.relatedReview!.relationForKey("Comments")
                    reviewRelation.addObject(comment)
                    self.relatedReview!.saveInBackgroundWithBlock({ (success, error) -> Void in
                        if let e = error {
                            println("comment relation save error")
                            SVProgressHUD.showErrorWithStatus("Something went wrong :/")
                        } else {
                            if success {
                                self.success()
                            } else {
                                println("comment relation save error")
                                SVProgressHUD.showErrorWithStatus("Something went wrong :/")
                            }
                        }
                    })
                } else {
                    println("comment error")
                    SVProgressHUD.showErrorWithStatus("Something went wrong :/")
                }
            }
        }
    }
    
    func success () {
        SVProgressHUD.showSuccessWithStatus (type!.rawValue + " sent !")
        delegate?.writeViewControllerDidSuccess(self)
    }


    // MARK: Push
    
    func pushNotification () {
        
        if UIDevice.currentDevice().model == "iPhone Simulator" {
            return
        }
        
        let pushQuery = PFInstallation.query()
        pushQuery.whereKey("installationUser", equalTo: relatedUser!)
        
        let push = PFPush ()
        push.setQuery(pushQuery)
        push.setMessage(FRUser.currentUser().getName()! + " wrote a review about you !")
        
        push.sendPushInBackgroundWithBlock { (success, error) -> Void in
            if let e = error {
                println("push error")
            } else {
                if success {
                    println("push success")
                } else {
                    println("push not success")
                }
            }
        }
    }
}
