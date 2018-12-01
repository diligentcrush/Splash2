//
//  PhotoEditorViewController.swift
//  Splash2
//
//  Created by Keshav Pothireddy on 11/25/18.
//  Copyright © 2018 UWAVES. All rights reserved.
//

import UIKit
import Firebase

class PhotoEditorViewController: UIViewController, UIImagePickerControllerDelegate, UITextViewDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var photoCaption: UITextView!
    
    @IBAction func postButton(_ sender: UIButton) {
        
        guard let userProfile = UserService.currentUserProfile else {return}
        
        let postRef = Database.database().reference().child("posts").childByAutoId()
        
        let postObject = [
            "author": [
                "username": userProfile.username,
                "uid": userProfile.uid,
                "photoURL": userProfile.photoURL.absoluteString
            ],
            "text": photoCaption.text,
            "timestamp": [".sv":"timestamp"]
        ] as [String:Any]
        
        postRef.setValue(postObject, withCompletionBlock: {error, ref in
            if error == nil {
                self.dismiss(animated: true, completion: nil)
            } else {
                
            }
        })
    }
    
    
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleSelectPhoto))
        photo.addGestureRecognizer(tapGesture)
        photo.isUserInteractionEnabled = true
        

    }
    
    @IBAction func cancelEdit(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleSelectPhoto() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
        }
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            photo.image = image
        }
        
    }
    
    


}
