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
    
    init(id:String, author:String, text:String) {
        self.id = id
        self.author = author
        self.text = text
    }
}
