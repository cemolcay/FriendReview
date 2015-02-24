//
//  FacebookUser.swift
//  ITSeminerTest
//
//  Created by Cem Olcay on 24/02/15.
//  Copyright (c) 2015 Cem Olcay. All rights reserved.
//

import UIKit

class FacebookUser {
    
    var locale: String?
    var link: String?
    var lastName: String?
    var gender: String?
    var id: String?
    var updatedTime: String?
    var name: String?
    var verified: String?
    var firstName: String?
    var email: String?
    var timezone: String?
    
    init (data: [String: AnyObject]) {
        locale = data["locale"] as? String
        link = data["link"] as? String
        lastName = data["last_name"] as? String
        gender = data["gender"] as? String
        id = data["id"] as? String
        updatedTime = data["updated_time"] as? String
        name = data["name"] as? String
        verified = data["verified"] as? String
        firstName = data["first_name"] as? String
        email = data["email"] as? String
        timezone = data["timezone"] as? String
    }
}
