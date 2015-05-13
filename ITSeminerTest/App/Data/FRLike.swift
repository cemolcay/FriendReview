//
//  FRLike.swift
//  ITSeminerTest
//
//  Created by Cem Olcay on 26/02/15.
//  Copyright (c) 2015 Cem Olcay. All rights reserved.
//

import UIKit

class FRLike {
    
    // MARK: Properties
   
    var user: FRUser!
    
    
    // MARK: Init
    
    init (pfObject: PFObject) {        
        let u = pfObject.objectForKey("User") as! PFUser
        user = FRUser (user: u)
    }
    
    
    // MARK: Helpers
    
    func didLiked () -> Bool {
        return user.objectId == PFUser.currentUser().objectId
    }
}
