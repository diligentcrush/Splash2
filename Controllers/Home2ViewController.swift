//
//  Home2ViewController.swift
//  Splash2
//
//  Created by Keshav Pothireddy on 11/29/18.
//  Copyright © 2018 UWAVES. All rights reserved.
//

import UIKit
import Foundation

class Home2ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var tableView: UITableView!
    
    var posts = [
        Post(id: "1", author: "Travis Scott", text: "I'm not motherfuckin ASAP bitch!!"),
        Post(id: "2", author: "Kanye West", text: "I don't care about black people"),
        Post(id: "3", author: "Lil Pump", text: "ESKETTITTTTT")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let cellNib = UINib(nibName: "PostTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "postCell")
        
        // view.addSubview(tableView)

        
        
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()

    }
    
    
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
