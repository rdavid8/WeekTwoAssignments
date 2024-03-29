//
//  User.swift
//  Twitter Clone
//
//  Created by Lacey Vu on 2/8/16.
//  Copyright © 2016 Lacey Vu. All rights reserved.
//

import Foundation

class User
{
    let name: String
    let profileImageUrl: String
    let location: String
    let screenName: String?
    
    init(name: String, profileImageUrl: String, location: String, screenName: String? = nil)
    {
        self.name = "@\(name)"
        self.profileImageUrl = profileImageUrl
        self.location = location
        self.screenName = screenName
        
    }
}