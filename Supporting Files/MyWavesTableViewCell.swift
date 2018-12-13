//
//  MyWavesTableViewCell.swift
//  Splash2
//
//  Created by Keshav Pothireddy on 12/11/18.
//  Copyright © 2018 UWAVES. All rights reserved.
//

import UIKit

class MyWavesTableViewCell: UITableViewCell {

   @IBOutlet weak var waveName: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    @IBAction func waveName(_ sender: UIButton) {
        print("tap")
    }
}
