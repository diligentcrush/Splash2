//
//  GoToWaveViewController.swift
//  Splash2
//
//  Created by Keshav Pothireddy on 12/13/18.
//  Copyright © 2018 UWAVES. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class GoToWaveViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var waveName: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var followStatus: UIButton!
    var waveLabel: String!
    var wavePicURL: String!
    let imageView = UIImageView()
    var tempPosts = [Post]()
    var items = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getWavePic()
        
        let cellNib = UINib(nibName: "PostTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "postCell")
        
        let songNib = UINib(nibName: "SongTableViewCell", bundle: nil)
        
        tableView.register(songNib, forCellReuseIdentifier: "songCell")
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.contentInset = UIEdgeInsets(top: 300, left: 0, bottom: 0, right: 0)
  
        imageView.frame = CGRect(x: 0, y: 70, width: UIScreen.main.bounds.size.width, height: 300)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        view.addSubview(imageView)
        
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        observeFollowStatus()
        self.waveName.text = self.waveLabel
        
    }
    
    func getWavePic() {
        let waveImageRoot = Storage.storage().reference().child("waves/\(self.waveLabel!)/wavePic")
        
        waveImageRoot.downloadURL(completion: {(url, error) in
            if (error == nil) {
                if let downloadUrl = url {
                    let downloadString = downloadUrl.absoluteString
                    self.imageView.sd_setImage(with: URL(string: downloadString))
                }
            } else {
                print("error again")
            }
        })
        
    }
    
    @IBAction func meBtn(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func followBtn(_ sender: UIButton) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let followRef = Database.database().reference().child("users/profile/\(uid)/myWaves/\(self.waveLabel!)")
        
        let currentFollowStatus = followStatus.currentTitle!
        
        if currentFollowStatus == "follow" {
            followStatus.setTitle("unfollow", for: .normal)
            followStatus.setTitleColor(UIColor(red: 239.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0), for: .normal)
            followRef.setValue(true)
        } else {
            followStatus.setTitle("follow", for: .normal)
            followStatus.setTitleColor(UIColor(red: 0.0/255.0, green: 164.0/255.0, blue: 214.0/255.0, alpha: 1.0), for: .normal)
            followRef.setValue(false)
        }
        
        
    }
   
    func observeFollowStatus() {
        var followIndicator:Bool?
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let followRef = Database.database().reference().child("users/profile/\(uid)/myWaves/\(self.waveLabel!)").observe(.value, with: {(snapshot) in
            
            if let data = snapshot.value as? Bool {
                if data == true {
                    self.followStatus.setTitle("unfollow", for: .normal)
                    self.followStatus.setTitleColor(UIColor(red: 239.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0), for: .normal)
                } else {
                    self.followStatus.setTitle("follow", for: .normal)
                    self.followStatus.setTitleColor(UIColor(red: 0.0/255.0, green: 164.0/255.0, blue: 214.0/255.0, alpha: 1.0), for: .normal)
                }
            }
            
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = 300 - (scrollView.contentOffset.y + 300)
        let height = min(max(y, 0), 400)
        imageView.frame = CGRect(x: 0, y: 70, width: UIScreen.main.bounds.size.width, height: height)
    }
    
    
}
