//
//  OtherProfileViewController.swift
//  Splash2
//
//  Created by Keshav Pothireddy on 12/6/18.
//  Copyright © 2018 UWAVES. All rights reserved.
//

import UIKit

class OtherProfileViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    @IBAction func dismissBtn(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
