//
//  Item.swift
//  Splash2
//
//  Created by Keshav Pothireddy on 12/8/18.
//  Copyright © 2018 UWAVES. All rights reserved.
//

import Foundation

class Item: Equatable, Comparable {
    static func < (lhs: Item, rhs: Item) -> Bool {
        return lhs.createdAt.timeIntervalSinceReferenceDate > rhs.createdAt.timeIntervalSinceReferenceDate
    }
    
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
    
    static func ==(lhs: Item, rhs: Item) -> Bool {
        return lhs.id == rhs.id
    }
}
