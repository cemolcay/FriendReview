//
//  FacebookFriend.swift
//  ITSeminerTest
//
//  Created by Cem Olcay on 24/02/15.
//  Copyright (c) 2015 Cem Olcay. All rights reserved.
//

import UIKit

class FacebookFriend {
    
    var firstName: String!
    var lastName: String!
    var id: String!
    var imageUrl: String!
    
    init (data: [String: AnyObject]) {
        firstName = data["first_name"] as! String
        lastName = data["last_name"] as! String
        id = data["id"] as! String
        
        let picture = data["picture"] as! [String: AnyObject]
        let d = picture["data"] as! [String: AnyObject]
        imageUrl = d["url"] as! String
    }
    
    func getPFUser (success: (PFUser)->Void) {
        let query = PFUser.query()
        query.whereKey("facebookId", equalTo: id)
        query.getFirstObjectInBackgroundWithBlock { (user, error) -> Void in
            if let e = error {
                println("get pfuser error")
            } else {
                success (user as! PFUser)
            }
        }
    }
    
    func getUserReviewsCount (success: (reviewCount: Int, commentCount: Int)->Void) {
        return success (reviewCount: 10, commentCount: 3)
        
        getPFUser { (user: PFUser) -> Void in
            let reviewRelation = user.relationForKey("Reviews")
            reviewRelation.query().findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                if let e = error {
                    println("review relation error")
                } else {
                    let reviewCount = objects.count
                    
                    for obj in objects {
                        let review = obj as! PFObject
                        let commentRelation = review.relationForKey("Comments")
                        commentRelation.query().findObjectsInBackgroundWithBlock ({ (commentObjects, commentError) -> Void in
                            if let e = commentError {
                                println("comment relation error")
                            } else {
                                let commentCount = commentObjects.count
                                success (reviewCount: reviewCount, commentCount: commentCount)
                            }
                        })
                    }
                }
            })
        }
    }
}
