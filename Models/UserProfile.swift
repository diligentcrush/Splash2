//
//  UserProfile.swift
//  Splash2
//
//  Created by Keshav Pothireddy on 11/30/18.
//  Copyright © 2018 UWAVES. All rights reserved.
//

import Foundation

class UserProfile {
    var uid:String
    var username:String
    var photoURL:URL
    
    init(uid:String, username:String, photoURL:URL) {
        self.uid = uid
        self.username = username
        self.photoURL = photoURL
    }
}
