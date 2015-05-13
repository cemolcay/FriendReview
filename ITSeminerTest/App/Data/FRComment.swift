//
//  FRComment.swift
//  ITSeminerTest
//
//  Created by Cem Olcay on 25/02/15.
//  Copyright (c) 2015 Cem Olcay. All rights reserved.
//

import UIKit

class FRComment {
    
    // MARK: Properties

    var author: FRUser!
    var text: String!
    var date: String!
    
    
    // MARK: Init
    
    init (pfObject: PFObject) {
        author = FRUser (user: pfObject.objectForKey("Author") as! PFUser)
        text = pfObject.objectForKey("Text") as! String
        date = pfObject.createdAt.toString("dd/MM/yyyy hh:mm")
    }
}
