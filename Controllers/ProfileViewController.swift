//
//  ProfileViewController.swift
//  Splash2
//
//  Created by Keshav Pothireddy on 11/29/18.
//  Copyright © 2018 UWAVES. All rights reserved.
//

import UIKit
import SideMenu
import Firebase
import FirebaseUI
import SDWebImage
import Kingfisher

class ProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var imagePicker:UIImagePickerController!
    
    let yeet: [UIImage] = [
        
    UIImage(named: "default-placeholder")!,
    UIImage(named: "invert_placeholder")!,
    
    UIImage(named: "invert_placeholder")!,
    UIImage(named: "default-placeholder")!,
    
    UIImage(named: "default-placeholder")!,
    UIImage(named: "invert_placeholder")!,
    
    UIImage(named: "default-placeholder")!,
    UIImage(named: "invert_placeholder")!,
    
    UIImage(named: "invert_placeholder")!,
    UIImage(named: "default-placeholder")!,
    
    UIImage(named: "default-placeholder")!,
    UIImage(named: "invert_placeholder")!,

    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameLabel.text = Auth.auth().currentUser?.displayName
        
        profileImage.layer.cornerRadius = profileImage.bounds.height / 2
        profileImage.clipsToBounds = true
        
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(openImagePicker))
        profileImage.isUserInteractionEnabled = true
        profileImage.addGestureRecognizer(imageTap)
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
        setupSideMenu()
        getProfileImage()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        var layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: 0,left: 5,bottom: 0,right: 5)
        layout.minimumInteritemSpacing = 5
        layout.itemSize = CGSize(width: (self.collectionView.frame.size.width - 20)/2, height: self.collectionView.frame.size.height/3)
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section:Int) -> Int {
        return yeet.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! profileCell
        cell.collectPic.image = yeet[indexPath.item]
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 0.5

        return cell
    }
    
    @objc func openImagePicker(_ sender:Any) {
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    
    func setupSideMenu() {
        SideMenuManager.default.menuRightNavigationController = storyboard!.instantiateViewController(withIdentifier: "RightMenuNavigationController") as? UISideMenuNavigationController
        
        SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.view, forMenu: .right)
    
    }
    
    func getProfileImage(){
        
       // var imageUrl: String
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let imageRef = Storage.storage().reference().child("user/\(uid)/profile-photo")
        
        imageRef.downloadURL(completion: {(url, error) in
            if (error == nil) {
                if let downloadUrl = url {
                    let downloadString = downloadUrl.absoluteString
                    self.profileImage.sd_setImage(with: URL(string: downloadString))
                }
            } else {
                print("error again shit")
            }
        })
        
        
    }
    

}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        
        
        self.uploadProfileImage(image) { url in
            
            if url != nil {
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        
                changeRequest?.photoURL = url
                
                changeRequest?.commitChanges { error in
                    if error == nil {
                        print ("Image changed!")
                        
                        self.saveProfile(profileImageURL: url!) {
                            success in
                            if success {
                                picker.dismiss(animated:true, completion: nil)
                                
                                self.getProfileImage()
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    func uploadProfileImage(_ image:UIImage, completion: @escaping ((_ url:URL?)->())) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        // let randImageName = UUID().uuidString
        let storageRef = Storage.storage().reference().child("user/\(uid)/profile-photo")
        
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
    
    func saveProfile(profileImageURL:URL, completion: @escaping ((_
        success: Bool)->())) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        guard let myuser = Auth.auth().currentUser?.displayName else {return}
        
        let databaseRef = Database.database().reference().child("users/profile/\(uid)")
        
        let userObject = [
            "username": myuser,
            "photoURL": profileImageURL.absoluteString
            ] as [String:Any]
        
        databaseRef.setValue(userObject) {error, ref in
            completion(error == nil)
        }
    
    }
    
}

// ------------------------------------ ALBUM ------------------------------------------
