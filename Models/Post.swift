//
//  Post.swift
//  Splash2
//
//  Created by Keshav Pothireddy on 11/30/18.
//  Copyright © 2018 UWAVES. All rights reserved.
//

import Foundation

class Post {
    var id:String
    var author:String
    var text:String
    var timestamp: Double
    var imageURL: String
    
    init(id:String, author:String, text:String, timestamp: Double, imageURL: String) {
        self.id = id
        self.author = author
        self.text = text
        self.timestamp = timestamp
        self.imageURL = imageURL
    }
}
