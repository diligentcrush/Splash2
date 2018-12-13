//
//  MyWavesTableViewController.swift
//  
//
//  Created by Keshav Pothireddy on 12/11/18.
//
/**
import UIKit
import Firebase

class MyWavesTableViewController: UITableViewController {
        
    var groupNames = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cellNib = UINib(nibName: "MyWavesTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "myWaveCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getWaveNames()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.groupNames.count
        
    }
    
    /** func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myWaveCell", for: indexPath as IndexPath) as! MyWavesTableViewCell
        
        cell.waveName!.text = self.groupNames[indexPath.row]
        
        return cell
    } **/
    
    
    func getWaveNames() {
        let postRoot = Database.database().reference().child("posts").observe(.value, with: {snapshot in
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                let dict = childSnapshot.value as? [String:Any],
                let waveName = dict["waveName"] as? String {
                    self.groupNames.append(waveName as String)
                }
                // self.groupNames.append((child as AnyObject).key)
            
            
            }
            
            print(self.groupNames)
        
            
        })
    }
    
    /** for child in snapshot.children {
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
    
    self.tempPosts.append(post)
    
    } **/
    
}
**/
