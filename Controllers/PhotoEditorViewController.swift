//
//  PhotoEditorViewController.swift
//  Splash2
//
//  Created by Keshav Pothireddy on 11/25/18.
//  Copyright © 2018 UWAVES. All rights reserved.
//

import UIKit
import Firebase

class PhotoEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var photoCaption: UITextView!
    
    @IBAction func postButton(_ sender: UIButton) {
        

        guard let userProfile = UserService.currentUserProfile else { return }
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let postRef = Database.database().reference().child("posts/\(uid)")
        
        let postObject = [
           "author": [
                "uid": userProfile.uid,
                "username": userProfile.username,
                "photoURL": userProfile.photoURL.absoluteString
            ], 
            "text": photoCaption.text,
            "timestamp": [".sv":"timestamp"],
            ] as [String:Any]
        
        postRef.setValue(postObject, withCompletionBlock: { error, ref in
            if error == nil {
                self.dismiss(animated: true, completion: nil)
            } else {
                // Handle the error
            }
        })
    }
    
    
    
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
            
            guard let uid = Auth.auth().currentUser?.uid else { return }
            let storageRef = Storage.storage().reference().child("user/\(uid)/posts")
            let databaseRef = Database.database().reference().child("posts/\(uid)/media")
            
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpg"
            
            guard let imageData = image.jpegData(compressionQuality: 1) else {return}
            
            let uploadTask = storageRef.putData(imageData, metadata: metaData) { (metadata, error) in
                print("UPLOAD TASK FINISHED")
                print(metadata ?? "NO METADATA")
                print(error ?? "NO ERROR")
            
            }
            
            uploadTask.resume()
            
        }
        
    }
    
/**
    func uploadImage(_ image:UIImage, completion: @escaping ((_ url:URL?)->())) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let storageRef = Storage.storage().reference().child("user/\(uid)/posts")
        
        guard let imageData = image.jpegData(compressionQuality: 1) else { return }
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        storageRef.putData(imageData, metadata: metaData) { metaData, error in
            if error == nil, metaData != nil {
                storageRef.downloadURL { url, error in
                    completion(url)
                }
            } else {
                completion (nil)
            }
        }
    }
    
    func saveImage(imageURL:URL, completion: @escaping ((_
        success: Bool)->())) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let databaseRef = Database.database().reference().child("posts/\(uid)/media")
        
        let postObject = [
            "photoURL": imageURL.absoluteString
        ] as [String:Any]
        
        databaseRef.setValue(postObject) {error, ref in
            completion(error == nil)
        }

        
    }

    
 
 guard let userProfile = UserService.currentUserProfile else { return }
 
 let postRef = Database.database().reference().child("posts").childByAutoId()
 
 let postObject = [
 "author": [
 "uid": userProfile.uid,
 "username": userProfile.username,
 "photoURL": userProfile.photoURL.absoluteString
 ],
 "text": photoCaption.text,
 "timestamp": [".sv":"timestamp"],
 ] as [String:Any]
 
 postRef.setValue(postObject, withCompletionBlock: { error, ref in
 if error == nil {
 self.dismiss(animated: true, completion: nil)
 } else {
 // Handle the error
 }
 })
 */
}
