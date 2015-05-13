//
//  FRUser.swift
//  ITSeminerTest
//
//  Created by Cem Olcay on 25/02/15.
//  Copyright (c) 2015 Cem Olcay. All rights reserved.
//

import UIKit

class FRUser {
    
    // MARK: Properties
    
    var objectId: String!
    var facebookId: String!
    var firstName: String?
    var lastName: String?

    var pfUser: PFUser!
    
    
    // MARK: Init
    
    init (user: PFUser) {
        facebookId = user.objectForKey("facebookId") as! String
        firstName = user.objectForKey("firstName") as? String
        lastName = user.objectForKey("lastName") as? String
        objectId = user.objectId
        pfUser = user
    }

    
    // MARK: Helpers
    
    func getName () -> String? {
        if let f = firstName {
            return firstName! + " " + lastName!
        } else {
            return nil
        }
    }
    
    func getImage (success: (UIImage) -> Void) {
        FBRequestConnection.startWithGraphPath(
            facebookId + "/picture",
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
                    imageRequest(url, { (image) -> Void in
                        if let i = image {
                            success (i)
                        }
                    })
                }
        }
    }
    
    func getUser (success: (PFUser) -> Void) {
        let query = PFUser.query()
        query.whereKey("facebookId", equalTo: facebookId)
        query.getFirstObjectInBackgroundWithBlock { (object, error) -> Void in
            if let e = error {
                println("cant get user from facebook id")
            } else {
                success (object as! PFUser)
            }
        }
    }
    
    func getReviews (success: ([FRReview]) -> Void) {
        let query = PFQuery(className: "Review")
        query.includeKey("Author")
        query.includeKey("User")
        query.whereKey("User", equalTo: pfUser)
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if let e = error {
                println("cant get reviews of user")
            } else {
                success (objects.map( {FRReview (pfObject: $0 as! PFObject)} ))
            }
        }
    }
    
    class func currentUser () -> FRUser {
        return FRUser (user: PFUser.currentUser())
    }
    
}
