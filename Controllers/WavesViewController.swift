//
//  WavesViewController.swift
//  Splash2
//
//  Created by Keshav Pothireddy on 12/9/18.
//  Copyright © 2018 UWAVES. All rights reserved.
//

import UIKit
import Firebase

class WavesViewController: UIViewController {

    @IBOutlet weak var createMenu: UIView!
    @IBOutlet weak var groupPic: UIImageView!
    @IBOutlet weak var waveName: UITextField!
    @IBOutlet weak var currentWave: UILabel!
    var groupNames = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createMenu.layer.cornerRadius = 12
        groupPic.layer.cornerRadius = groupPic.bounds.height / 2
        groupPic.clipsToBounds = true
        
        let keyboardTap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(keyboardTap)
        view.isUserInteractionEnabled = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)

    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object:nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object:nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object:nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //createMenu.isHidden = true
        createMenu.alpha = 0
        
    }
    
    @objc func keyboardWillChange(notification: Notification) {
        print("Keyboard will show: \(notification.name.rawValue)")
        view.frame.origin.y = -150
    }
    
    @objc func dismissKeyboard (_sender: UITapGestureRecognizer) {
        waveName.resignFirstResponder()
        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin.y = 0
        }
        
    }
    
    @IBAction func createBtn(_ sender: UIButton) {
        // createMenu.isHidden = false
        createMenu.alpha = 1
        
    }
    
    @IBAction func dismissCreate(_ sender: UIButton) {
        //createMenu.isHidden = true
        createMenu.alpha = 0
        waveName.resignFirstResponder()
        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin.y = 0
        }
        
    }
    
    
    @IBAction func createWave(_ sender: UIButton) {
        if waveName.text == "" {
            let alert = UIAlertController(title: "Name your wave", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert,animated: true, completion: nil)
        } else {

            let postRoot = Database.database().reference().child("posts").observe(.value, with: {snapshot in
                for group in snapshot.children {
                    self.groupNames.append((group as AnyObject).key)
                }
                
                if self.groupNames.contains(self.waveName.text!) {
                    
                    let blah = UIAlertController(title: "Wave already exists", message: nil, preferredStyle: .alert)
                    blah.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(blah,animated: true, completion: nil)
                    
                } else {
                    
                    self.createMenu.alpha = 0
                    self.waveName.resignFirstResponder()
                    UIView.animate(withDuration: 0.3) {
                        self.view.frame.origin.y = 0
                    }
                    
                    let confirm = UIAlertController(title: "Wave created", message: nil, preferredStyle: .alert)
                    confirm.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(confirm,animated: true, completion: nil)
                    
                    let postRef = Database.database().reference().child("posts/\(self.waveName.text!)")
                    let songRef = Database.database().reference().child("songs/\(self.waveName.text!)")
                    let waveObject = [
                        "wave-name": self.waveName.text!,
                        ] as [String:Any]
                    
                    postRef.setValue(waveObject, withCompletionBlock: {error, ref in
                        if error == nil {
                            
                        } else {
                            print("error with posting")
                        }
                    })
                    
                    songRef.setValue(waveObject, withCompletionBlock: {error, ref in
                        if error == nil {
                            
                        } else {
                            print("error with posting")
                        }
                    })
                    
                    //self.dismiss(animated: true, completion: nil)
                }
                
            })
            
        }
        
        
        
        
    }
    
    

}
