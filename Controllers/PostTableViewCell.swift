//
//  PostTableViewCell.swift
//  Splash2
//
//  Created by Keshav Pothireddy on 11/25/18.
//  Copyright © 2018 UWAVES. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postCard: UIView!
    
    var pictureLink: String!
    var profileLink: URL!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImage.layer.cornerRadius = profileImage.bounds.height / 2
        profileImage.clipsToBounds = true
        
        // postCard.layer.borderColor = UIColor(red: 255.0/255.0, green: 250.0/255.0, blue: 252.0/255.0, alpha: 0.8).cgColor
        // postCard.layer.borderWidth = 0.4
        postCard.layer.cornerRadius = 15
        postCard.clipsToBounds = true
        
        postImage.clipsToBounds = true
        
   
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func set(post:Post) {
        
        usernameLabel.text = post.author.username
        captionLabel.text = post.text
        self.pictureLink = post.imageURL
        self.postImage.sd_setImage(with: URL(string: pictureLink))
        self.profileLink = post.author.photoURL
        self.profileImage.sd_setImage(with: profileLink)
        timestampLabel.text = post.createdAt.calenderTimeSinceNow()
    }
    
}
