//
//  MyWavesTableViewCell.swift
//  Splash2
//
//  Created by Keshav Pothireddy on 12/11/18.
//  Copyright © 2018 UWAVES. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

protocol WaveDelegate: NSObjectProtocol {
    func didTapWaveName(name: String)
}
class MyWavesTableViewCell: UITableViewCell {
    //var delegate: MyWavesCellDelegate
    
   @IBOutlet weak var waveName: UIButton!
    @IBOutlet weak var wavePic: UIImageView!
    var wavePicURL: String!
    @IBOutlet weak var waveLabel: UILabel!
    
    weak var delegate: WaveDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        wavePic.layer.cornerRadius = wavePic.bounds.height / 2
        wavePic.clipsToBounds = true

        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func waveName(_ sender: UIButton) {
        delegate?.didTapWaveName(name: waveName.currentTitle!)
    }
    
}


