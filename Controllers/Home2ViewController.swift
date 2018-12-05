//
//  Home2ViewController.swift
//  Splash2
//
//  Created by Keshav Pothireddy on 11/29/18.
//  Copyright © 2018 UWAVES. All rights reserved.
//

import UIKit
import Foundation
import Firebase

class Home2ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet var tableView: UITableView!
    
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // tableView = UITableView(frame: view.bounds, style: .plain)
        
        let cellNib = UINib(nibName: "PostTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "postCell")
        
        // view.addSubview(tableView)
        
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        viewDidAppear()

    }
    
    func viewDidAppear() {
        observePosts()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    func observePosts() {
        let postRef = Database.database().reference().child("posts")
        
        postRef.observe(.value , with: {snapshot in
            
            var tempPosts = [Post]()
            
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                    let dict = childSnapshot.value as? [String:Any],
                    let author = dict["author"] as? [String:Any],
                    let uid = author["uid"] as? String,
                    let username = author["username"] as? String,
                    let photoURL = author["photoURL"] as? String,
                    let url = URL(string: photoURL),
                    let imageURL = dict["imageURL"] as? String,
                    let text = dict["text"] as? String,
                    let timestamp = dict["timestamp"] as? Double {
                    
                    let userProfile = UserProfile(uid: uid, username: username, photoURL: url)
                    let post = Post(id: childSnapshot.key, author: userProfile, text: text, timestamp: timestamp, imageURL: imageURL)
                    
                    tempPosts.append(post)
    
                    
                    }
            }
            
            self.posts = tempPosts
            self.tableView.reloadData()
        })
    }
    
    /** func updateProfiles() {
        
        let postRef = Database.database().reference().child("posts")
        postRef.observe(.childChanged, with: {snapshot in
            
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                let dict = childSnapshot.value as? [String:Any],
                let author = dict["author"] as? [String:Any],
                    let photoURL = author["photoURL"] as? String,
                    let uid = author["uid"] as? String,
                    let url = URL(string: photoURL),
                    let username = author["username"] as? String {
                   
                    let userProfile = UserProfile(uid: uid, username: username, photoURL: url)
                }
            }
        })
    } **/
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! PostTableViewCell
        cell.set(post: posts[indexPath.row])
        return cell
    }

}
