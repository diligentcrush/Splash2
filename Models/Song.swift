//
//  Song.swift
//  Splash2
//
//  Created by Keshav Pothireddy on 12/6/18.
//  Copyright © 2018 UWAVES. All rights reserved.
//

import Foundation

class Song {
    var id:String
    var author:UserProfile
    var text:String
    var createdAt: Date
    
    init(id:String, author:UserProfile, text:String, timestamp: Double) {
        self.id = id
        self.author = author
        self.text = text
        self.createdAt = Date(timeIntervalSince1970: timestamp / 1000)

    }
}
