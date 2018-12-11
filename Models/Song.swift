//
//  Song.swift
//  Splash2
//
//  Created by Keshav Pothireddy on 12/6/18.
//  Copyright © 2018 UWAVES. All rights reserved.
//

import Foundation

class Song:Item {
    override init(id: String, author: UserProfile, text: String, timestamp: Double) {
        super.init(id: id, author: author, text: text, timestamp: timestamp)
    }
}

