//
//  SongTableViewCell.swift
//  Splash2
//
//  Created by Keshav Pothireddy on 12/6/18.
//  Copyright © 2018 UWAVES. All rights reserved.
//

import UIKit

class SongTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    
    var profileLink: URL!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        profileImage.layer.cornerRadius = profileImage.bounds.height / 2
        profileImage.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)


    }
    
    func set(song:Song) {
        
        usernameLabel.text = song.author.username
        captionLabel.text = song.text
        self.profileLink = song.author.photoURL
        self.profileImage.sd_setImage(with: profileLink)
        timestampLabel.text = song.createdAt.calenderTimeSinceNow()
    }
   
}
