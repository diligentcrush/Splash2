//
//  PhotoEditorViewController.swift
//  Splash2
//
//  Created by Keshav Pothireddy on 11/25/18.
//  Copyright © 2018 UWAVES. All rights reserved.
//

import UIKit
import Firebase

class PhotoEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {

    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var photoCaption: UITextView!
    
    var imageDbUrl: String?
    var currentText: String!
    
    @IBAction func postButton(_ sender: UIButton) {
        
        guard let userProfile = UserService.currentUserProfile else { return }
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let postRef = Database.database().reference().child("posts/\(uid)").childByAutoId()
        
        let postObject = [
           "author": [
                "uid": userProfile.uid,
                "username": userProfile.username,
                "photoURL": userProfile.photoURL.absoluteString
            ], 
            "text": photoCaption.text,
            "timestamp": [".sv":"timestamp"],
            "imageURL": imageDbUrl as! String
            ] as [String:Any]
        
        postRef.setValue(postObject, withCompletionBlock: { error, ref in
            if error == nil {
                self.dismiss(animated: true, completion: nil)
            } else {
                print("errrrororor")
            }
        })
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleSelectPhoto))
        photo.addGestureRecognizer(tapGesture)
        photo.isUserInteractionEnabled = true
        
        photoCaption.delegate = self
    
        photoCaption.becomeFirstResponder()
        
    
        photoCaption.selectedTextRange = photoCaption.textRange(from: photoCaption.beginningOfDocument, to: photoCaption.endOfDocument)
        

    }
    
    
    func textView(_ photoCaption: UITextView, shouldChangeTextIn range:NSRange, replacementText text:String) -> Bool {
        let currentText:String = photoCaption.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
        
        if updatedText.isEmpty {
            photoCaption.text = "share your thoughts"
            photoCaption.textColor = UIColor.lightGray
            
            photoCaption.selectedTextRange = photoCaption.textRange(from: photoCaption.beginningOfDocument, to: photoCaption.beginningOfDocument)
        } else if photoCaption.textColor == UIColor.lightGray && !text.isEmpty {
            photoCaption.textColor = UIColor.white
            photoCaption.text = text
        } else {
            return true
        }
        return true
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
            
            let photoID = UUID().uuidString
            
            guard let uid = Auth.auth().currentUser?.uid else { return }
            let storageRef = Storage.storage().reference().child("posts/\(uid)/\(photoID)")
            
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpg"
            
            guard let imageData = image.jpegData(compressionQuality: 1) else {return}
            
            let uploadTask = storageRef.putData(imageData, metadata: metaData) { (metadata, error) in
                print("UPLOAD TASK FINISHED")
                print(metadata ?? "NO METADATA")
                print(error ?? "NO ERROR")
                
                storageRef.downloadURL(completion: {(url, error) in
                    if error != nil {
                        print("error with database reference")
                    } else {
                        self.imageDbUrl = url?.absoluteString
                        
                    }
                })
            }
            
            uploadTask.resume()
            
        }
        
    }
    
   
    

}
