//
//  SignUpViewController.swift
//  Splash2
//
//  Created by Keshav Pothireddy on 11/24/18.
//  Copyright © 2018 UWAVES. All rights reserved.
//

import UIKit
import Foundation
import Firebase

class SignUpViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var goButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        goButton.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)

    }
    
    @IBAction func backButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @objc func handleSignUp() {
        guard let username = usernameField.text else {return}
        guard let email = emailField.text else {return}
        guard let password = passwordField.text else {return}
        
        Auth.auth().createUser(withEmail: email, password: password) { user, error in
            if error == nil && user != nil {
                print("User created!")
                
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                    changeRequest?.displayName = username
                changeRequest?.commitChanges { error in
                    if error == nil {
                        print("User display name changed!")
                        
                        self.saveProfile(username: username) { success in
                            if success {
                                self.dismiss(animated: true, completion: nil)
                            }
                        }
                    }
                }
            } else {
                self.resetForm()
            }
            
        }
    }
  
    func saveProfile(username:String, completion: @escaping ((_ success:Bool)->())) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let databaseRef = Database.database().reference().child("users/profile/\(uid)")
        
        let userObject = [
            "username": username
        ] as [String:Any]
        
        databaseRef.setValue(userObject) { error, ref in
            completion(error == nil)
        }
    }
    
    func resetForm() {
        let alert = UIAlertController(title: "Error logging in", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }

}
