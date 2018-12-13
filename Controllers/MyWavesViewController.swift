//
//  MyWavesViewController.swift
//  Splash2
//
//  Created by Keshav Pothireddy on 12/12/18.
//  Copyright © 2018 UWAVES. All rights reserved.
//

import UIKit
import Foundation
import Firebase

class MyWavesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet  var tableView: UITableView!
    
    var groupNames = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    let cellNib = UINib(nibName: "MyWavesTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "myWaveCell")
        
    self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    self.tableView.backgroundColor = UIColor(red: 9.0/255.0, green: 9.0/255.0, blue: 9.0/255.0, alpha: 1.0)
        
    tableView.delegate = self
    tableView.dataSource = self
        
    self.getWaveNames()
        
    }
    
   /** override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.getWaveNames()
    }**/
    
   /** override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.getWaveNames()
    }**/
    
    func getWaveNames() {
        let postRoot = Database.database().reference().child("posts").observe(.value , with: {snapshot in
            
            var tempNames = [String]()
            
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                    let dict = childSnapshot.value as? [String:Any],
                    let waveName = dict["waveName"] as? String {
                    tempNames.append(waveName as String)
                }
            }
            
            DispatchQueue.main.async {
                self.groupNames.append(contentsOf: tempNames)
                self.tableView.reloadData()
            }
            
            //print(self.groupNames)
            
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.groupNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "myWaveCell", for: indexPath) as! MyWavesTableViewCell
        
        // cell.waveName.setTitle(self.groupNames[indexPath.row], for:  )
        cell.waveName.setTitle(self.groupNames[indexPath.row], for: .normal )
        
        return cell
    }


}
