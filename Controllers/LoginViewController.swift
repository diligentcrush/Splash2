//
//  LoginViewController.swift
//  Splash2
//
//  Created by Keshav Pothireddy on 11/25/18.
//  Copyright © 2018 UWAVES. All rights reserved.
//

import UIKit
import Firebase
class LoginViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var goButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        goButton.addTarget(self, action: #selector(handleSignIn), for: .touchUpInside)
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @objc func handleSignIn() {
        guard let email = emailField.text else {return}
        guard let password = passwordField.text else {return}
        
        Auth.auth().signIn(withEmail: email, password: password) { user, error in
            if error == nil && user != nil {
                self.dismiss(animated: false, completion: nil)
            } else {
                print("Error logging in: \(error!.localizedDescription)")
                
                self.resetForm()
            }
            
        }
    }
    
    func resetForm() {
    let alert = UIAlertController(title: "Error logging in", message: nil, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
    self.present(alert, animated: true, completion: nil)
    
    }

}
