//
//  FRReview.swift
//  ITSeminerTest
//
//  Created by Cem Olcay on 25/02/15.
//  Copyright (c) 2015 Cem Olcay. All rights reserved.
//

import UIKit

class FRReview {
    
    // MARK: Properties
    
    var author: FRUser!
    var user: FRUser!
    
    var text: String!
    var date: String!

    var commentRelation: PFRelation!
    var likeRelation: PFRelation!
    
    var pfObject: PFObject!
    
    
    // MARK: Init
    
    init (pfObject: PFObject) {
        author = FRUser (user: pfObject.objectForKey("Author") as! PFUser)
        user = FRUser (user: pfObject.objectForKey("User") as! PFUser)
        text = pfObject.objectForKey("Text") as! String
        commentRelation =  pfObject.relationForKey("Comments")
        likeRelation = pfObject.relationForKey("Likes")
        date = pfObject.createdAt.toString("dd/MM/yyyy hh:mm")
        self.pfObject = pfObject
    }
    
    
    // MARK: Helpers
    
    func getComments (success: (comments: [FRComment]) -> Void) {
        let query = commentRelation.query()
        query.includeKey("Author")
        query.includeKey("User")
        query.findObjectsInBackgroundWithBlock {
            [unowned self] (objects, error) -> Void in
            if let e = error {
                println("cant get comments of review")
                println(e.description)
            } else {
                var comments: [FRComment] = []
                for obj in objects {
                    let comment = FRComment (pfObject: obj as! PFObject)
                    comments.append(comment)
                }
                
                success (comments: comments)
            }
        }
    }

    func getLikes (success: (likes: [FRLike], didLike: Bool) -> Void) {
        let query = likeRelation.query()
        query.includeKey("User")
        query.findObjectsInBackgroundWithBlock {
            [unowned self] (objects, error) -> Void in
            if let e = error {
                println("get review likes error")
            } else {
                var likes: [FRLike] = []
                var didLike: Bool = false
                
                for obj in objects {
                    let like = FRLike (pfObject: obj as! PFObject)
                    likes.append(like)
                    
                    if like.didLiked() {
                        didLike = true
                    }
                }
                success (likes: likes, didLike: didLike)
            }
        }
    }

    func likeReview (success: () -> Void) {
        let like = PFObject (className: "Like")
        like.setObject(PFUser.currentUser(), forKey: "User")
        like.saveInBackgroundWithBlock {
            [unowned self] (saved, error) -> Void in
            if let e = error {
                println("like error")
            } else {
                if saved {
                    
                    self.likeRelation.addObject(like)
                    self.pfObject.saveInBackgroundWithBlock({ (relationSaved, relationError) -> Void in
                        if let e = relationError {
                            println("like relation error")
                        } else {
                            if relationSaved {
                                success()
                            } else {
                                println("like relation not succeed")
                            }
                        }
                    })
                    
                } else {
                    println("like not succeed")
                }
            }
        }
    }
}
