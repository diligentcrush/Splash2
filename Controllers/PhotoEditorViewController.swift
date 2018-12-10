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
    
    var imageURL: String!
    var currentText: String!
    var pickedImage = UIImage()
    
    @IBAction func postButton(_ sender: UIButton) {
        
        guard let userProfile = UserService.currentUserProfile else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let postRef = Database.database().reference().child("posts").childByAutoId()
        let photoID = UUID().uuidString
        let storageRef = Storage.storage().reference().child("posts/\(uid)/\(photoID)")
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        guard let imageData = pickedImage.jpegData(compressionQuality: 1) else {return}
        
        let uploadTask = storageRef.putData(imageData, metadata: metaData) {(metadata, error) in
            if error == nil {
                storageRef.downloadURL(completion: {(url, error) in
                    if error != nil {
                        print("error with database reference")
                    } else {
                        self.imageURL = url?.absoluteString
                        
                        let postObject = [
                            "author": [
                                "uid": userProfile.uid,
                                "username": userProfile.username,
                                "photoURL": userProfile.photoURL.absoluteString
                            ],
                            "text": self.photoCaption.text,
                            "imageURL": self.imageURL as! String!,
                            "timestamp": [".sv":"timestamp"],
                            ] as [String:Any]
                        
                        postRef.setValue(postObject, withCompletionBlock: { error, ref in
                            if error == nil {
                                self.dismiss(animated: true, completion: nil)
                            } else {
                                print("error uploading")
                            }
                        })
                        
                    }
                })
            } else {
                print("total fuken error")
            }
        }
        
        uploadTask.resume()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleSelectPhoto))
        photo.addGestureRecognizer(tapGesture)
        photo.isUserInteractionEnabled = true
        
        let keyboardTap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(keyboardTap)
        view.isUserInteractionEnabled = true
        
        // photoCaption.becomeFirstResponder()
        photoCaption.selectedTextRange = photoCaption.textRange(from: photoCaption.beginningOfDocument, to: photoCaption.endOfDocument)
        photoCaption.delegate = self
        
        photo.clipsToBounds = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)

    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object:nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object:nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object:nil)
    }
    
    @objc func keyboardWillChange(notification: Notification) {
        print("Keyboard will show: \(notification.name.rawValue)")
        view.frame.origin.y = -150
    }
    
   
    @objc func dismissKeyboard (_sender: UITapGestureRecognizer) {
        photoCaption.resignFirstResponder()
        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin.y = 0
        }
    
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
            pickedImage = image
            
        
    }

}
}
