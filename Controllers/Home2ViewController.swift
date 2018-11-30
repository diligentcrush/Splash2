//
//  Home2ViewController.swift
//  Splash2
//
//  Created by Keshav Pothireddy on 11/29/18.
//  Copyright © 2018 UWAVES. All rights reserved.
//

import UIKit
import Foundation

class Home2ViewController: UIViewController {

    @IBOutlet weak var diveBar: UIView!
    @IBOutlet weak var boxbox: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var layoutGuide:UILayoutGuide!
        layoutGuide = view.safeAreaLayoutGuide
        

        boxbox.backgroundColor = UIColor.blue
        
        // tableView.leadingAnchor.constraint(equalTo: containerPane.leadingAnchor).isActive = true
        // tableView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor).isActive = true
        

    }
    

}
