//
//  WavesViewController.swift
//  Splash2
//
//  Created by Keshav Pothireddy on 12/9/18.
//  Copyright © 2018 UWAVES. All rights reserved.
//

import UIKit
import Firebase

class WavesViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var createMenu: UIView!
    @IBOutlet weak var groupPic: UIImageView!
    @IBOutlet weak var waveName: UITextField!
    @IBOutlet weak var currentWave: UILabel!
    var groupNames = [String]()
    var groupPicURL: String!
    var pickedImage = UIImage()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createMenu.layer.cornerRadius = 12
        groupPic.layer.cornerRadius = groupPic.bounds.height / 2
        groupPic.clipsToBounds = true
        
        let keyboardTap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(keyboardTap)
        view.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleSelectPhoto))
        groupPic.addGestureRecognizer(tapGesture)
        groupPic.isUserInteractionEnabled = true
        
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
        self.groupPic.image = #imageLiteral(resourceName: "default-placeholder")
        self.waveName.text = ""
        
    }
    
    @objc func handleSelectPhoto() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
        }
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.modalPresentationStyle = .overFullScreen
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        self.dismiss(animated: true, completion: nil)
        self.createMenu.alpha = 1
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.groupPic.image = image
            self.pickedImage = image
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
                    
                    let confirm = UIAlertController(title: "Wave created", message: nil, preferredStyle: .alert)
                    confirm.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(confirm,animated: true, completion: { self.createMenu.alpha = 0
                        self.waveName.resignFirstResponder()
                        UIView.animate(withDuration: 0.3) {
                            self.view.frame.origin.y = 0
                        }})
                    
                    guard let uid = Auth.auth().currentUser?.uid else { return }
                    let photoID = UUID().uuidString
                    let storageRef = Storage.storage().reference().child("waves/\(self.waveName.text!)/wavePic")
                    let metaData = StorageMetadata()
                    metaData.contentType = "image/jpg"
                    
                    guard let imageData = self.pickedImage.jpegData(compressionQuality: 1) else {return}
                    
                    let uploadTask = storageRef.putData(imageData, metadata: metaData) {(metadata, error) in
                        if error == nil {
                            storageRef.downloadURL(completion: {(url, error) in
                                if error != nil {
                                    print("error with download url")
                                } else {
                                    self.groupPicURL = url?.absoluteString
                                    self.uploadWaveData()
                                }
                            })
                        }
                    }
                    uploadTask.resume()
                    //self.dismiss(animated: true, completion: nil)
                }
            })
        }
    }
    
    func uploadWaveData() {
        let postRef = Database.database().reference().child("posts/\(self.waveName.text!)")
        let songRef = Database.database().reference().child("songs/\(self.waveName.text!)")
        let waveObject = [
            "waveName": self.waveName.text!,
            "wavePic": self.groupPicURL!
            ] as [String:Any]
        
        postRef.setValue(waveObject, withCompletionBlock: {error, ref in
            if error == nil {
                print("this is the pic: \(self.groupPicURL!)")
                
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
    }
    
    

}
