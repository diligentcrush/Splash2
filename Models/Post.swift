//
//  Post.swift
//  Splash2
//
//  Created by Keshav Pothireddy on 11/30/18.
//  Copyright © 2018 UWAVES. All rights reserved.
//

import Foundation



class Post:Item {

    var imageURL:String

    init(id: String, author: UserProfile, text: String, timestamp: Double, imageURL:String) {
        self.imageURL = imageURL
        super.init(id: id, author: author, text: text, timestamp: timestamp)
    }
}
