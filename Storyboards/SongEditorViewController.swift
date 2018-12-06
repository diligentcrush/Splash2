//
//  SongEditorViewController.swift
//  Splash2
//
//  Created by Keshav Pothireddy on 12/6/18.
//  Copyright © 2018 UWAVES. All rights reserved.
//

import UIKit
import Firebase

class SongEditorViewController: UIViewController {

    @IBOutlet weak var captionField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()


    }
    
    @IBAction func dismissBtn(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func postBtn(_ sender: UIButton) {
        
        guard let userProfile = UserService.currentUserProfile else { return }
        
        // guard let uid = Auth.auth().currentUser?.uid else { return }
        let postRef = Database.database().reference().child("songs").childByAutoId()
        
        let postObject = [
            "author": [
                "uid": userProfile.uid,
                "username": userProfile.username,
                "photoURL": userProfile.photoURL.absoluteString
            ],
            "text": captionField.text,
            "timestamp": [".sv":"timestamp"],
            ] as [String:Any]
        
        postRef.setValue(postObject, withCompletionBlock: { error, ref in
            if error == nil {
                self.dismiss(animated: true, completion: nil)
            } else {
                print("errrrororor")
            }
        })
        
    }
    
}
