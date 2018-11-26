//
//  MainPagerController.swift
//  Splash2
//
//  Created by Keshav Pothireddy on 11/25/18.
//  Copyright © 2018 UWAVES. All rights reserved.
//

import UIKit

class MainPagerController: UIViewController {

    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var songButton: UIButton!
    @IBOutlet weak var createButton: UIButton!
    
    var cameraButtonCenter: CGPoint!
    var songButtonCenter: CGPoint!
    
    private let imageone = UIImage(named: "create_off.png")
    private let imagetwo = UIImage(named: "create_on.png")
    
    override func viewDidLoad() {
        createButton.setImage(imageone, for: .normal)
        
        super.viewDidLoad()
        
        cameraButtonCenter = cameraButton.center
        songButtonCenter = songButton.center
        
        cameraButton.center = createButton.center
        songButton.center = createButton.center

    }
    
    
    
    @IBAction func createClicked(_ sender: UIButton) {

        if createButton.currentImage === imageone {
            UIView.animate(withDuration: 0.3, animations: {
                self.cameraButton.alpha = 1
                self.songButton.alpha = 1
                
                self.cameraButton.center = self.cameraButtonCenter
                self.songButton.center = self.songButtonCenter
                
                self.createButton.setImage(self.imagetwo, for: .normal)
            })
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.cameraButton.alpha = 0
                self.songButton.alpha = 0
                
                self.cameraButton.center = self.createButton.center
                self.songButton.center = self.createButton.center
                
                self.createButton.setImage(self.imageone, for: .normal)
            })
        }
        
        
    }
    
    
}
