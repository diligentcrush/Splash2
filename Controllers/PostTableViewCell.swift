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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImage.layer.cornerRadius = profileImage.bounds.height / 2
        profileImage.clipsToBounds = true
        
        postCard.layer.borderColor = UIColor(red: 255.0/255.0, green: 250.0/255.0, blue: 252.0/255.0, alpha: 1.0).cgColor
        postCard.layer.borderWidth = 0.25
        postCard.layer.cornerRadius = 10
        postCard.clipsToBounds = true
        
   
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
